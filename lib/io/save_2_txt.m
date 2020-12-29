function save_2_txt(handles, saveFile)
%SAVE_2_TXT save configurations to ASCII file.
%Inputs:
%   handles: struct
%   saveFile: char
%       absolute path of the MAT file.
%History:
%   2020-07-06. First edition by Zhenping
%Contact:
%   zp.yin@whu.edu.cn

fid = fopen(saveFile, 'w');

fprintf(fid, 'lidar data directory: %s\n', handles.settings.dataDir);
fprintf(fid, 'lidar data version: %d\n', handles.settings.data_version);
fprintf(fid, 'GDAS1 data directory: %s\n', handles.settings.GDAS1Dir);
fprintf(fid, 'Radiosonde data directory: %s\n', handles.settings.soundingDir);
fprintf(fid, 'ERA5 data directory: %s\n', handles.settings.ERA5Dir);
fprintf(fid, 'cloud case save directory: %s\n', handles.settings.saveDir);
fprintf(fid, 'setting file directory: %s\n', handles.setting_tb.String);
fprintf(fid, 'cloud case file: %s\n', handles.infoFile_tb.String);
fprintf(fid, 'lidar data start time: %s\n', handles.starttime_tb.String);
fprintf(fid, 'lidar data stop time: %s\n', handles.stoptime_tb.String);
fprintf(fid, 'lidar data base height (km): %s\n', handles.cloud_base_tb.String);
fprintf(fid, 'lidar data top height (km): %s\n', handles.cloud_top_tb.String);
fprintf(fid, 'cloud start time: %s\n', handles.cloud_start_tb.String);
fprintf(fid, 'cloud stop time: %s\n', handles.cloud_stop_tb.String);
fprintf(fid, 'meteorological data source: %s\n', handles.meteor_data_pm.String{handles.meteor_data_pm.Value});
fprintf(fid, 'cloud phase: %s\n', handles.cloud_phase_pm.String{handles.cloud_phase_pm.Value});
fprintf(fid, 'cloud top temperature (degC): %s\n', handles.CTT_tb.String);
fprintf(fid, 'lidar depol gain ratio: %s\n', handles.gainRatio_tb.String);
fprintf(fid, 'cloud top signal/noise ratio: %s\n', handles.cloud_top_signal_2_bg_tb.String);
fprintf(fid, 'retrieval start time: %s\n', handles.ret_starttime_tb.String);
fprintf(fid, 'retrieval stop time: %s\n', handles.ret_stoptime_tb.String);
fprintf(fid, 'retrieval base height (km): %s\n', handles.ret_H_bottom_tb.String);
fprintf(fid, 'retrieval top height (km): %s\n', handles.ret_H_top_tb.String);
fprintf(fid, 'retrieval reference base height (km): %s\n', handles.ref_H_bottom_tb.String);
fprintf(fid, 'retrieval reference top height (km): %s\n', handles.ref_H_top_tb.String);
fprintf(fid, 'min backscatter coefficient (Mm-1sr-1): %s\n', handles.bsc_bottom_tb.String);
fprintf(fid, 'max backscatter coefficient (Mm-1sr-1): %s\n', handles.bsc_top_tb.String);
fprintf(fid, 'reference value (Mm-1sr-1): %s\n', handles.ref_value_tb.String);
fprintf(fid, 'min mass conc. (ugm-3): %s\n', handles.mass_bottom_tb.String);
fprintf(fid, 'max mass conc. (ugm-3): %s\n', handles.mass_top_tb.String);
fprintf(fid, 'lidar ratio (sr): %s\n', handles.lr_tb.String);
fprintf(fid, 'molecular depolarization ratio: %s\n', handles.mol_depol_tb.String);
fprintf(fid, 'aerosol layer base (km): %s\n', handles.LayerBase_tb.String);
fprintf(fid, 'aerosol layer top (km): %s\n', handles.LayerTop_tb.String);
fprintf(fid, 'smooth window (m): %s\n', handles.smoothwin_tb.String);
fprintf(fid, 'colormap: %s\n', handles.cmap_pm.String{handles.cmap_pm.Value});
fprintf(fid, 'range corrected signal scale: %s\n', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value});
fprintf(fid, 'min range corrected signal (a.u.): %s\n', handles.RCS_bottom_tb.String);
fprintf(fid, 'max range corrected signal (a.u.): %s\n', handles.RCS_top_tb.String);
fprintf(fid, 'min depol: %s\n', handles.VDR_bottom_tb.String);
fprintf(fid, 'max depol: %s\n', handles.VDR_top_tb.String);
fprintf(fid, 'min temperature (degC): %s\n', handles.Temp_bottom_tb.String);
fprintf(fid, 'max temperature (degC): %s\n', handles.Temp_top_tb.String);
fprintf(fid, '\n');
fprintf(fid, 'Processed by cloud_evaluation_GUI at %s\n', tNow);
progInfo = programInfo();
fprintf(fid, 'program name: %s\n', progInfo.Name);
fprintf(fid, 'program version: %s\n', progInfo.Version);
fprintf(fid, 'program author: %s\n', progInfo.Author);

fclose(fid);

end