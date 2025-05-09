function hdf5writedata(filename, location, data, varargin)
% HDF5WRITEDATA Write data and data attributes to HDF5 file.
%
% USAGE:
%    % Usecase 1: save variable to HDF5 file
%    hdf5writedata('/path/to/h5', '/data', data)
%
%    % Usecase 2: save variable to HDF5 file with attributes
%    hdf5writedata('/path/to/h5', '/data', data, 'dataAttr', ...
%                  struct('type', 'float'))
%
% INPUTS:
%    filename: char
%        HDF5 filename. (with absolute path)
%    location: char
%        location of the dataset.
%    data: array
%        exported data.
%
% KEYWORDS:
%    dataAttr: struct
%        dataset attributes.
%    deflate: integer
%        compression level (default: 6).
%    FillValue: integer
%        filling value (default: -999).
%    flagArray: logical
%
% OUTPUTS:
%
% EXAMPLE:
%
% HISTORY:
%    2019-11-11: first edition by Zhenping
% .. Authors: - zp.yin@whu.edu.cn

p = inputParser;
p.KeepUnmatched = true;

addRequired(p, 'filename', @ischar);
addRequired(p, 'location', @ischar);
addRequired(p, 'data');
addParameter(p, 'dataAttr', struct(), @isstruct);
addParameter(p, 'deflate', 6, @isnumeric);
addParameter(p, 'FillValue', -999, @isnumeric);
addParameter(p, 'flagArray', false, @islogical);

parse(p, filename, location, data, varargin{:});

if iscell(data) || ischar(data) || isstruct(data)

    % for non-numeric data
    slashPos = strfind(location, '/');

    if isempty(slashPos)
        error('Not a valid position: %s', location);
    end

    dset_details.Location = location(1:slashPos(end));
    dset_details.Name = location(slashPos(end) + 1:end);

    hdf5write(filename, dset_details, data, 'WriteMode', 'append');

    keys = fieldnames(p.Results.dataAttr);
    for iKey = 1:length(keys)
        attr_details.Name = keys{iKey};
        attr_details.AttachedTo = location;
        attr_details.AttachType = 'dataset';

        hdf5write(filename, attr_details, p.Results.dataAttr.(keys{iKey}), ...
                  'WriteMode', 'append');
    end

elseif isnumeric(data)

    % for numeric data
    if (iscolumn(data) || isrow(data)) && p.Results.flagArray
        data_size = length(data);
        chunksize = ceil(data_size / 8);
    else
        data_size = size(data);
        chunksize = ceil(data_size / 8);
    end

    h5create(filename, location, data_size, 'Deflate', p.Results.deflate, ...
             'Chunksize', chunksize, 'FillValue', p.Results.FillValue);
    h5write(filename, location, data);

    keys = fieldnames(p.Results.dataAttr);
    for iKey = 1:length(keys)
        attName = keys{iKey};
        h5writeatt(filename, location, attName, p.Results.dataAttr.(attName));
    end

else
    error('Unsupported dataset for HDF5 file.');
end

end