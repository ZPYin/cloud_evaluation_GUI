function hdf5writedata(filename, location, data, dataAttr, deflate)
%hdf5writedata Write data and data attributes to HDF5 file.
%   Example:
%       hdf5writedata(filename, location, data, dataAttr, deflate)
%   Inputs:
%       filename: char
%           HDF5 filename. (with absolute path)
%       location: char
%           location of the dataset.
%       data: array
%           exported data.
%       dataAttr: struct
%           dataset attributes.
%       deflate: integer
%           compression level.
%   History:
%       2019-11-11. First Edition by Zhenping
%   Contact:
%       zp.yin@whu.edu.cn

if ~ exist('deflate', 'var')
    deflate = 6;
end

if iscell(data) || ischar(data)
    slashPos = strfind(location, '/');

    if isempty(slashPos)
        error('Not a valid position: %s', location);
    end

    dset_details.Location = location(1:slashPos(end));
    dset_details.Name = location(slashPos(end) + 1:end);

    hdf5write(filename, dset_details, data, 'WriteMode', 'append');

    keys = fieldnames(dataAttr);
    for iKey = 1:length(keys)
        attr_details.Name = keys{iKey};
        attr_details.AttachedTo = location;
        attr_details.AttachType = 'dataset';

        hdf5write(filename, attr_details, dataAttr.(keys{iKey}), 'WriteMode', 'append');
    end

elseif isnumeric(data)

    if isrow(data) || iscolumn(data)
        data_size = length(data);
        chunksize = ceil(data_size / 8);
    else
        data_size = size(data);
        chunksize = ceil(data_size / 8);
    end
    h5create(filename, location, data_size, 'Deflate', deflate, 'Chunksize', chunksize);
    h5write(filename, location, data);
    
    keys = fieldnames(dataAttr);
    for iKey = 1:length(keys)
        attName = keys{iKey};
        h5writeatt(filename, location, attName, dataAttr.(attName));
    end

else
    error('Unsupported dataset for HDF5 file.');
end

end