function [temp, pres, relh, meteor_time] = read_meteordata(measTime, altitude, varargin)
% READ_METEORDATA Read the meteorological data according to the input 
% meteorological data type.
% Example:
%    %  Usecase 1: read GDAS1 data
%    [temp, pres, relh] = read_meteordata(measTime, altitude, 'meteor_data', 'GDAS1', 'station', 'wuhan', 'GDAS1Folder', '/GDAS1');
%    %  Usecase 2: read Radiosonde data
%    [temp, pres, relh] = read_meteordata(measTime, altitude, 'meteor_data', 'Radiosonde', 'RadiosondeFolder', '/Radiosonde', 'station', 'wuhan');
%    %  Usecase 3: read ERA-5 data.
%    [temp, pres, relh] = read_meteordata(measTime, altitude, 'meteor_data', 'ERA-5', 'ERA5Folder', '/ERA-5', 'station', 'wuhan');
% Inputs:
%    measTime: datenum
%        the measurement time. (UTC)
%    altitude: array
%        height above the mean sea level. [m]
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
%    temp: array
%        temperature for each range bin. [??C]
%    pres: array
%        pressure for each range bin. [hPa]
%    relh: array
%        relative humidity for each range bin. [%]
%    meteor_time: numeric
%        timestamp for meteorological data. (datenum)
% History:
%    2020-05-28. First Edition by Zhenping
% Contact:
%    zhenping@tropos.de

p = inputParser;
p.KeepUnmatched = true;

addRequired(p, 'measTime', @isnumeric);
addRequired(p, 'altitude', @isnumeric);
addParameter(p, 'meteor_data', 'GDAS1', @ischar);
addParameter(p, 'station', 'wuhan', @ischar);
addParameter(p, 'GDAS1Folder', '', @ischar);
addParameter(p, 'RadiosondeFolder', '', @ischar);
addParameter(p, 'RadiosondeType', 2, @isnumeric);
addParameter(p, 'ERA5Folder', '', @ischar);

parse(p, measTime, altitude, varargin{:});

temp = NaN(size(altitude));
pres = NaN(size(altitude));
relh = NaN(size(altitude));
meteor_time = NaN(1);

switch lower(p.Results.meteor_data)

case 'gdas1'

    % GDAS1 profile
    [gdas1_alt, gdas1_temp, gdas1_pres, gdas1_relh, gdas1_file] = read_gdas1(measTime, ...
        p.Results.station, p.Results.GDAS1Folder);

    if isempty(gdas1_alt) || (~ (sum(~ isnan(gdas1_temp)) >= 2))
        % no data or not enough numeric data
        return;
    end

    meteor_time = gdas1FileTimestamp(basename(gdas1_file));
    temp = interp1(gdas1_alt, gdas1_temp, altitude);
    pres = interp1(gdas1_alt, gdas1_pres, altitude);
    relh = interp1(gdas1_alt, gdas1_relh, altitude);

case 'radiosonde'

    % Radiosonde profile
    sondeFile = radiosonde_search(fullfile(p.Results.RadiosondeFolder, p.Results.station), measTime, p.Results.RadiosondeType);
    [rs_alt, rs_temp, rs_pres, rs_relh, rs_time] = ...
        read_radiosonde(sondeFile, p.Results.RadiosondeType);

    if isempty(rs_alt) || (~ (sum(~ isnan(rs_temp)) >= 2))
        % no data or not enough numeric data
        return;
    end

    % sort the measurements as the ascending order of altitude
    [rs_alt, sortIndxAlt] = sort(rs_alt);
    rs_temp = rs_temp(sortIndxAlt);
    rs_pres = rs_pres(sortIndxAlt);
    rs_relh = rs_relh(sortIndxAlt);

    % remove the duplicated measurements at the same altitude
    [rs_alt, iUniq, ~] = unique(rs_alt);
    rs_temp = rs_temp(iUniq);
    rs_pres = rs_pres(iUniq);
    rs_relh = rs_relh(iUniq);

    meteor_time = rs_time;
    temp = interp1(rs_alt, rs_temp, altitude);
    pres = interp1(rs_alt, rs_pres, altitude);
    relh = interp1(rs_alt, rs_relh, altitude);

case 'era-5'

    % ERA5 profile
    [ERA5_alt, ERA5_temp, ERA5_pres, ERA5_relh, ERA5_file] = read_ERA5(measTime, ...
        p.Results.station, p.Results.ERA5Folder);

    if isempty(ERA5_alt) || (~ (sum(~ isnan(ERA5_temp)) >= 2))
        % no data or not enough numeric data
        return;
    end

    meteor_time = ERA5FileTimestamp(basename(ERA5_file));
    temp = interp1(ERA5_alt, ERA5_temp, altitude);
    pres = interp1(ERA5_alt, ERA5_pres, altitude);
    relh = interp1(ERA5_alt, ERA5_relh, altitude);

case 'standard_atmosphere'

    % read standard_atmosphere data as default values.
    [sa_alt, ~, ~, sa_temp, sa_pres] = atmo(max(altitude/1000)+1, 0.03, 1);

    pres = interp1(sa_alt, sa_pres / 1e2, altitude / 1000);
    temp = interp1(sa_alt, sa_temp - 273.17, altitude / 1000);   % convert to [\circC]
    relh = NaN(size(temp));

otherwise

    error('Unknown meteorological data: %s', p.Results.meteor_data);

end

end
