function temp2D = read_gridTemp_SA(mTime, altitude)
% READ_GRIDTEMP_SA read gridded meteorological data based on US standard atmosphere
% Example:
%    temp2D = read_gridTemp_SA(mTime, altitude)
% Inputs:
%    mTime: array
%        measurement time. (UTC)
%    altitude: array
%        height above mean sea level. (m)
% Outputs:
%    temp: matrix (altitude * time)
%        temperature for each range bin. If no valid data, NaN will be 
%        filled. [C]
% History:
%    2020-06-01. First Edition by Zhenping
% Contact:
%    zhenping@tropos.de

temp2D = NaN(numel(altitude), numel(mTime));

if isempty(mTime) || isempty(altitude)
    return;
end

% read standard_atmosphere data as default values.
[~, ~, ~, temp, ~] = atmo(max(altitude/1000)+1, 0.03, 1);

temp = temp - 273.17;   % convert to [\circC]

temp2D = repmat(temp, 1, length(mTime));

end