function [sondeFile] = radiosonde_search(sondeFolder, measurementTime, fileType)
% RADIOSONDE_SEARCH Search the most close radiosonde data with given time.
%
% USAGE:
%    [sondeFile] = radiosonde_search(sondeFolder, measurementTime, fileType)
%
% INPUTS:
%    sondeFolder: str
%        the folder of the sonding files. 
%    measurementTime: datenum
%        the measurement time, which used for searching the closest sonding 
%        file.
%    fileType: integer
%        file type of the radiosonde file.
%        - 1: radiosonde file for MOSAiC (default)
%        - 2: radiosonde file for MUA (netCDF4)
%        - 3: CMA radiosonde file
%        - 4: radiosonde file for MUA (HDF5)
%
% OUTPUTS:
%    sondeFile: str
%        the filename of the searched sonding file. If no file was found, an 
%        empty string will be returned.
%
% EXAMPLE:
%
% HISTORY:
%    2019-07-19: First Edition by Zhenping
%    2019-12-18: Add `fileType` to specify the type of the radiosonde file.
% .. Authors: - zp.yin@whu.edu.cn

if ~ exist('fileType', 'var')
    fileType = 1;
end

sondeFile = '';

if ~ exist(sondeFolder, 'dir')
    warning(['sondeFolder does not exist! Please check you set the right ' ...
             'folder in config file. \n%s'], sondeFolder);
    return;
end

switch fileType
case 1   % standard file for MOSAiC

    %% list all the files
    sondeFileList = listfile(sondeFolder, 'radiosonde.*_\w{8}_\w{6}.nc');
    if isempty(sondeFileList)
        warning(['No required radiosonde files was found in the sonde folder. ' ...
                'Please go to the folder below to have a look.\n%s'], sondeFolder);
        return;
    end

    %% parse the radiosonde time
    sondeTime = NaN(size(sondeFileList));
    for iFile = 1:length(sondeFileList)
        filenameISondeFile = basename(sondeFileList{iFile});
        sondeTime(iFile) = datenum(filenameISondeFile(12:26), 'yyyymmdd_HHMMSS');
    end

    %% search the sonding file which is closest to the measurement time
    deltaTime = abs(sondeTime - measurementTime);
    [minDeltaTime, indxSondeFile] = min(deltaTime);
    % determine whether the time lapse is out of range (max T diff: 1 day)
    if minDeltaTime < datenum(0, 1, 1, 0, 0, 0)
        sondeFile = sondeFileList{indxSondeFile};
    else
        warning(['There was no sonde launching within 1 day.\n' ...
                'The measurement time: %s\nThe closest time of sonding: %s'], ...
                datestr(measurementTime, 'yyyymmdd HH:MM:SS'), ...
                datestr(sondeTime(indxSondeFile), 'yyyymmdd HH:MM:SS'));
    end

case 2   % MUA radiosonde standard file (netCDF4)

    %% list all files
    sondeFileList = listfile(fullfile(sondeFolder, datestr(measurementTime, 'yyyy')), 'radiosonde_.*_\d{8}_\d{4}.nc');
    if isempty(sondeFileList)
        warning(['No required radiosonde files was found in the sonde folder. ' ...
                'Please go to the folder below to have a look.\n%s'], sondeFolder);
        return;
    end

    %% parse the radiosonde time
    sondeTime = NaN(size(sondeFileList));
    for iFile = 1:length(sondeFileList)
        filenameISondeFile = basename(sondeFileList{iFile});
        sondeTime(iFile) = datenum(filenameISondeFile((end - 15):(end - 3)), 'yyyymmdd_HHMM');
    end

    %% search the sonding file which is closest to the measurement time
    deltaTime = abs(sondeTime - measurementTime);
    [minDeltaTime, indxSondeFile] = min(deltaTime);
    % determine whether the time lapse is out of range (max T diff: 1 day)
    if minDeltaTime < datenum(0, 1, 1, 0, 0, 0)
        sondeFile = sondeFileList{indxSondeFile};
    else
        warning(['There was no sonde launching within 1 day.\n' ...
                'The measurement time: %s\nThe closest time of sonding: %s'], ...
                datestr(measurementTime, 'yyyymmdd HH:MM:SS'), ...
                datestr(sondeTime(indxSondeFile), 'yyyymmdd HH:MM:SS'));
    end

case 3   % CMA radiosonde file

    %% list all files
    sondeFileList = listfile(fullfile(sondeFolder, datestr(measurementTime, 'yyyy')), 'UPAR_WEA_CHN_MUL_FTM_SEC.*\w*.txt');
    if isempty(sondeFileList)
        warning(['No required radiosonde files was found in the sonde folder. ' ...
                'Please go to the folder below to have a look.\n%s'], sondeFolder);
        return;
    end

    %% parse the radiosonde time
    sondeTime = NaN(size(sondeFileList));
    for iFile = 1:length(sondeFileList)
        filenameISondeFile = basename(sondeFileList{iFile});
        sondeTime(iFile) = datenum(filenameISondeFile((end - 13):(end - 4)), 'yyyymmddHH');
    end

    %% search the sonding file which is closest to the measurement time
    deltaTime = abs(sondeTime - measurementTime);
    [minDeltaTime, indxSondeFile] = min(deltaTime);
    % determine whether the time lapse is out of range (max T diff: 1 day)
    if minDeltaTime < datenum(0, 1, 1, 0, 0, 0)
        sondeFile = sondeFileList{indxSondeFile};
    else
        warning(['There was no sonde launching within 1 day.\n' ...
                'The measurement time: %s\nThe closest time of sonding: %s'], ...
                datestr(measurementTime, 'yyyymmdd HH:MM:SS'), ...
                datestr(sondeTime(indxSondeFile), 'yyyymmdd HH:MM:SS'));
    end

case 4   % MUA radiosonde standard file (HDF5)

    %% list all files
    sondeFileList = listfile(fullfile(sondeFolder, datestr(measurementTime, 'yyyy')), '\w{15}UTC.h5');
    if isempty(sondeFileList)
        warning(['No required radiosonde files was found in the sonde folder. ' ...
                'Please go to the folder below to have a look.\n%s'], sondeFolder);
        return;
    end

    %% parse the radiosonde time
    sondeTime = NaN(size(sondeFileList));
    for iFile = 1:length(sondeFileList)
        filenameISondeFile = basename(sondeFileList{iFile});
        sondeTime(iFile) = datenum(filenameISondeFile((end - 15):(end - 6)), 'yyyymmddHH');
    end

    %% search the sonding file which is closest to the measurement time
    deltaTime = abs(sondeTime - measurementTime);
    [minDeltaTime, indxSondeFile] = min(deltaTime);
    % determine whether the time lapse is out of range (max T diff: 1 day)
    if minDeltaTime < datenum(0, 1, 1, 0, 0, 0)
        sondeFile = sondeFileList{indxSondeFile};
    else
        warning(['There was no sonde launching within 1 day.\n' ...
                'The measurement time: %s\nThe closest time of sonding: %s'], ...
                datestr(measurementTime, 'yyyymmdd HH:MM:SS'), ...
                datestr(sondeTime(indxSondeFile), 'yyyymmdd HH:MM:SS'));
    end

otherwise
    error('Unknown radiosonde fileType %d', fileType);
end

end