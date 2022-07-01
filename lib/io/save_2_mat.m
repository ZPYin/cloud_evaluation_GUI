function save_2_mat(handles, saveFile)
% SAVE_2_MAT save cloud case data to MAT.
% Inputs:
%    handles: struct
%    saveFile: char
%        absolute path of the MAT file.
% History:
%    2020-07-06. First edition by Zhenping
% Contact:
%    zp.yin@whu.edu.cn

%% extract handles information
overviewInfo.lidarData = handles.lidarData;
overviewInfo.mTime = handles.mTime;
overviewInfo.height = handles.height;
overviewInfo.RCS = handles.RCS;
overviewInfo.VDR = handles.VDR;
overviewInfo.Temp = handles.Temp;
overviewInfo.RCS_Profi = handles.RCS_Profi;
overviewInfo.VDR_Profi = handles.VDR_Profi;
overviewInfo.mol_RCS_Profi = handles.mol_RCS_Profi;
overviewInfo.Temp_Profi = handles.Temp_Profi;
overviewInfo.CTT = handles.CTT;
overviewInfo.CBH = str2double(handles.cloud_base_tb.String);
overviewInfo.CTH = str2double(handles.cloud_top_tb.String);
overviewInfo.meteor_data = handles.meteor_data_pm.String{handles.meteor_data_pm.Value};
overviewInfo.RH_Profi = handles.RH_Profi;
overviewInfo.gainRatio = str2double(handles.gainRatio_tb.String);
overviewInfo.offset = str2double(handles.offset_tb.String);
overviewInfo.cloud_top_sig_2_bg = handles.cloud_top_sig_2_bg;
overviewInfo.cloud_phase = handles.cloud_phase_pm.String{handles.cloud_phase_pm.Value};
retrievalInfo.retLidarData = handles.retLidarData;
retrievalInfo.ret_height = handles.ret_height;
retrievalInfo.ret_RCS_Profi = handles.ret_RCS_Profi;
retrievalInfo.ret_mol_RCS_Profi = handles.ret_mol_RCS_Profi;
retrievalInfo.ret_bsc_Profi = handles.ret_bsc_Profi;
retrievalInfo.ret_bsc_std_Profi = handles.ret_bsc_std_Profi;
retrievalInfo.ret_bsc_d_Profi = handles.ret_bsc_d_Profi;
retrievalInfo.ret_bsc_d_std_Profi = handles.ret_bsc_d_std_Profi;
retrievalInfo.ret_bsc_nd_Profi = handles.ret_bsc_nd_Profi;
retrievalInfo.ret_bsc_nd_std_Profi = handles.ret_bsc_nd_std_Profi;
retrievalInfo.ret_VDR_Profi = handles.ret_VDR_Profi;
retrievalInfo.ret_VDR_std_Profi = handles.ret_VDR_std_Profi;
retrievalInfo.ret_PDR_Profi = handles.ret_PDR_Profi;
retrievalInfo.ret_PDR_std_Profi = handles.ret_PDR_std_Profi;
retrievalInfo.ret_mass_nd_Profi = handles.ret_mass_nd_Profi;
retrievalInfo.ret_mass_nd_std_Profi = handles.ret_mass_nd_std_Profi;
retrievalInfo.ret_mass_d_Profi = handles.ret_mass_d_Profi;
retrievalInfo.ret_mass_d_std_Profi = handles.ret_mass_d_std_Profi;
retrievalInfo.ret_Temp_Profi = handles.ret_Temp_Profi;
retrievalInfo.ret_Pres_Profi = handles.ret_Pres_Profi;
retrievalInfo.LBH = str2double(handles.LayerBase_tb.String);
retrievalInfo.LTH = str2double(handles.LayerTop_tb.String);
retrievalInfo.refH = [str2double(handles.ref_H_bottom_tb.String), str2double(handles.ref_H_top_tb.String)];
retrievalInfo.refValue = str2double(handles.ref_value_tb.String);
retrievalInfo.molDepol= str2double(handles.mol_depol_tb.String);
retrievalInfo.smooth_window = str2double(handles.smoothwin_tb.String);
retrievalInfo.wavelength = str2double(handles.wavelength_tb.String);
settings = handles.settings;
widgetInfo.settingFile = handles.setting_tb.String;
widgetInfo.infoFile = handles.infoFile_tb.String;
widgetInfo.starttime = handles.starttime_tb.String;
widgetInfo.stoptime = handles.stoptime_tb.String;
widgetInfo.H_base = handles.H_base_tb.String;
widgetInfo.H_top = handles.H_top_tb.String;
widgetInfo.cloud_base = handles.cloud_base_tb.String;
widgetInfo.cloud_top = handles.cloud_top_tb.String;
widgetInfo.cloud_start = handles.cloud_start_tb.String;
widgetInfo.cloud_stop = handles.cloud_stop_tb.String;
widgetInfo.meteor_data = handles.meteor_data_pm.String{handles.meteor_data_pm.Value};
widgetInfo.cloud_phase = handles.cloud_phase_pm.String{handles.cloud_phase_pm.Value};
widgetInfo.CTT = handles.CTT_tb.String;
widgetInfo.gainRatio = handles.gainRatio_tb.String;
widgetInfo.offset = handles.offset_tb.String;
widgetInfo.cloud_top_sig_2_bg = handles.cloud_top_signal_2_bg_tb.String;
widgetInfo.ret_starttime = handles.ret_starttime_tb.String;
widgetInfo.ret_stoptime = handles.ret_stoptime_tb.String;
widgetInfo.ret_H_bottom = handles.ret_H_bottom_tb.String;
widgetInfo.ret_H_top = handles.ret_H_top_tb.String;
widgetInfo.ref_H_bottom = handles.ref_H_bottom_tb.String;
widgetInfo.ref_H_top = handles.ref_H_top_tb.String;
widgetInfo.bsc_bottom = handles.bsc_bottom_tb.String;
widgetInfo.bsc_top = handles.bsc_top_tb.String;
widgetInfo.ref_value = handles.ref_value_tb.String;
widgetInfo.mass_bottom = handles.mass_bottom_tb.String;
widgetInfo.mass_top = handles.mass_top_tb.String;
widgetInfo.lr = handles.lr_tb.String;
widgetInfo.mol_depol = handles.mol_depol_tb.String;
widgetInfo.LayerBase = handles.LayerBase_tb.String;
widgetInfo.LayerTop = handles.LayerTop_tb.String;
widgetInfo.smoothwin = handles.smoothwin_tb.String;
widgetInfo.wavelength = handles.wavelength_tb.String;
widgetInfo.cmap = handles.cmap_pm.String{handles.cmap_pm.Value};
widgetInfo.RCS_scale = handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value};
widgetInfo.RCS_bottom = handles.RCS_bottom_tb.String;
widgetInfo.RCS_top = handles.RCS_top_tb.String;
widgetInfo.VDR_bottom = handles.VDR_bottom_tb.String;
widgetInfo.VDR_top = handles.VDR_top_tb.String;
widgetInfo.Temp_bottom = handles.Temp_bottom_tb.String;
widgetInfo.Temp_top = handles.Temp_top_tb.String;
metadata.history = sprintf('Processed by cloud_evaluation_GUI at %s', tNow);
progInfo = programInfo();
metadata.processor_version = progInfo.Version;
metadata.processor_name = progInfo.Name;
metadata.processor_author = progInfo.Author;

%% save the results
save(saveFile, 'overviewInfo', 'retrievalInfo', 'settings', 'metadata', 'widgetInfo', '-v6');

end