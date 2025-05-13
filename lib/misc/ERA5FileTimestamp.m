
function [datetime, location] = ERA5FileTimestamp(gdas1File)
% ERA5FILETIMESTAMP extract the timestamp from the gdas1File name.
%
% USAGE:
%    [datetime, location] = ERA5FileTimestamp(gdas1File)
%
% INPUTS:
%    gdas1File: char
%        gdas1 data file.
%
% OUTPUTS:
%    datetime: float
%        datenum.
%
% HISTORY:
%    2019-01-04: first edition by Zhenping
% .. Authors: - zp.yin@whu.edu.cn

data = regexp(gdas1File, ...
             'ERA5_(?<location>.*)_(?<date>\d{8})\w*', 'names');

if isempty(data)
    warning('Failure in converting gdas1 filename to timestamp.\n%s\n', gdas1File);
    datetime = datenum(0,1,0,0,0,0);
    location = '';
else
    datetime = datenum(data.date, 'yyyymmdd');
    location = data.location;
end

end