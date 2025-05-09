function [oData] = readALADat(file, varargin)
% READALADAT read lidar data from ALA data recorder.
%
% USAGE:
%    [oData] = readREAL(file)
%
% INPUTS:
%    file: char
%        absolute paht of data file.
%
% KEYWORDS:
%    flagDebug: logical
%    nMaxBin: numeric
%    autoParse: logical
%        whether to parse the dat file in an automatic way. (default: false)
%
% OUTPUTS:
%    oData: struct
%        rawSignal: matrix
%        mTime: numeric
%        nPretrigger: numeric
%        nShots: numeric
%        channelLabel: cell
%
% HISTORY:
%    2023-06-10: first edition by Zhenping
% .. Authors: - zhenping@tropos.de

p = inputParser;
p.KeepUnmatched = true;

addRequired(p, 'file', @ischar);
addParameter(p, 'flagDebug', false, @islogical);
addParameter(p, 'nMaxBin', [], @isnumeric);
addParameter(p, 'autoParse', true, @islogical);

parse(p, file, varargin{:});

if exist(file, 'file') ~= 2
    errStruct.message = sprintf('ALA dat file does not exist!\n%s', file);
    errStruct.identifier = 'Err004';
    error(errStruct);
end

mTime = datenum(file((end-16):(end-4)), 'yymmdd-HHMMSS');

if p.Results.flagDebug
    fprintf('Reading %s\n', file);
end

%% read data
fid = fopen(file, 'r');

for iLine = 1:12
    fgetl(fid);
end

thisLine = fgetl(fid);
channelLabel = strsplit(thisLine, '	');
fgetl(fid);
thisLine = fgetl(fid);
binWidthCell = strsplit(thisLine, '	');
binWidth = str2double(binWidthCell);

thisLine = fgetl(fid);
nPulseCell = strsplit(thisLine, '	');
nPulse = str2double(nPulseCell);
fgetl(fid);
thisLine = fgetl(fid);
nPretriggerCell = strsplit(thisLine, '	');
nPretrigger = str2double(nPretriggerCell);

lidarData = textscan(fid, repmat('%f', 1, length(channelLabel)), 'HeaderLines', 1, 'Delimiter', '\t');

fclose(fid);

if isempty(p.Results.nMaxBin)
    nMaxBin = length(lidarData{1});
else
    nMaxBin = p.Results.nMaxBin;
end

if nMaxBin > length(lidarData{1})
    errStruct.message = sprintf('Wrong configuration for nMaxBin (%d>%d)', ...
        nMaxBin, length(lidarData{1}));
    errStruct.identifier = 'Err003';
    error(errStruct);
end

rawSignal = [];
for iCh = 1:length(channelLabel)
    rawSignal = cat(2, rawSignal, lidarData{iCh}(1:nMaxBin));
end

%% Remove empty channel
isValidChannel = true(1, length(channelLabel));
for iCh = 1:length(channelLabel)
    if isempty(channelLabel{iCh})
        isValidChannel(iCh) = false;
    end
end

oData = struct;
oData.mTime = mTime;
oData.rawSignal = rawSignal(:, isValidChannel);
oData.channelLabel = channelLabel(isValidChannel);
oData.hRes = binWidth * 0.15;
oData.nPretrigger = nPretrigger(isValidChannel);
oData.nShots = nPulse(isValidChannel);

end