function [alt, temp, pres, relh, ERA5file, wind, wins] = read_ERA5(measTime, ERA5site, folder)
% READ_ERA5 read the ERA5 file
% Example:
%    [alt, temp, pres, relh] = read_ERA5(measTime, ERA5site, folder)
% Inputs:
%    measTime: datenum
%        measurement time. 
%    ERA5site: char
%        the location for ERA5 site.
% Outputs:
%    alt: array
%        altitute for each range bin. [m]
%    temp: array
%        temperature for each range bin. If no valid data, NaN will be 
%        filled. [C]
%    pres: array
%        pressure for each range bin. If no valid data, NaN will be filled. 
%        [hPa]
%    rh: array
%        relative humidity for each range bin. If no valid data, NaN will be 
%        filled. [% ]
%    ERA5file: char
%        filename of ERA5 file.
%    wind: array
%        wind direction. [degree]
%    wins: array
%        wind speed. [m/s]
% History:
%    2020-10-26. First Edition by Zhenping
% Contact:
%    zp.yin@whu.edu.cn

[thisyear, thismonth, thisday, ~, ~, ~] = datevec(measTime);
dirInfo = dir(fullfile(folder, ERA5site, sprintf('%04d', thisyear), ...
                       sprintf('%02d', thismonth), ...
                       sprintf('*ERA5_*_%04d%02d%02d.nc', ...
                       thisyear, thismonth, thisday)));

% file check
if isempty(dirInfo)
    % empty results
    warning('No ERA5 file can be found.');
    ERA5file = '';
elseif length(dirInfo) > 1
    % multiple results
    warning('Multiple ERA5 files were found.');
    for iFile = 1:length(dirInfo)
        fprintf('%s\n', fullfile(dirInfo(iFile).folder, dirInfo(iFile).name));
    end

    ERA5file = '';
else
    % correct
    ERA5file = fullfile(dirInfo.folder, dirInfo.name);
end

%% read results
alt = [];
temp = [];
pres = [];
relh = [];
wind = [];
wins = [];

if isempty(ERA5file)
    return;
end

% read ERA5 profile (MATLAB has incorporated scale transformation)
geopot_raw = ncread(ERA5file, 'z');   % geopotential: m^2*s^-2
temp_raw = ncread(ERA5file, 't');   % temperature: K
pres_raw = ncread(ERA5file, 'level');   % pressure: hPa
relh_raw = ncread(ERA5file, 'r');   % relative humidity: %
time_raw = ncread(ERA5file, 'time');
u_wind_raw = ncread(ERA5file, 'u');   % eastward wind: m*s^-1
v_wind_raw = ncread(ERA5file, 'v');   % northward wind: m*s^-1

% conversion
time = (double(time_raw) / 24 + datenum(1900, 1, 1, 0, 0, 0));
[~, tIndx] = min(abs(time - measTime));
lonIndx = 1;   % hard-code indexing
latIndx = 1;
g = 9.80665;   % gravatational acceleration. [m*s^-2]
alt = reshape(geopot_raw(lonIndx, latIndx, :, tIndx) / g, 1, []);
temp = reshape(temp_raw(lonIndx, latIndx, :, tIndx), 1, []) - 273.17;
pres = reshape(double(pres_raw), 1, []);
relh = reshape(relh_raw(lonIndx, latIndx, :, tIndx), 1, []);
u_wind = reshape(u_wind_raw(lonIndx, latIndx, :, tIndx), 1, []);
v_wind = reshape(v_wind_raw(lonIndx, latIndx, :, tIndx), 1, []);
wins = sqrt(u_wind.^2 + v_wind.^2);
wind = 180 + 180 / pi * atan2(u_wind, v_wind);

end