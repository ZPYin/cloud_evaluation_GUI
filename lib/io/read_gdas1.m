function [alt, temp, pres, relh, gdas1file] = read_gdas1(measTime, gdas1site, folder)
% READ_GDAS1 read the gdas1 file
% Example:
%    [alt, temp, pres, relh] = read_gdas1(measTime, gdas1site, folder)
% Inputs:
%    measTime: datenum
%        measurement time. 
%    gdas1site: char
%        the location for gdas1. Our server will automatically produce the 
%        gdas1 products for all our pollynet location. You can find it in 
%        /lacroshome/cloudnet/data/model/gdas1
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
%        filled. [%]
%    gdas1file: char
%        filename of gdas1 file. 
% History:
%    2018-12-22. First Edition by Zhenping
% Contact:
%    zhenping@tropos.de

[thisyear, thismonth, thisday, thishour, ~, ~] = ...
            datevec(round(measTime / datenum(0, 1, 0, 3, 0, 0)) * ...
            datenum(0, 1, 0, 3, 0, 0));
gdas1file = fullfile(folder, gdas1site, sprintf('%04d', thisyear), ...
            sprintf('%02d', thismonth), ...
            sprintf('*_%04d%02d%02d_%02d*.gdas1', ...
            thisyear, thismonth, thisday, thishour));

[pres, alt, temp, relh] = ceilo_bsc_ModelSonde(gdas1file);

end