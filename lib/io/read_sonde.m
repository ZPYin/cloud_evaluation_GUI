function [data] = read_sonde(dataFile, varargin)
% READ_SONDE read CMA radiosonde data.
%
% USAGE:
%    [data] = read_sonde(dataFile)
%
% INPUTS:
%    dataFile: char
%        absolute path of radiosonde data file.
%
% OUTPUTS:
%    data: struct
%        height
%        temperature
%        pressure
%        relative_humidity
%
% EXAMPLE:
%    read_sonde('UPAR_WEA_CHN_MUL_FTM_SEC-56137-2023010112.txt');
%
% HISTORY:
%    2023-03-13: first edition by Zhenping
% .. Authors: - zp.yin@whu.edu.cn

p = inputParser;
p.KeepUnmatched = true;

addRequired(p, 'dataFile', @ischar);
addParameter(p, 'debug', false, @islogical);

parse(p, dataFile, varargin{:});

fid = fopen(dataFile, 'r');

fileData = textscan(fid, '%d%s%s%s%s%d%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f', 'delimiter', ' ', 'MultipleDelimsAsOne', true);

fclose(fid);

data.height = fileData{17};
data.temperature = fileData{7};
data.temperature(abs(data.temperature - 999999) < 1e-2) = NaN;
data.pressure = fileData{8};
data.pressure(abs(data.pressure - 999999) < 1e-2) = NaN;
data.relative_humidity = fileData{9};
data.relative_humidity(abs(data.relative_humidity - 999999) < 1e-2) = NaN;

end