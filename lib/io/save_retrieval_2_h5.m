function save_retrieval_2_h5(handles, h5Filepath)
% SAVE_RETRIEVAL_2_H5 save retrieving results to HDF5 file.
% Inputs:
%    handles: struct
%    saveFile: char
%        absolute path of the MAT file.
% History:
%    2020-07-06. First edition by Zhenping
% Contact:
%    zp.yin@whu.edu.cn

h5init(h5Filepath);

progInfo = programInfo();
metadata = handles.settings.metadata;
metadata.processor_name = progInfo.Name;
metadata.processor_version = progInfo.Version;
metadata.location = 'Wuhan';

% save global attributes
globalAttriFields = fieldnames(metadata);
for iField = 1:length(globalAttriFields)
    attri_details.Name = globalAttriFields{iField};
    attri_details.AttachedTo = '/';
    attri_details.AttachType = 'group';

    hdf5write(h5Filepath, attri_details, ...
              metadata.(globalAttriFields{iField}), 'WriteMode', 'append');
end

% write history
attr_item = sprintf(...
    'Processed time %s; processor_name %s; processor_version: %s;', ...
    datestr(now, 'yyyy-mm-dd HH:MM:SS'), ...
metadata.processor_name, metadata.processor_version);
attr_details.Name = 'history';
attr_details.AttachedTo = '/';
attr_details.AttachType = 'group';

hdf5write(h5Filepath, attr_details, attr_item, 'WriteMode', 'append');

% save data
hdf5writedata(...
    h5Filepath, ...
    '/start_time', ...
    handles.ret_starttime_tb.String, ...
    struct('Description', 'start time of the averaged period'));
hdf5writedata(...
    h5Filepath, ...
    '/stop_time', ...
    handles.ret_stoptime_tb.String, ...
    struct('Description', 'stop time of the averaged period'));
hdf5writedata(...
    h5Filepath, ...
    '/height', ...
    handles.ret_height * 1e3, ...
    struct('long_name', 'height above ground', 'standard_name', 'height', ...
           'Units', 'm', 'axis', 'Z', 'positive', 'up'));
hdf5writedata(...
    h5Filepath, ...
    '/particle_backscatter', ...
    handles.ret_bsc_Profi, ...
    struct('long_name', 'aerosol backscatter coefficient', ...
           'standard_name', 'par_bsc', 'axis', 'X', 'Units', 'm^{-1}*sr^{-1}'));
h5_attach_scale(h5Filepath, '/particle_backscatter', '/height', 0);
hdf5writedata(...
    h5Filepath, ...
    '/error_particle_backscatter', ...
    handles.ret_bsc_std_Profi, ...
    struct(...
        'long_name', ...
        'absolute statistical uncertainty of aerosol backscatter coefficient', ...
        'standard_name', 'std_par_bsc', 'axis', 'X', 'Units', 'm^{-1}*sr^{-1}'));
h5_attach_scale(h5Filepath, '/error_particle_backscatter', '/height', 0);
hdf5writedata(...
    h5Filepath, ...
    '/particle_backscatter_dust', ...
    handles.ret_bsc_d_Profi, ...
    struct('long_name', 'dust backscatter coefficient', ...
           'standard_name', 'par_bsc', 'axis', 'X', 'Units', 'm^{-1}*sr^{-1}'));
h5_attach_scale(h5Filepath, '/particle_backscatter_dust', '/height', 0);
hdf5writedata(...
    h5Filepath, ...
    '/error_particle_backscatter_dust', ...
    handles.ret_bsc_d_std_Profi, ...
    struct(...
        'long_name', ...
        'absolute statistical uncertainty of dust backscatter coefficient', ...
        'standard_name', 'std_par_bsc', 'axis', 'X', 'Units', 'm^{-1}*sr^{-1}'));
h5_attach_scale(h5Filepath, '/error_particle_backscatter_dust', '/height', 0);
hdf5writedata(...
    h5Filepath, ...
    '/dust_mass_concentration', ...
    handles.ret_mass_d_Profi, ...
    struct('long_name', 'dust mass concentration', ...
           'standard_name', 'M_d', 'axis', 'X', 'Units', '\mug*m^{-3}'));
h5_attach_scale(h5Filepath, '/dust_mass_concentration', '/height', 0);
hdf5writedata(...
    h5Filepath, ...
    '/error_dust_mass_concentration', ...
    handles.ret_mass_d_std_Profi, ...
    struct(...
        'long_name', ...
        'absolute statistical uncertainty of dust mass concentration', ...
        'standard_name', 'std_M_d', 'axis', 'X', 'Units', '\mug*m^{-3}'));
h5_attach_scale(h5Filepath, '/error_dust_mass_concentration', '/height', 0);
hdf5writedata(...
    h5Filepath, ...
    '/non_dust_mass_concentration', ...
    handles.ret_mass_nd_Profi, ...
    struct('long_name', 'non-dust mass concentration', ...
           'standard_name', 'M_nd', 'axis', 'X', 'Units', '\mug*m^{-3}'));
h5_attach_scale(h5Filepath, '/non_dust_mass_concentration', '/height', 0);
hdf5writedata(...
    h5Filepath, ...
    '/error_non_dust_mass_concentration', ...
    handles.ret_mass_nd_std_Profi, ...
    struct(...
        'long_name', ...
        'absolute statistical uncertainty of non dust mass concentration', ...
        'standard_name', 'std_M_nd', 'axis', 'X', 'Units', '\mug*m^{-3}'));
h5_attach_scale(h5Filepath, '/error_non_dust_mass_concentration', '/height', 0);
hdf5writedata(...
    h5Filepath, ...
    '/volume_depolarization_ratio', ...
    handles.ret_VDR_Profi, ...
    struct('long_name', 'volume depolarization ratio at 532 nm', ...
           'standard_name', 'delta_v', 'axis', 'X', 'Units', ''));
h5_attach_scale(h5Filepath, '/volume_depolarization_ratio', '/height', 0);
hdf5writedata(...
    h5Filepath, ...
    '/error_volume_depolarization_ratio', ...
    handles.ret_VDR_std_Profi, ...
    struct(...
        'long_name', ...
        'absolute statistical uncertainty of aerosol depolarization ratio at 532 nm', ...
        'standard_name', 'std_delta_v', 'axis', 'X', 'Units', ''));
h5_attach_scale(h5Filepath, '/error_volume_depolarization_ratio', '/height', 0);
hdf5writedata(...
    h5Filepath, ...
    '/particle_depolarization_ratio', ...
    handles.ret_PDR_Profi, ...
    struct('long_name', 'aerosol depolarization ratio at 532 nm', ...
           'standard_name', 'delta_p', 'axis', 'X', 'Units', ''));
h5_attach_scale(h5Filepath, '/particle_depolarization_ratio', '/height', 0);
hdf5writedata(...
    h5Filepath, ...
    '/error_particle_depolarization_ratio', ...
    handles.ret_PDR_std_Profi, ...
    struct(...
        'long_name', ...
        'absolute statistical uncertainty of aerosol depolarization ratio at 532 nm', ...
        'standard_name', 'std_delta_p', 'axis', 'X', 'Units', ''));
h5_attach_scale(h5Filepath, '/error_particle_depolarization_ratio', '/height', 0);
hdf5writedata(...
    h5Filepath, ...
    '/backscatter_calibration_range', ...
    [str2double(handles.ref_H_bottom_tb.String) * 1000, str2double(handles.ref_H_top_tb.String) * 1000], ...
    struct(...
        'long_name', 'height range where calibration was calculated', ...
        'standard_name', 'cali_range', 'Units', 'm'));
hdf5writedata(...
    h5Filepath, ...
    '/backscatter_calibration_value', ...
    str2double(handles.ref_value_tb.String) * 1e-6, ...
    struct('long_name', 'reference value for Fernald retrieval', ...
           'standard_name', 'cali_value', 'Units', 'm^{-1}*sr^{-1}'));
hdf5writedata(...
    h5Filepath, ...
    '/particle_lidar_ratio', ...
    str2double(handles.lr_tb.String), ...
    struct('long_name', 'particle lidar ratio', ...
           'standard_name', 'S_{aer}', 'axis', 'X', 'Units', 'sr'));
hdf5writedata(...
    h5Filepath, ...
    '/depolarization_calibration_constant', ...
    str2double(handles.gainRatio_tb.String), ...
    struct('long_name', 'depolarization calibration ratio', ...
            'standard_name', 'K', 'Units', ''));
hdf5writedata(...
    h5Filepath, ...
    '/meteorological_source', ...
    handles.meteor_data_pm.String{handles.meteor_data_pm.Value}, ...
    struct('long_name', 'meteorological data source'));
hdf5writedata(...
    h5Filepath, ...
    '/temperature', ...
    handles.ret_Temp_Profi, ...
    struct('long_name', 'temperature profile', ...
           'standard_name', 'T', 'axis', 'X', 'Units', 'degree celsius'));
h5_attach_scale(h5Filepath, '/temperature', '/height', 0);
hdf5writedata(...
    h5Filepath, ...
    '/pressure', ...
    handles.ret_Pres_Profi, ...
    struct('long_name', 'pressure profile', ...
           'standard_name', 'P', 'axis', 'X', 'Units', 'hPa'));
h5_attach_scale(h5Filepath, '/pressure', '/height', 0);
hdf5writedata(...
    h5Filepath, ...
    '/smooth_window', ...
    str2double(handles.smoothwin_tb.String), ...
    struct('long_name', 'smooth window', 'Units', 'm'));
hdf5writedata(...
    h5Filepath, ...
    '/wavelength', ...
    str2double(handles.wavelength_tb.String), ...
    struct('long_name', 'wavelength', 'Units', 'nm'));

end