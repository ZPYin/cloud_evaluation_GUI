function [data] = PLidar_read_data(mDate, folder, dVersion, hRange, tRange)
%PLidar_read_data read Polarization lidar data.
%Example:
%   [data] = PLidar_read_data(mDate, folder, dVersion, hRange)
%Inputs:
%   mDate: datenum
%       measurement date.
%   folder: char
%       folder of the lidar data.
%   dVersion: integer
%       data version.
%           1: 30 m resolution data
%           2: 3.75 m resolution data
%   hRange: 2-element array
%       bottom and top of the range you want to load. (m)
%   tRange: 2-element array
%       temporal range for data profiles.
%Outputs:
%   data: struct
%       height: array
%           height of each bin above ground. (m)
%       altitude: array
%           height above mean sea surface of each bin. (m)
%       time: datenum
%           measurement time of each profile.
%       recors: array
%           accumulated records for each single profile.
%       CH1_PC: matrix (height * time)
%           photon count rate data for CH1 at parallel channel without background
%           (MHz)
%       CH2_PC: matrix (height * time)
%           photon count rate data for CH2 at cross channel without background
%           (MHz)
%       CH1_BG: array
%           background values in photon count rate for CH1. (MHz)
%       CH2_BG: array
%           background values in photon count rate for CH2. (MHz)
%       CH1_overflow: matrix (height * time)
%           overflow flag for CH1. ('1' means overflowed)
%       CH2_overflow: matrix (height * time)
%           overflow flag for CH2. ('2' means overflowed)
%History:
%   2020-03-15. First Edition by Zhenping
%Contact:
%   zp.yin@whu.edu.cn

if nargin < 4
    error('Not enough inputs');
end

if ~ exist(folder, 'dir')
    error('PLidar data folder does not exist!\n%s', folder);
end

data = struct();

switch dVersion
case 1
    % 30-m resolution
    dataFile = fullfile(folder, sprintf('%s.h5', datestr(mDate, 'yyyymmdd')));

    if exist(dataFile, 'file') ~= 2
        warning('PLidar data file does not exist.\n%s', dataFile);
        return;
    end

    height = (1:2048) * 30;   % [m]
    mTime = mDate + datenum(0, 1, 0, 0, 0:(1440 - 1), 0);
    hIndx = (height >= hRange(1)) & (height <= hRange(2));
    tIndx = (mTime >= tRange(1)) & (mTime <= tRange(2));

    data.height = height(hIndx);
    data.altitude = data.height + 75;
    data.time = mTime(tIndx);

    CH1_PC = transpose(h5read(dataFile, '/CH1/DataProcessed/LicelGluedData_PC'));
    CH2_PC = transpose(h5read(dataFile, '/CH2/DataProcessed/LicelGluedData_PC'));
    CH1_BG = mean(CH1_PC(1500:2000, :), 1);
    CH2_BG = mean(CH2_PC(1500:2000, :), 1);
    try
        CH1_overflow = transpose(h5read(dataFile, '/CH1/DataOriginal/Clip'));
        CH2_overflow = transpose(h5read(dataFile, '/CH2/DataOriginal/Clip'));
        header = h5read(dataFile, '/CH1/DataOriginal/Header');
    catch
        CH1_overflow = false(size(CH1_PC));
        CH2_overflow = false(size(CH2_PC));
        header.RECORDSSCAN = 1000 * ones(size(CH1_PC, 1), 1);
    end

    % subset of data
    data.CH1_BG = double(CH1_BG(tIndx));
    data.CH2_BG = double(CH2_BG(tIndx));
    data.CH1_PC = double(CH1_PC(hIndx, tIndx)) - repmat(data.CH1_BG, sum(hIndx), 1);
    data.CH2_PC = double(CH2_PC(hIndx, tIndx)) - repmat(data.CH2_BG, sum(hIndx), 1);
    data.CH1_overflow = CH1_overflow(hIndx, tIndx);
    data.CH2_overflow = CH2_overflow(hIndx, tIndx);
    data.records = double(header.RECORDSSCAN(tIndx));

case 2
    % 3.75 m resolution data
    h5File = fullfile(folder, datestr(mDate, 'yyyy'), datestr(mDate, 'mm'), sprintf('MUA_PLidar_Wuhan_gluedData_%s.h5', datestr(mDate, 'yyyymmdd')));

    if exist(h5File, 'file') ~= 2
        error('Data file does not exist!\n%s\n', h5File);
    end

    height = h5read(h5File, '/range');   % [m]
    station_altitude = h5readatt(h5File, '/', 'station_altitude');   % [m]
    timeStr = h5read(h5File, '/time');
    if isempty(timeStr)
        warning('No data available!!!');
        return;
    end
    
    mTime = NaN(1, length(timeStr));
    for iTime = 1:length(timeStr)
        mTime(iTime) = datenum(timeStr{iTime}, 'yyyy-mm-dd HH:MM:SS');
    end

    tIndx = (mTime <= tRange(2)) & (mTime >= tRange(1));
    hIndx = (height <= hRange(2)) & (height >= hRange(1));
    startIndx = [find(tIndx, 1), find(hIndx, 1)];
    len = [sum(tIndx), sum(hIndx)];
    data.time = mTime(tIndx);
    data.height = height(hIndx);
    data.altitude = data.height + station_altitude;

    data.CH1_PC = transpose(h5read(h5File, '/CH1/gluedPC_Data', startIndx, len));
    data.CH2_PC = transpose(h5read(h5File, '/CH2/gluedPC_Data', startIndx, len));
    data.CH1_BG = h5read(h5File, '/CH1/background', [1, startIndx(1)], [1, len(1)]);
    data.CH2_BG = h5read(h5File, '/CH2/background', [1, startIndx(1)], [1, len(1)]);
    data.CH1_overflow = transpose(h5read(h5File, '/CH1/overflow', startIndx, len));
    data.CH2_overflow = transpose(h5read(h5File, '/CH2/overflow', startIndx, len));
    records = h5read(h5File, '/data_information/CH1/Records_Scan', [1, startIndx(1)], [1, len(1)]);
    data.records = records;

otherwise
    error('Unknown dVersion %d', dVersion);
end

end