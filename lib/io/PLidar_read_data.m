function [data] = PLidar_read_data(mDate, folder, dVersion, hRange, tRange)
% PLidar_read_data read Polarization lidar data.
% Example:
%    [data] = PLidar_read_data(mDate, folder, dVersion, hRange)
% Inputs:
%    mDate: datenum
%        measurement date.
%    folder: char
%        folder of the lidar data.
%    dVersion: integer
%        data version.
%            1: 30 m resolution data
%            2: 3.75 m resolution data
%            3: CMA polarization data
%    hRange: 2-element array
%        bottom and top of the range you want to load. (m)
%    tRange: 2-element array
%        temporal range for data profiles.
% Outputs:
%    data: struct
%        height: array
%            height of each bin above ground. (m)
%        altitude: array
%            height above mean sea surface of each bin. (m)
%        time: datenum
%            measurement time of each profile.
%        recors: array
%            accumulated records for each single profile.
%        sigCH1: matrix (height * time)
%            photon count rate or analog data for CH1 at parallel channel without background
%        sigCH2: matrix (height * time)
%            photon count rate or analog data for CH2 at cross channel without background
%        BGCH1: array
%            background at CH1.
%        BGCH2: array
%            background at CH2.
%        overflowCH1: matrix (height * time)
%            overflow flag for CH1. ('1' means overflowed)
%        overflowCH2: matrix (height * time)
%            overflow flag for CH2. ('1' means overflowed)
% History:
%    2020-03-15. First Edition by Zhenping
% Contact:
%    zp.yin@whu.edu.cn

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

    sigCH1 = transpose(h5read(dataFile, '/CH1/DataProcessed/LicelGluedData_PC'));
    sigCH2 = transpose(h5read(dataFile, '/CH2/DataProcessed/LicelGluedData_PC'));
    BGCH1 = mean(sigCH1(1500:2000, :), 1);
    BGCH2 = mean(sigCH2(1500:2000, :), 1);
    try
        overflowCH1 = transpose(h5read(dataFile, '/CH1/DataOriginal/Clip'));
        overflowCH2 = transpose(h5read(dataFile, '/CH2/DataOriginal/Clip'));
        header = h5read(dataFile, '/CH1/DataOriginal/Header');
    catch
        overflowCH1 = false(size(sigCH1));
        overflowCH2 = false(size(sigCH2));
        header.RECORDSSCAN = 1000 * ones(size(sigCH1, 1), 1);
    end

    % photon count rate to photon count
    records = double(header.RECORDSSCAN(tIndx));
    records(records <= 1e-3) = NaN;
    PCR2PC = 1000 ./ repmat(transpose(records), length(data.height), 1) .* 200;

    % subset of data
    data.BGCH1 = double(BGCH1(tIndx)) .* PCR2PC(1, :);
    data.BGCH2 = double(BGCH2(tIndx)) .* PCR2PC(1, :);
    data.sigCH1 = (double(sigCH1(hIndx, tIndx)) .* PCR2PC - repmat(data.BGCH1, sum(hIndx), 1));
    data.sigCH2 = (double(sigCH2(hIndx, tIndx)) .* PCR2PC - repmat(data.BGCH2, sum(hIndx), 1));
    data.overflowCH1 = overflowCH1(hIndx, tIndx);
    data.overflowCH2 = overflowCH2(hIndx, tIndx);
    data.records = records;

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

    records = h5read(h5File, '/data_information/CH1/Records_Scan', [1, startIndx(1)], [1, len(1)]);
    data.records = records;

    % photon count rate to photon count
    records(records <= 1e-3) = NaN;
    PCR2PC = 1000 ./ repmat(records, length(data.height), 1) .* 200;

    sigCH1 = transpose(h5read(h5File, '/CH1/gluedPC_Data', startIndx, len));
    sigCH2 = transpose(h5read(h5File, '/CH2/gluedPC_Data', startIndx, len));
    data.BGCH1 = h5read(h5File, '/CH1/background', [1, startIndx(1)], [1, len(1)]) .* PCR2PC(1, :);
    data.BGCH2 = h5read(h5File, '/CH2/background', [1, startIndx(1)], [1, len(1)]) .* PCR2PC(1, :);
    data.sigCH1 = (sigCH1 .* PCR2PC - repmat(data.BGCH1, len(2), 1));
    data.sigCH2 = (sigCH2 .* PCR2PC - repmat(data.BGCH2, len(2), 1));
    data.overflowCH1 = transpose(h5read(h5File, '/CH1/overflow', startIndx, len));
    data.overflowCH2 = transpose(h5read(h5File, '/CH2/overflow', startIndx, len));

case 3
    % CMA polarization data
    CMAData = loadLidarData(folder, '54511', tRange, 'hRange', [0, 60000], 'channelIndex', 1:2);

    pRawSig = squeeze(CMAData.rawSig(1, :, :));
    pBg = mean(pRawSig((end - 500):end, :), 1);
    pSig = pRawSig - repmat(pBg, size(pRawSig, 1), 1);

    cRawSig = squeeze(CMAData.rawSig(2, :, :));
    cBg = mean(cRawSig((end - 500):end, :), 1);
    cSig = cRawSig - repmat(cBg, size(cRawSig, 1), 1);

    hInd = (CMAData.height >= hRange(1)) & (CMAData.height <= hRange(2));

    data.time = CMAData.mTime;
    data.height = transpose(CMAData.height(hInd));
    data.altitude = CMAData.altitude + transpose(CMAData.height(hInd));
    data.records = ones(size(CMAData.mTime));
    data.sigCH1 = pSig(hInd, :);
    data.sigCH2 = cSig(hInd, :);
    data.BGCH1 = pBg;
    data.BGCH2 = cBg;
    data.overflowCH1 = zeros(size(pSig(hInd, :)));
    data.overflowCH2 = zeros(size(cSig(hInd, :)));

otherwise
    error('Unknown dVersion %d', dVersion);
end

end