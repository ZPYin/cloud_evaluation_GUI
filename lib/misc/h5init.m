function [] = h5init(filename)
%h5init Create an empty HDF5 file with specified mode.
%   Example:
%       [] = h5init(filename)
%   Inputs:
%       filename: char
%           absolute filepath of the HDF5 file.
%   Outputs:
%       
%   History:
%       2019-12-18. First Edition by Zhenping
%   Contact:
%       zp.yin@whu.edu.cn

[~, ~, fileExt] = fileparts(filename);

if ~ strcmpi(fileExt, '.h5')
    error('filename was not specified to HDF5 file format');
end

fcpl = H5P.create('H5P_FILE_CREATE');
fapl = H5P.create('H5P_FILE_ACCESS');
fid = H5F.create(filename, 'H5F_ACC_TRUNC', fcpl, fapl);
H5F.close(fid);

end