function data = PLidar_readdata(folder, tRange, hRange, dVersion)
%PLIDAR_READDATA read PLidar data in the given temporal and spatial range.
%
%Examples:
%   data = PLidar_readdata('/data/PLidar', ...
%                  [datenum(2011, 1, 1), datenum(2011, 1, 2, 12, 0, 0)], ...
%                  [300, 5000]);
%Inputs:
%   folder: char
%       base directory of the PLidar data.
%   tRange: 2-element array
%       start and stop time of the data that you want to load.
%   hRange: 2-element array
%       bottom and top height of the data that you want to load. [m]
%   dVersion: integer
%       data version (default: 2).
%       1: glued by old algorithm with 30-m resolution
%       2: glued by new algorithm with 3.75-m resolution (default)
%Returns:
%   data: struct
%       time: (datenum) array
%           measurement time of each data profile.
%       height: array
%           height above ground of each range bin. [m]
%       altitude: array
%           altitude of each range bin. [m]
%       records: array
%           accumulated shots for single profile.
%       CH1_PC: matrix (height x time)
%           photon count rate signal at channel 1 (parallel). [MHz]
%       CH2_PC: matrix (height x time)
%           photon count rate signal at channel 2 (vertical). [MHz]
%       CH1_BG: array
%           background signal for each profile at channel 1. [MHz]
%       CH2_BG: array
%           background signal for each profile at channel 2. [MHz]
%       CH1_overflow: array
%           overflow flag for each bin at channel 1, in which 1 stands for
%           'overflowed'.
%       CH2_overflow: array
%           overflow flag for each bin at channel 2, in which 1 stands for
%           'overflowed'.
%History:
%   2020-03-03 First version by Zhenping

if nargin < 3
    error('No enough inputs.')
end

if ~ exist('dVersion', 'var')
    dVersion = 2;
end

mDateArr = floor(tRange(1)):floor(tRange(2));
data = struct();
data.time = [];
data.height = [];
data.altitude = [];
data.records = [];
data.CH1_PC = [];
data.CH2_PC = [];
data.CH1_BG = [];
data.CH2_BG = [];
data.CH1_overflow = [];
data.CH2_overflow = [];

for iDate = 1:length(mDateArr)
    mDate = mDateArr(iDate);

    subdata = PLidar_read_data(mDate, folder, dVersion, hRange, tRange);

    if isfield(subdata, 'height')
        data.height = subdata.height;
        data.altitude = subdata.altitude;
        data.time = cat(2, data.time, subdata.time);
        data.records = cat(1, data.records, subdata.records);
        data.CH1_PC = cat(2, data.CH1_PC, subdata.CH1_PC);
        data.CH2_PC = cat(2, data.CH2_PC, subdata.CH2_PC);
        data.CH1_BG = cat(2, data.CH1_BG, subdata.CH1_BG);
        data.CH2_BG = cat(2, data.CH2_BG, subdata.CH2_BG);
        data.CH1_overflow = cat(2, data.CH1_overflow, subdata.CH1_overflow);
        data.CH2_overflow = cat(2, data.CH2_overflow, subdata.CH2_overflow);
    end
end

end