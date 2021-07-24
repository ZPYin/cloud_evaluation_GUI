function h5_attach_scale(file, src_ds_name, dim_ds_name, dimension)
% H5_ATTACH_SCALE attach the dimension for HDF5 file.
% Example:
%    h5_attach_scale(file, src_ds_name, dim_ds_name, dimension)
% Inputs:
%    file: char
%        absolute path of the HDF5 file.
%    src_ds_name: char
%        HDF5 variable path for the variable that you want to attach the dimension to. i.e, '/grp1/test'
%    dim_ds_name: char
%        HDF5 variable path for the dimension variable. i.e, '/height'
%    dimension: integer
%        the dimension that you want to attach the variable.
% History:
%    2020-03-22. First Edition by Zhenping
% Contact:
%    zp.yin@whu.edu.cn

plist = 'H5P_DEFAULT';

fid = H5F.open(file, 'H5F_ACC_RDWR', plist);

src_ds_id = H5D.open(fid, src_ds_name, plist);
dim_ds_id = H5D.open(fid, dim_ds_name, plist);

split_res = regexp(dim_ds_name, '/', 'split');
H5DS.set_scale(dim_ds_id, split_res{end});
H5DS.attach_scale(src_ds_id, dim_ds_id, dimension);

H5D.close(src_ds_id);
H5D.close(dim_ds_id);
H5F.close(fid);

end