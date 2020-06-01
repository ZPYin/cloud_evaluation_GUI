function temp2D = read_gridTemp_GDAS1(mTime, altitude, ...
                                    folder, gdas1site, deltaTime)
%read_gridTemp_GDAS1 read gridded GDAS1 data
%Example:
%   temp2D = read_gridTemp_GDAS1(mTime, altitude, folder, gdas1site, deltaTime)
%Inputs:
%   mTime: array
%       measurement time. (UTC)
%   altitude: array
%       height above mean sea level. (m)
%   folder: char
%       GDAS1 data folder.
%   gdas1site: char
%       gdas1 site (default: 'wuhan').
%   deltaTime: numeric
%       delta time for profile searching.
%Outputs:
%   temp: matrix (altitude * time)
%       temperature for each range bin. If no valid data, NaN will be 
%       filled. [C]
%History:
%   2020-03-17. First Edition by Zhenping
%Contact:
%   zhenping@tropos.de

temp2D = NaN(numel(altitude), numel(mTime));

if isempty(mTime) || isempty(altitude)
    return;
end

tRange = [mTime(1) - deltaTime, mTime(end) + deltaTime];
dates = floor(tRange(1)):floor(tRange(2));

%% search gdas1 files in the given temporal range
gdas1Files = cell(0);
gdas1Times = [];
for iDate = 1:length(dates)
    thisDate = dates(iDate);
    filesInDay = listfile(fullfile(folder, gdas1site, ...
        datestr(thisDate, 'yyyy'), datestr(thisDate, 'mm')), ...
        sprintf('.*%s.*.gdas1', datestr(thisDate, 'yyyymmdd')));

    for iFile = 1:length(filesInDay)
        thisTime = gdas1FileTimestamp(basename(filesInDay{iFile}));

        if (thisTime >= tRange(1)) && (thisTime <= tRange(2))
            gdas1Files = cat(2, gdas1Files, filesInDay{iFile});
            gdas1Times = cat(2, gdas1Times, thisTime);
        end
    end
end

%% sort files according to time ascending order
[time, indx] = sort(gdas1Times);
gdas1FilesSorted = gdas1Files(indx);

%% read GDAS1 data
pres = [];
temp = [];
relh = [];
for iFile = 1:length(gdas1FilesSorted)
    [thisPres, thisAlt, thisTemp, thisRelh] = ceilo_bsc_ModelSonde(gdas1FilesSorted{iFile});

    presInterp = interp1(thisAlt, thisPres, altitude, 'linear', 'extrap');
    tempInterp = interp1(thisAlt, thisTemp, altitude, 'linear', 'extrap');
    relhInterp = interp1(thisAlt, thisRelh, altitude, 'linear', 'extrap');

    pres = cat(2, pres, presInterp');
    temp = cat(2, temp, tempInterp');
    relh = cat(2, relh, relhInterp');
end

%% grided GDAS1 data
if ~ isempty(temp)
    [TIME, ALT] = meshgrid(time, altitude);
    [TIMEGrid, ALTGrid] = meshgrid(mTime, altitude);
    temp2D = interp2(TIME, ALT, temp, TIMEGrid, ALTGrid, 'linear');
end

end