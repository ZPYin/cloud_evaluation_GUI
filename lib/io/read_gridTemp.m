function [temp2D] = read_gridTemp(mTime, altitude, varargin)
% READ_GRIDTEMP read gridded temperature field.
% Example:
%    % Usecase 1: read GDAS1 data
%    temp2D = read_gridTemp(mTime, altitude, 'meteor_data', 'GDAS1', 'station', 'wuhan', 'GDAS1Folder', '/GDAS1');
%    % Usecase 2: read Radiosonde data
%    temp2D = read_gridTemp(mTime, altitude, 'meteor_data', 'Radiosonde', 'RadiosondeFolder', '/Radiosonde', 'station', 'wuhan');
%    % Usecase 3: read ERA-5 data.
%    temp2D = read_gridTemp(mTime, altitude, 'meteor_data', 'ERA-5', 'ERA5Folder', '/ERA-5', 'station', 'wuhan');
% Inputs:
%    mTime: array
%        measurement time. (UTC)
%    altitude: array
%        height above mean sea level. (m)
% Keywords:
%    meteor_data: char
%        meteorological data source. 
%        'GDAS1' (default), 'Radiosonde', or 'ERA-5'
%    station: char
%        station label. (default: 'wuhan')
%    GDAS1Folder: char
%        GDAS1 data folder.
%    RadiosondeFolder: char
%        Radiosonde data folder.
%    RadiosondeType: integer
%        file type of the radiosonde file.
%        - 1: radiosonde file for MOSAiC
%        - 2: radiosonde file for MUA (default)
%    ERA5Folder: char
%        ERA-5 data folder.
% Outputs:
%    temp2D: matrix (altitude * time)
%        gridded temperature.
% History:
%    2020-05-28. First Edition by Zhenping
% Contact:
%    zp.yin@whu.edu.cn

p = inputParser;
p.KeepUnmatched = true;

addRequired(p, 'mTime', @isnumeric);
addRequired(p, 'altitude', @isnumeric);
addParameter(p, 'meteor_data', 'GDAS1', @ischar);
addParameter(p, 'station', 'wuhan', @ischar);
addParameter(p, 'GDAS1Folder', '', @ischar);
addParameter(p, 'RadiosondeFolder', '', @ischar);
addParameter(p, 'ERA5Folder', '', @ischar);

parse(p, mTime, altitude, varargin{:});

temp2D = NaN(numel(mTime), numel(altitude));

switch lower(p.Results.meteor_data)
case 'gdas1'

    temp2D = read_gridTemp_GDAS1(mTime, altitude, p.Results.GDAS1Folder, p.Results.station, datenum(0, 1, 0, 4, 0, 0));

case 'radiosonde'

    temp2D = read_gridTemp_RS(mTime, altitude, p.Results.RadiosondeFolder, p.Results.station, datenum(0, 1, 0, 13, 0, 0));

case 'era-5'

    temp2D = read_gridTemp_ERA5(mTime, altitude, p.Results.ERA5Folder, p.Results.station, datenum(0, 1, 0, 7, 0, 0));
    return;

case 'standard_atmosphere'

    temp2D = read_gridTemp_SA(mTime, altitude);

end

end