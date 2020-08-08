function convert_mat_2_txt(matFile, txtFile)
%CONVERT_MAT_2_TXT convert mat file to txt file.
%Inputs:
%   matFile: char
%       absolute path of the MAT file.
%   txtFile: char
%       absolute path of the TXT file.
%History:
%   2020-07-06. First edition by Zhenping
%Contact:
%   zp.yin@whu.edu.cn

if exist(matFile, 'file') ~= 2
    return;
end

data = load(matFile, 'widgetInfo', 'settings');

fid = fopen(txtFile, 'w');

fprintf(fid, 'lidar data directory: %s\n', data.settings.dataDir);
fprintf(fid, 'lidar data version: %d\n', data.settings.data_version);
fprintf(fid, 'GDAS1 data directory: %s\n', data.settings.GDAS1Dir);
fprintf(fid, 'Radiosonde data directory: %s\n', data.settings.soundingDir);
fprintf(fid, 'ERA5 data directory: %s\n', data.settings.ERA5Dir);
fprintf(fid, 'cloud case save directory: %s\n', data.settings.saveDir);
fprintf(fid, 'setting file directory: %s\n', data.widgetInfo.settingFile);
fprintf(fid, 'cloud case file: %s\n', data.widgetInfo.infoFile);
fprintf(fid, 'lidar data start time: %s\n', data.widgetInfo.starttime);
fprintf(fid, 'lidar data stop time: %s\n', data.widgetInfo.stoptime);
fprintf(fid, 'lidar data base height (km): %s\n', data.widgetInfo.cloud_base);
fprintf(fid, 'lidar data top height (km): %s\n', data.widgetInfo.cloud_top);
fprintf(fid, 'cloud start time: %s\n', data.widgetInfo.cloud_start);
fprintf(fid, 'cloud stop time: %s\n', data.widgetInfo.cloud_stop);
fprintf(fid, 'meteorological data source: %s\n', data.widgetInfo.meteor_data);
fprintf(fid, 'cloud phase: %s\n', data.widgetInfo.cloud_phase);
fprintf(fid, 'cloud top temperature (degC): %s\n', data.widgetInfo.CTT);
fprintf(fid, 'lidar depol gain ratio: %s\n', data.widgetInfo.gainRatio);
fprintf(fid, 'lidar depol offset: %s\n', data.widgetInfo.offset);
fprintf(fid, 'cloud top signal/noise ratio: %s\n', data.widgetInfo.cloud_top_sig_2_bg);
fprintf(fid, 'retrieval start time: %s\n', data.widgetInfo.ret_starttime);
fprintf(fid, 'retrieval stop time: %s\n', data.widgetInfo.ret_stoptime);
fprintf(fid, 'retrieval base height (km): %s\n', data.widgetInfo.ret_H_bottom);
fprintf(fid, 'retrieval top height (km): %s\n', data.widgetInfo.ret_H_top);
fprintf(fid, 'retrieval reference base height (km): %s\n', data.widgetInfo.ref_H_bottom);
fprintf(fid, 'retrieval reference top height (km): %s\n', data.widgetInfo.ref_H_top);
fprintf(fid, 'min backscatter coefficient (Mm-1sr-1): %s\n', data.widgetInfo.bsc_bottom);
fprintf(fid, 'max backscatter coefficient (Mm-1sr-1): %s\n', data.widgetInfo.bsc_top);
fprintf(fid, 'reference value (Mm-1sr-1): %s\n', data.widgetInfo.ref_value);
fprintf(fid, 'min mass conc. (ugm-3): %s\n', data.widgetInfo.mass_bottom);
fprintf(fid, 'max mass conc. (ugm-3): %s\n', data.widgetInfo.mass_top);
fprintf(fid, 'lidar ratio (sr): %s\n', data.widgetInfo.lr);
fprintf(fid, 'molecular depolarization ratio: %s\n', data.widgetInfo.mol_depol);
fprintf(fid, 'aerosol layer base (km): %s\n', data.widgetInfo.LayerBase);
fprintf(fid, 'aerosol layer top (km): %s\n', data.widgetInfo.LayerTop);
fprintf(fid, 'smooth window (m): %s\n', data.widgetInfo.smoothwin);
fprintf(fid, 'range corrected signal scale: %s\n', data.widgetInfo.RCS_scale);
fprintf(fid, 'min range corrected signal (a.u.): %s\n', data.widgetInfo.RCS_bottom);
fprintf(fid, 'max range corrected signal (a.u.): %s\n', data.widgetInfo.RCS_top);
fprintf(fid, 'min depol: %s\n', data.widgetInfo.VDR_bottom);
fprintf(fid, 'max depol: %s\n', data.widgetInfo.VDR_top);
fprintf(fid, 'min temperature (degC): %s\n', data.widgetInfo.Temp_bottom);
fprintf(fid, 'max temperature (degC): %s\n', data.widgetInfo.Temp_top);
fprintf(fid, '\n');
fprintf(fid, 'Processed by cloud_evaluation_GUI at %s\n', tNow);
progInfo = programInfo();
fprintf(fid, 'program name: %s\n', progInfo.Name);
fprintf(fid, 'program version: %s\n', progInfo.Version);
fprintf(fid, 'program author: %s\n', progInfo.Author);

fclose(fid);

end