function [oData] = loadALADats(folder, tRange, varargin)
% LOADALADATS load ALA data.
%
% USAGE:
%    [oData] = loadALADats(folder, tRange)
%
% INPUTS:
%    folder: char
%        folder of lidar data.
%    tRange: 2-element array
%        start/stop time of lidar data request.
%
% KEYWORDS:
%    debug: logical
%    nMaxBin: numeric
%
% OUTPUTS:
%    oData: struct
%        altitude: numeric
%        height: array
%        mTime: array
%        rawSig: matrix (height x time)
%
% HISTORY:
%    2025-05-09: first edition by Zhenping
% .. Authors: - zp.yin@whu.edu.cn

p = inputParser;
p.KeepUnmatched = true;

addRequired(p, 'folder', @ischar);
addRequired(p, 'tRange', @isnumeric);
addParameter(p, 'nMaxBin', 1900, @isnumeric);
addParameter(p, 'debug', false, @islogical);

parse(p, folder, tRange, varargin{:});

daysNo = (floor(tRange(2)) - floor(tRange(1))) + 1;
dataFiles = cell(0);
for iDay = 1:daysNo
    dataSubFolder = fullfile(folder, datestr(floor(tRange(1)) + iDay - 1, 'yyyy-mm-dd'));

    subDataFiles = listfile(dataSubFolder, '.*dat', 1);

    for iFile = 1:length(subDataFiles)
        thisTime = datenum(['20', subDataFiles{iFile}((end-16):(end-4))], 'yyyymmdd-HHMMSS');

        isInTRange = (thisTime >= tRange(1)) && (thisTime <= tRange(2));
        if isInTRange
            dataFiles{end+1} = subDataFiles{iFile};
        end
    end
end

oData = struct();
oData.mTime = NaN(1, length(dataFiles));
oData.rawSig = NaN(p.Results.nMaxBin, length(dataFiles));
oData.height = NaN(1, p.Results.nMaxBin);
oData.altitude = 0;
for iFile = 1:length(dataFiles)
    if p.Results.debug
        fprintf('Finish %6.2f%%: reading %s\n ', (iFile - 1) / length(dataFiles) * 100, dataFiles{iFile});
    end

    thisData = readALADat(dataFiles{iFile}, 'nMaxBin', p.Results.nMaxBin, 'debug', false);

    oData.mTime(iFile) = thisData.mTime;
    oData.rawSig(:, iFile) = thisData.rawSignal(:, 1);
    oData.height = (1:p.Results.nMaxBin) * thisData.hRes(1);
end

end