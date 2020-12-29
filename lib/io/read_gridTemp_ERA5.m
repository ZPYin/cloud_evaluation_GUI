function temp2D = read_gridTemp_ERA5(mTime, altitude, ...
                                    folder, ERA5site, deltaTime)
%read_gridTemp_ERA5 read gridded ERA5 data
%Example:
%   temp2D = read_gridTemp_ERA5(mTime, altitude, folder, ERA5site, deltaTime)
%Inputs:
%   mTime: array
%       measurement time. (UTC)
%   altitude: array
%       height above mean sea level. (m)
%   folder: char
%       ERA5 data folder.
%   ERA5site: char
%       ERA5 site (default: 'wuhan').
%   deltaTime: numeric
%       delta time for profile searching.
%Outputs:
%   temp: matrix (altitude * time)
%       temperature for each range bin. If no valid data, NaN will be 
%       filled. [C]
%History:
%   2020-10-26. First Edition by Zhenping
%Contact:
%   zp.yin@whu.edu.cn

if ~ exist('ERA5site', 'var')
    ERA5site = 'wuhan';
end

temp2D = NaN(numel(altitude), numel(mTime));

if isempty(mTime) || isempty(altitude)
    return;
end

tRange = [mTime(1) - deltaTime, mTime(end) + deltaTime];
dates = floor(tRange(1)):floor(tRange(2));

%% search ERA5 files in the given temporal range
ERA5Files = cell(0);
ERA5Times = [];
for iDate = 1:length(dates)
    thisDate = dates(iDate);
    filesInDay = listfile(fullfile(folder, ERA5site, ...
        datestr(thisDate, 'yyyy'), datestr(thisDate, 'mm')), ...
        sprintf('.*ERA5_.*_%s.nc', datestr(thisDate, 'yyyymmdd')));

    for iFile = 1:length(filesInDay)
        ERA5Files = cat(2, ERA5Files, filesInDay{iFile});
        ERA5Times = cat(2, ERA5Times, thisDate);
    end
end

%% sort files according to time ascending order
if isempty(ERA5Files)
    warning('No ERA5 files were found.');
    return;
end
[~, indx] = sort(ERA5Times);
ERA5FilesSorted = ERA5Files(indx);

%% read ERA5 data
pres = [];
temp = [];
relh = [];
time = [];
geopot = [];
latIndx = 1;   % latitude index
lonIndx = 1;   % longitude index
for iFile = 1:length(ERA5FilesSorted)
    
    % read ERA5 profile (MATLAB has incorporated scale transformation)
    geopot_raw = ncread(ERA5Files{iFile}, 'z');   % geopotential: m^2*s^-2
    temp_raw = ncread(ERA5Files{iFile}, 't');   % temperature: K
    pres_raw = ncread(ERA5Files{iFile}, 'level');   % pressure: hPa
    relh_raw = ncread(ERA5Files{iFile}, 'r');   % relative humidity: %
    time_raw = ncread(ERA5Files{iFile}, 'time');
    
    % squeeze data array
    geopot_raw = squeeze(geopot_raw(lonIndx, latIndx, :, :));
    temp_raw = squeeze(temp_raw(lonIndx, latIndx, :, :));
    relh_raw = squeeze(relh_raw(lonIndx, latIndx, :, :));
    
    % concatenate the array
    geopot = cat(2, geopot, geopot_raw);
    pres = cat(2, pres, repmat(double(pres_raw), 1, size(geopot_raw, 2)));
    temp = cat(2, temp, temp_raw);
    relh = cat(2, relh, relh_raw);
    time = cat(2, time, repmat(double(time_raw'), size(geopot_raw, 1), 1));
    
end

if isempty(temp)
    warning('No data was loaded.');
    return;
end

g = 9.80665;   % gravatational acceleration. [m*s^-2]
alt_ERA5 = geopot / g;   % altitude of ERA5 pressure level. [m]

time = (double(time) / 24 + datenum(1900, 1, 1, 0, 0, 0));
tIndx = (time(1, :) >= tRange(1)) & (time(1, :) <= tRange(2));

% mask the products within the given time window
alt_ERA5 = alt_ERA5(:, tIndx);
temp = temp(:, tIndx);

% grid the data
alt_grid = linspace(max(alt_ERA5(1, :)), min(alt_ERA5(end, :)), 300);
time_grid = time(1, tIndx);
[TIME, ALT] = meshgrid(time_grid, alt_grid);
TEMP = griddata(time(:, tIndx), alt_ERA5, temp, TIME, ALT);

[TIMEGrid, ALTGrid] = meshgrid(mTime, altitude);
temp2D = interp2(TIME, ALT, TEMP, TIMEGrid, ALTGrid, 'linear') - 273.17;

end