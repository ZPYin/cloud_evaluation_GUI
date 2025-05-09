function data = PLidar_readdata(folder, tRange, hRange, varargin)
% PLIDAR_READDATA read PLidar data in the given temporal and spatial range.
% Examples:
%    data = PLidar_readdata('/data/PLidar', ...
%                   [datenum(2011, 1, 1), datenum(2011, 1, 2, 12, 0, 0)], ...
%                   [300, 5000]);
% Inputs:
%    folder: char
%        base directory of the PLidar data.
%    tRange: 2-element array
%        start and stop time of the data that you want to load.
%    hRange: 2-element array
%        bottom and top height of the data that you want to load. [m]
% Keywords:
%    dVersion: integer
%        data version (default: 2).
%        1: glued by old algorithm with 30-m resolution
%        2: glued by new algorithm with 3.75-m resolution (default)
%        3: CMA polarization lidar
%        4: WHU 1030 vis lidar
% Returns:
%    data: struct
%        time: (datenum) array
%            measurement time of each data profile.
%        height: array
%            height above ground of each range bin. [m]
%        altitude: array
%            altitude of each range bin. [m]
%        records: array
%            accumulated shots for single profile.
%        sigCH1: matrix (height x time)
%            photon count rate signal at channel 1 (parallel). [MHz]
%            or analog data (parallel).
%        sigCH2: matrix (height x time)
%            photon count rate signal at channel 2 (vertical). [MHz]
%            or analog data (vertical).
%        BGCH1: array
%            background signal for each profile at channel 1.
%        BGCH2: array
%            background signal for each profile at channel 2.
% History:
%    2020-03-03 First version by Zhenping

p = inputParser;
p.KeepUnmatched = true;

addRequired(p, 'folder', @ischar);
addRequired(p, 'tRange', @isnumeric);
addRequired(p, 'hRange', @isnumeric);
addParameter(p, 'dVersion', 2, @isnumeric);

parse(p, folder, tRange, hRange, varargin{:});

mDateArr = floor(tRange(1)):floor(tRange(2));
data = struct();
data.time = [];
data.height = [];
data.altitude = [];
data.records = [];
data.sigCH1 = [];
data.sigCH2 = [];
data.BGCH1 = [];
data.BGCH2 = [];

for iDate = 1:length(mDateArr)
    mDate = mDateArr(iDate);

    subdata = PLidar_read_data(mDate, folder, p.Results.dVersion, hRange, tRange);

    if isfield(subdata, 'height')
        data.height = subdata.height;
        data.altitude = subdata.altitude;
        data.time = cat(2, data.time, subdata.time);
        data.records = cat(1, data.records, subdata.records);
        data.sigCH1 = cat(2, data.sigCH1, subdata.sigCH1);
        data.sigCH2 = cat(2, data.sigCH2, subdata.sigCH2);
        data.BGCH1 = cat(2, data.BGCH1, subdata.BGCH1);
        data.BGCH2 = cat(2, data.BGCH2, subdata.BGCH2);
    end
end

end