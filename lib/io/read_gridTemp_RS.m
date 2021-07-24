function temp2D = read_gridTemp_RS(mTime, altitude, folder, station, deltaTime)
% READ_GRIDTEMP_RS read gridded radiosonde data
% Example:
%    temp2D = read_gridTemp_RS(mTime, altitude, folder, station, deltaTime)
% Inputs:
%    mTime: array
%        measurement time. (UTC)
%    altitude: array
%        height above mean sea level. (m)
%    folder: char
%        radiosonde data folder.
%    station: char
%        radiosonde station (default: 'wuhan').
%    deltaTime: numeric
%        delta time for profile searching.
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

tRange = [mTime(1) - deltaTime, mTime(end) + deltaTime];
dates = floor(tRange(1)):floor(tRange(2));

%% search radiosonde files in the given temporal range
RSFiles = cell(0);
RSTimes = [];
for iDate = 1:length(dates)
    thisDate = dates(iDate);
    filesInDay = listfile(fullfile(folder, station, ...
        datestr(thisDate, 'yyyy')), ...
        sprintf('radiosonde_.*%s.*.nc', datestr(thisDate, 'yyyymmdd')));

    for iFile = 1:length(filesInDay)
        filename = basename(filesInDay{iFile});
        thisTime = datenum(filename(18:30), 'yyyymmdd_HHMM');

        if (thisTime >= tRange(1)) && (thisTime <= tRange(2))
            RSFiles = cat(2, RSFiles, filesInDay{iFile});
            RSTimes = cat(2, RSTimes, thisTime);
        end
    end
end

%% sort files according to time ascending order
[time, indx] = sort(RSTimes);
RSFilesSorted = RSFiles(indx);

%% read RS data
pres = [];
temp = [];
relh = [];
for iFile = 1:length(RSFilesSorted)
    [thisAlt, thisTemp, thisPres, thisRelh] = read_radiosonde(RSFilesSorted{iFile}, 2);

    if ~ isempty(thisAlt)
        presInterp = interp1(thisAlt, thisPres, altitude, 'linear', 'extrap');
        tempInterp = interp1(thisAlt, thisTemp, altitude, 'linear', 'extrap');
        relhInterp = interp1(thisAlt, thisRelh, altitude, 'linear', 'extrap');
    else
        presInterp = NaN(size(altitude));
        tempInterp = NaN(size(altitude));
        relhInterp = NaN(size(altitude));
    end

    pres = cat(2, pres, presInterp');
    temp = cat(2, temp, tempInterp');
    relh = cat(2, relh, relhInterp');
end

%% grided RS data
if ~ isempty(temp)
    [TIME, ALT] = meshgrid(time, altitude);
    [TIMEGrid, ALTGrid] = meshgrid(mTime, altitude);
    temp2D = interp2(TIME, ALT, temp, TIMEGrid, ALTGrid, 'linear');
end

end