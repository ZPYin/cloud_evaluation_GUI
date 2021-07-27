function [data] = loadLidarData(lidarFolder, stationID, tRange, varargin)
% LOADLIDARDATA load lidar data.
% USAGE:
%    [data] = loadLidarData(lidarFolder, stationID, tRange, varargin)
% INPUTS:
%    lidarFolder: char
%        folder of lidar data.
%    stationID: char
%        station ID. (e.g., '54511')
%    tRange: 2-element array
%        start/stop time of lidar data request.
%    channelIndex: array
%        channel index.
% KEYWORDS:
%    hRange: 2-element array
%        vertical range of lidar data request (default: [0, 15000]). (m)
% OUTPUTS:
%    data: struct
%        altitude: numeric
%        height: array
%        mTime: array
%        rawSig: matrix (height x time)
% EXAMPLE:
% HISTORY:
%    2021-07-21: first edition by Zhenping
% .. Authors: - zhenping@tropos.de

p = inputParser;
p.KeepUnmatched = true;

addRequired(p, 'lidarFolder', @ischar);
addRequired(p, 'stationID', @ischar);
addParameter(p, 'hRange', [0, 15000], @isnumeric);
addParameter(p, 'channelIndex', 1:16, @isnumeric);

parse(p, lidarFolder, stationID, varargin{:});

lidarSubFolder = fullfile(lidarFolder, stationID);

if ~ exist(lidarSubFolder, 'dir')
    error('Folder does not exist!\n%f', lidarSubFolder);
end

data = struct();

%% read data
height = [];
mTime = [];
rawSig = [];
daysNo = (floor(tRange(2)) - floor(tRange(1))) + 1;
for iDay = 1:daysNo
    fileName = listfile(lidarSubFolder, sprintf('\\w*_%s.nc', datestr(floor(tRange(1)) + iDay - 1, 'yyyymmdd')));

    if isempty(fileName)
        continue;
    end
    
    if length(fileName) > 1
        warning('Multiple files were found %s', fileName);
        continue;
    end

    thisHeight = ncread(fileName{1}, 'height');
    thisMTime = unix_timestamp_2_datenum(ncread(fileName{1}, 'time'));
    thisRawSig = ncread(fileName{1}, 'backscatter');
    hInd = (thisHeight < p.Results.hRange(2)) & (thisHeight > p.Results.hRange(1));
    
    altitude = ncread(fileName{1}, 'altitude');
    height = thisHeight(hInd);
    mTime = cat(1, mTime, thisMTime);
    rawSig = cat(3, rawSig, thisRawSig(p.Results.channelIndex, hInd, :));
end

%% grid data
nPrfs = floor((tRange(2) - tRange(1)) / datenum(0, 1, 0, 0, 1, 0)) + 1;
rawSigGrid = NaN(size(rawSig, 1), sum(hInd), nPrfs);
mTimeGrid = tRange(1) + datenum(0, 1, 0, 0, 0:(nPrfs - 1), 0);
% [startY, startM, startD, startH, startMin, ~] = datevec(tRange(1));
for iPrf = 1:length(mTime)
    tInd = floor((mTime(iPrf) - tRange(1)) / datenum(0, 1, 0, 0, 1, 0));

    if tInd < 0
        continue;
    end
    
    if (mTime(iPrf) > tRange(2)) || (mTime(iPrf) < tRange(1))
        continue;
    end

    rawSigGrid(:, :, tInd + 1) = rawSig(:, :, iPrf);
end

data.altitude = altitude;
data.height = height;
data.mTime = mTimeGrid;
data.rawSig = rawSigGrid;

end