function h5init(filename)
% H5INIT Create an empty HDF5 file with specified mode.
%
% USAGE:
%    h5init(filename)
%
% INPUTS:
%       filename: char
%           absolute filepath of the HDF5 file.
%
% HISTORY:
%    2019-12-18: first edition by Zhenping
% .. Authors: - zp.yin@whu.edu.cn

[~, ~, fileExt] = fileparts(filename);

if ~ strcmpi(fileExt, '.h5')
    error('Filename was not specified to HDF5 file format');
end

fcpl = H5P.create('H5P_FILE_CREATE');
fapl = H5P.create('H5P_FILE_ACCESS');
fid = H5F.create(filename, 'H5F_ACC_TRUNC', fcpl, fapl);
H5F.close(fid);

end