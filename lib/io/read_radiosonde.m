function [alt, temp, pres, relh, datetime] = read_radiosonde(file, ...
    fileType, missingValue)
% READ_RADIOSONDE read the radiosonde data from netCDF file.
%
% USAGE:
%     [alt, temp, pres, relh, datetime] = read_radiosonde(file, fileType)
%
% INPUTS:
%     file: str
%         filename of radiosonde data file. 
%     fileType: integer
%         file type of the radiosonde file.
%         - 1: radiosonde file for MOSAiC (default)
%        - 2: radiosonde file for MUA (netCDF4)
%        - 3: CMA radiosonde file
%        - 4: radiosonde file for MUA (HDF5)
%     missingValue: double
%         missing value for filling the empty bins. These values need to be 
%         replaced with NaN to be compatible with the processing program.
%
% OUTPUTS:
%     alt: array
%         altitute for each range bin. [m]
%     temp: array
%         temperature for each range bin. If no valid data, NaN will be 
%         filled. [C]
%     pres: array
%         pressure for each range bin. If no valid data, NaN will be filled. 
%         [hPa]
%     rh: array
%         relative humidity for each range bin. If no valid data, NaN will be 
%         filled. [%]
%     datetime: datenum
%         datetime for the radiosonde data.
%
% NOTE:
%    Radiosonde Type 2:
%     The radiosonde file should be in netCDF and must contain the variable of 
%     'altitude', 'temperature', 'pressure' and 'RH'. Below is the description 
%     of each variable. (detailed information please see example in 
%     '..\example\convert_radiosonde_data\')
%       variables:
%         double altitude(altitude=6728);
%           :unit = "m";
%           :long_name = "Height of lidar above mean sea level";
%           :standard_name = "altitude";
%           :axis = "Z";
%         double pressure(altitude=6728);
%           :unit = "hPa";
%           :long_name = "air pressure";
%           :standard_name = "pressure";
%           :_FillValue = -999.0; // double
%         double temperature(altitude=6728);
%           :unit = "degree celsius";
%           :long_name = "air temperature";
%           :standard_name = "temperature";
%           :_FillValue = -999.0; // double
%         double RH(altitude=6728);
%           :unit = "%";
%           :long_name = "relative humidity";
%           :standard_name = "RH";
%           :_FillValue = -999.0; // double
%
% HISTORY:
%    2019-07-19: First Edition by Zhenping
%    2019-07-28: Add the criteria for empty file
%    2019-12-18: Add `fileType` to specify the type of the radiosonde file.
% .. Authors: - zp.yin@whu.edu.cn

temp = [];
pres = [];
relh = [];
alt = [];
datetime = [];

if ~ exist('fileType', 'var')
    fileType = 1;
end

if ~ exist('missingValue', 'var')
    missingValue = -999;
end

if exist(file, 'file') ~= 2
    warning('radiosonde file does not exist. Please check it.\n%s', file);
    return;
end

switch fileType
case 1   % MOSAiC

    thisFilename = basename(file);
    datetime = datenum(thisFilename(12:26), 'yyyymmdd_HHMMSS');

    alt = ncread(file, 'altitude'); 
    temp = ncread(file, 'temperature');
    pres = ncread(file, 'pressure'); 
    relh = ncread(file, 'RH');

    % replace missing value with NaN
    temp(abs(temp - missingValue) < 1e-5) = NaN;
    pres(abs(pres - missingValue) < 1e-5) = NaN;
    relh(abs(relh - missingValue) < 1e-5) = NaN;

case 2   % MUA radiosonde standard file (netCDF4)

    thisFilename = basename(file);
    datetime = datenum(thisFilename((end - 15):(end - 3)), 'yyyymmdd_HHMM');

    alt = ncread(file, 'altitude'); 
    temp = ncread(file, 'temperature');
    pres = ncread(file, 'pressure'); 
    relh = ncread(file, 'relative_humidity');

case 3   % CMA radiosonde file

    thisFilename = basename(file);
    datetime = datenum(thisFilename((end - 13):(end - 4)), 'yyyymmddHH');

    thisData = read_sonde(file);
    alt = thisData.height;
    temp = thisData.temperature;
    pres = thisData.pressure;
    relh = thisData.relative_humidity;

case 4   % MUA radiosonde standard file (HDF5)

    thisFilename = basename(file);
    datetime = datenum(thisFilename((end - 15):(end - 6)), 'yyyymmddHH');

    rsData = h5read(file, '/RadioSonde');
    alt = rsData(2, :); 
    temp = rsData(3, :);
    pres = rsData(1, :); 
    relh = rsData(4, :);

otherwise
    error('Unknown fileType %d', fileType);
end

end
