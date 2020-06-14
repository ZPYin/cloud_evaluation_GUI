function varargout = cloud_evaluation_GUI(varargin)
% CLOUD_EVALUATION_GUI MATLAB code for cloud_evaluation_GUI.fig
%      CLOUD_EVALUATION_GUI, by itself, creates a new CLOUD_EVALUATION_GUI or raises the existing
%      singleton*.
%
%      H = CLOUD_EVALUATION_GUI returns the handle to a new CLOUD_EVALUATION_GUI or the handle to
%      the existing singleton*.
%
%      CLOUD_EVALUATION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLOUD_EVALUATION_GUI.M with the given input arguments.
%
%      CLOUD_EVALUATION_GUI('Property','Value',...) creates a new CLOUD_EVALUATION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cloud_evaluation_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cloud_evaluation_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cloud_evaluation_GUI

% Last Modified by GUIDE v2.5 14-Jun-2020 17:58:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cloud_evaluation_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @cloud_evaluation_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before cloud_evaluation_GUI is made visible.
function cloud_evaluation_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cloud_evaluation_GUI (see VARARGIN)

% add search path
projectDir = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(genpath(fullfile(projectDir, 'lib')));
addpath(genpath(fullfile(projectDir, 'include')));

% load settings
settingFile = fullfile(projectDir, 'config', 'settings.yml');
settings = yaml.ReadYaml(settingFile);
handles.settings = settings;
handles.setting_tb.String = settingFile;
handles.log_tb.String{end + 1} = sprintf('[%s] load settings successfully!', tNow());

% Choose default command line output for cloud_evaluation_GUI
handles.output = hObject;
handles.lidarData = struct();
handles.mTime = linspace(datenum(2010, 1, 1, 0, 0, 0), datenum(2010, 1, 1, 1, 0, 0), 100);
handles.height = linspace(0, 10000, 100);
handles.RCS = NaN(100, 100);
handles.VDR = NaN(100, 100);
handles.Temp = NaN(100, 100);
handles.RCS_Profi = NaN(1, 100);
handles.VDR_Profi = NaN(1, 100);
handles.mol_RCS_Profi = NaN(1, 100);
handles.Temp_Profi = NaN(1, 100);
handles.CTT = NaN;
handles.RH_Profi = NaN(1, 100);
handles.retLidarData = struct();
handles.ret_height = NaN(1, 100);
handles.ret_RCS_Profi = NaN(1, 100);
handles.ret_mol_RCS_Profi = NaN(1, 100);
handles.ret_bsc_Profi = NaN(1, 100);
handles.ret_VDR_Profi = NaN(1, 100);
handles.ret_PDR_Profi = NaN(1, 100);
handles.ret_mass_nd_Profi = NaN(1, 100);
handles.ret_mass_d_Profi = NaN(1, 100);
handles.projectDir = projectDir;
handles.log_tb.String = {'Enjoy the day'};

%% initialize the figures
% RCS colorplot
display_RCS_colorplot(handles.RCS_colorplot_axes, handles.mTime, handles.height, handles.RCS, 'scale', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value}, 'tRange', [datenum(handles.starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], 'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], 'cRange', [str2double(handles.RCS_bottom_tb.String), str2double(handles.RCS_top_tb.String)], 'Temp', handles.Temp);

% VDR colorplot
display_VDR_colorplot(handles.VDR_colorplot_axes, handles.mTime, handles.height, handles.VDR, 'tRange', [datenum(handles.starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], 'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], 'cRange', [str2double(handles.VDR_bottom_tb.String), str2double(handles.VDR_top_tb.String)], 'Temp', handles.Temp);

% RCS profile
display_RCS_profi(handles.RCS_lineplot_axes, handles.height, handles.RCS_Profi, handles.mol_RCS_Profi, 'scale', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value}, 'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], 'RCSRange', [str2double(handles.RCS_bottom_tb.String), str2double(handles.RCS_top_tb.String)]);

% RH profile
display_RH_profi(handles.RH_lineplot_axes, handles.height, handles.RH_Profi, 'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], 'RHRange', [0, 100]);

% VDR profile
display_VDR_profi(handles.VDR_lineplot_axes, handles.height, handles.VDR_Profi, str2double(handles.mol_depol_tb.String) .* ones(size(handles.height)), 'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], 'VDRRange', [str2double(handles.VDR_bottom_tb.String), str2double(handles.VDR_top_tb.String)]);

% Temp profile
display_Temp_profi(handles.Temp_lineplot_axes, handles.height, handles.Temp_Profi, 'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], 'TempRange', [str2double(handles.Temp_bottom_tb.String), str2double(handles.Temp_top_tb.String)]);

% sig profile
display_sig_profi(handles.ret_sig_lineplot_axes, handles.ret_height, handles.ret_RCS_Profi, handles.ret_mol_RCS_Profi, 'scale', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value}, 'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], 'RCSRange', [str2double(handles.RCS_bottom_tb.String), str2double(handles.RCS_top_tb.String)]);

% bsc profile
display_bsc_profi(handles.ret_bsc_lineplot_axes, handles.ret_height, handles.ret_bsc_Profi, 'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], 'aerBscRange', [str2double(handles.bsc_bottom_tb.String), str2double(handles.bsc_top_tb.String)]);

% depol profile
display_depol_profi(handles.ret_depol_lineplot_axes, handles.ret_height, handles.ret_VDR_Profi, handles.ret_PDR_Profi, 'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], 'DepolRange', [str2double(handles.VDR_bottom_tb.String), str2double(handles.VDR_top_tb.String)]);

% mass profile
display_mass_profi(handles.ret_mass_lineplot_axes, handles.ret_height, handles.ret_mass_nd_Profi, handles.ret_mass_d_Profi, 'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], 'massRange', [str2double(handles.mass_bottom_tb.String), str2double(handles.mass_top_tb.String)]);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cloud_evaluation_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = cloud_evaluation_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in setting_btn.
function setting_btn_Callback(hObject, eventdata, handles)
% hObject    handle to setting_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[settingFile, settingPath] = uigetfile(fullfile(handles.projectDir, 'config', '*.yml'), 'Select the settings file...');
handles.settingFile = fullfile(settingPath, settingFile);

if settingFile == 0
    % invalid setting file
    handles.setting_tb.String = '';
else
    handles.setting_tb.String = sprintf('%s', fullfile(settingPath, settingFile));

    % read settings
    settings = yaml.ReadYaml(fullfile(settingPath, settingFile));
    handles.settings = settings;

    handles.log_tb.String{end + 1} = sprintf('[%s] load settings successfully!', tNow());

    % validate settings
    if ~ exist(settings.dataDir, 'dir')
        logPrint(handles.log_tb, sprintf('dataDir does not exist'));
    end

end

guidata(hObject, handles);



function setting_tb_Callback(hObject, eventdata, handles)
% hObject    handle to setting_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of setting_tb as text
%        str2double(get(hObject,'String')) returns contents of setting_tb as a double


% --- Executes during object creation, after setting all properties.
function setting_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setting_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in infoFile_btn.
function infoFile_btn_Callback(hObject, eventdata, handles)
% hObject    handle to infoFile_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[infoFile, infoPath] = uigetfile(fullfile(handles.settings.saveDir, '*.mat'), 'Select info file...');
handles.infoFile = fullfile(infoPath, infoFile);

if infoFile == 0
    % invalid info file
    handles.infoFile_tb.String = '';
else
    handles.infoFile_tb.String = sprintf('%s', fullfile(infoPath, infoFile));

    % read infos
    load(handles.infoFile);

    %% update status
     handles.setting_tb.String = widgetInfo.settingFile;
     handles.infoFile_tb.String = widgetInfo.infoFile;
     handles.starttime_tb.String = widgetInfo.starttime;
     handles.stoptime_tb.String = widgetInfo.stoptime;
     handles.H_base_tb.String = widgetInfo.H_base;
     handles.H_top_tb.String = widgetInfo.H_top;
     handles.cloud_start_tb.String = widgetInfo.cloud_start;
     handles.cloud_stop_tb.String = widgetInfo.cloud_stop;
     handles.cloud_base_tb.String = widgetInfo.cloud_base;
     handles.cloud_top_tb.String = widgetInfo.cloud_top;
     handles.meteor_data_pm.Value = find(strcmpi(handles.meteor_data_pm.String, widgetInfo.meteor_data));
     handles.cloud_phase_pm.Value = find(strcmpi(handles.cloud_phase_pm.String, widgetInfo.cloud_phase));
     handles.CTT_tb.String = widgetInfo.CTT;
     handles.gainRatio_tb.String = widgetInfo.gainRatio;
     handles.cloud_top_signal_2_bg_tb.String = widgetInfo.cloud_top_sig_2_bg;
     handles.ret_starttime_tb.String = widgetInfo.ret_starttime;
     handles.ret_stoptime_tb.String = widgetInfo.ret_stoptime;
     handles.ret_H_bottom_tb.String = widgetInfo.ret_H_bottom;
     handles.ret_H_top_tb.String = widgetInfo.ret_H_top;
     handles.ref_H_bottom_tb.String = widgetInfo.ref_H_bottom;
     handles.ref_H_top_tb.String = widgetInfo.ref_H_top;
     handles.bsc_bottom_tb.String = widgetInfo.bsc_bottom;
     handles.bsc_top_tb.String = widgetInfo.bsc_top;
     handles.ref_value_tb.String = widgetInfo.ref_value;
     handles.mass_bottom_tb.String = widgetInfo.mass_bottom;
     handles.mass_top_tb.String = widgetInfo.mass_top;
     handles.lr_tb.String = widgetInfo.lr;
     handles.mol_depol_tb.String = widgetInfo.mol_depol;
     handles.LayerBase_tb.String = widgetInfo.LayerBase;
     handles.LayerTop_tb.String = widgetInfo.LayerTop;
     handles.smoothwin_tb.String = widgetInfo.smoothwin;
     handles.RCS_scale_pm.Value = find(strcmpi(handles.RCS_scale_pm.String, widgetInfo.RCS_scale));
     handles.RCS_bottom_tb.String = widgetInfo.RCS_bottom;
     handles.RCS_top_tb.String = widgetInfo.RCS_top;
     handles.VDR_bottom_tb.String = widgetInfo.VDR_bottom;
     handles.VDR_top_tb.String = widgetInfo.VDR_top;
     handles.Temp_bottom_tb.String = widgetInfo.Temp_bottom;
     handles.Temp_top_tb.String = widgetInfo.Temp_top;

    handles.log_tb.String{end + 1} = sprintf('[%s] load info file successfully!', tNow());
end

handles.infoFile_tb.String = handles.infoFile;

guidata(hObject, handles);



function infoFile_tb_Callback(hObject, eventdata, handles)
% hObject    handle to infoFile_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of infoFile_tb as text
%        str2double(get(hObject,'String')) returns contents of infoFile_tb as a double


% --- Executes during object creation, after setting all properties.
function infoFile_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to infoFile_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function starttime_tb_Callback(hObject, eventdata, handles)
% hObject    handle to starttime_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of starttime_tb as text
%        str2double(get(hObject,'String')) returns contents of starttime_tb as a double


% --- Executes during object creation, after setting all properties.
function starttime_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to starttime_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function stoptime_tb_Callback(hObject, eventdata, handles)
% hObject    handle to stoptime_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stoptime_tb as text
%        str2double(get(hObject,'String')) returns contents of stoptime_tb as a double


% --- Executes during object creation, after setting all properties.
function stoptime_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stoptime_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function H_base_tb_Callback(hObject, eventdata, handles)
% hObject    handle to H_base_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of H_base_tb as text
%        str2double(get(hObject,'String')) returns contents of H_base_tb as a double


% --- Executes during object creation, after setting all properties.
function H_base_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to H_base_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function H_top_tb_Callback(hObject, eventdata, handles)
% hObject    handle to H_top_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of H_top_tb as text
%        str2double(get(hObject,'String')) returns contents of H_top_tb as a double


% --- Executes during object creation, after setting all properties.
function H_top_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to H_top_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function cloud_base_tb_Callback(hObject, eventdata, handles)
% hObject    handle to cloud_base_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cloud_base_tb as text
%        str2double(get(hObject,'String')) returns contents of cloud_base_tb as a double


% --- Executes during object creation, after setting all properties.
function cloud_base_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cloud_base_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function cloud_top_tb_Callback(hObject, eventdata, handles)
% hObject    handle to cloud_top_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cloud_top_tb as text
%        str2double(get(hObject,'String')) returns contents of cloud_top_tb as a double


% --- Executes during object creation, after setting all properties.
function cloud_top_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cloud_top_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function meteor_data_pm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to meteor_data_pm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in overview_plot_btn.
function overview_plot_btn_Callback(hObject, eventdata, handles)
% hObject    handle to overview_plot_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~ exist(handles.settings.dataDir, 'dir')
    handles.log_tb.String{end + 1} = sprintf('[%s] Lidar data does not exist: %s', tNow, handles.setting_tb.String);
    scrollDownLogBox(handles.log_tb);
end

% read lidar data
lidarData = PLidar_readdata(handles.settings.dataDir, [datenum(handles.starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], [str2double(handles.H_base_tb.String) * 1000, str2double(handles.H_top_tb.String) * 1000], handles.settings.data_version);

if isempty(lidarData.time)
    handles.log_tb.String{end + 1} = sprintf('[%s] No lidar data available.', tNow());
    scrollDownLogBox(handles.log_tb);
    return;
end

% read meteorological data
[Temp_Profi, Pres_Profi, RH_Profi] = read_meteordata(mean([datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS')]) - datenum(0, 1, 0, 8, 0, 0), lidarData.altitude, 'meteor_data', handles.meteor_data_pm.String{handles.meteor_data_pm.Value}, 'station', 'wuhan', 'GDAS1Folder', handles.settings.GDAS1Dir, 'RadiosondeFolder', handles.settings.soundingDir, 'ERA5Folder', handles.settings.ERA5Dir);
Temp_2D = read_gridTemp(lidarData.time - datenum(0, 1, 0, 8, 0, 0), lidarData.altitude, 'meteor_data', handles.meteor_data_pm.String{handles.meteor_data_pm.Value}, 'station', 'wuhan', 'GDAS1Folder', handles.settings.GDAS1Dir, 'RadiosondeFolder', handles.settings.soundingDir, 'ERA5Folder', handles.settings.ERA5Dir);

%% Rayleigh scattering
[molExt532, molBsc532] = rayleigh_scattering(532, Pres_Profi, Temp_Profi + 273.14, 360, 80);
molRCS = molBsc532 .* exp(-2 .* nancumsum([lidarData.height(1), diff(lidarData.height)] .* molExt532));

flagClH = (lidarData.height >= str2double(handles.cloud_base_tb.String) * 1000) & (lidarData.height <= str2double(handles.cloud_top_tb.String) * 1000);
%% update data in handles
handles.lidarData = lidarData;
handles.mTime = lidarData.time;
handles.height = lidarData.height / 1e3;
elSig = (lidarData.CH1_PC + str2double(handles.gainRatio_tb.String) .* lidarData.CH2_PC);
elBG = (lidarData.CH1_BG + str2double(handles.gainRatio_tb.String) .* lidarData.CH2_BG);
flagCloud = (lidarData.time >= datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS')) & (lidarData.time <= datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS'));
handles.RCS = elSig .* repmat(lidarData.height', 1, length(lidarData.time)).^2;
handles.VDR = str2double(handles.gainRatio_tb.String) .* lidarData.CH2_PC ./ lidarData.CH1_PC;
handles.Temp = Temp_2D;
handles.RCS_Profi = transpose(nanmean(elSig(:, flagCloud), 2)) .* lidarData.height .^ 2;
handles.VDR_Profi = transpose(nanmean(lidarData.CH2_PC(:, flagCloud), 2) ./ nanmean(lidarData.CH1_PC(:, flagCloud), 2)) .* str2double(handles.gainRatio_tb.String);
handles.mol_RCS_Profi = molRCS .* (nanmean(handles.RCS_Profi(flagClH)) ./ nanmean(molRCS(flagClH)));
handles.Temp_Profi = Temp_Profi;
handles.CTT = Temp_Profi(find(lidarData.height >= str2double(handles.cloud_top_tb.String) * 1000, 1));
handles.RH_Profi = RH_Profi;

cloudTopLayerIndx = (lidarData.height >= str2double(handles.cloud_top_tb.String) * 1000) & (lidarData.height <= str2double(handles.cloud_top_tb.String) * 1000 + 500);
handles.cloud_top_sig_2_bg = nanmean(nanmean(elSig(cloudTopLayerIndx, :), 1), 2) ./ nanmean(elBG);

%% update plots
% RCS colorplot
display_RCS_colorplot(handles.RCS_colorplot_axes, handles.mTime, handles.height, handles.RCS, 'scale', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value}, 'tRange', [datenum(handles.starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], 'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], 'cRange', [str2double(handles.RCS_bottom_tb.String), str2double(handles.RCS_top_tb.String)], 'Temp', handles.Temp, 'CBH', str2double(handles.cloud_base_tb.String), 'CTH', str2double(handles.cloud_top_tb.String), 'CTT', handles.CTT, 'cloud_starttime', datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS'), 'cloud_stoptime', datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS'), 'ret_bottom', str2double(handles.ret_H_bottom_tb.String), 'ret_top', str2double(handles.ret_H_top_tb.String), 'ret_starttime', datenum(handles.ret_starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), 'ret_stoptime', datenum(handles.ret_stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS'));

% VDR colorplot
display_VDR_colorplot(handles.VDR_colorplot_axes, handles.mTime, handles.height, handles.VDR, 'tRange', [datenum(handles.starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], 'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], 'cRange', [str2double(handles.VDR_bottom_tb.String), str2double(handles.VDR_top_tb.String)], 'Temp', handles.Temp, 'CBH', str2double(handles.cloud_base_tb.String), 'CTH', str2double(handles.cloud_top_tb.String), 'CTT', handles.CTT, 'cloud_starttime', datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS'), 'cloud_stoptime', datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS'), 'ret_bottom', str2double(handles.ret_H_bottom_tb.String), 'ret_top', str2double(handles.ret_H_top_tb.String), 'ret_starttime', datenum(handles.ret_starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), 'ret_stoptime', datenum(handles.ret_stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS'));

% RCS profile
display_RCS_profi(handles.RCS_lineplot_axes, handles.height, handles.RCS_Profi, handles.mol_RCS_Profi, 'scale', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value}, 'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], 'RCSRange', [str2double(handles.RCS_bottom_tb.String), str2double(handles.RCS_top_tb.String)], 'CBH', str2double(handles.cloud_base_tb.String), 'CTH', str2double(handles.cloud_top_tb.String), 'CTT', handles.CTT);

% RH profile
display_RH_profi(handles.RH_lineplot_axes, handles.height, handles.RH_Profi, 'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], 'RHRange', [0, 100], 'CBH', str2double(handles.cloud_base_tb.String), 'CTH', str2double(handles.cloud_top_tb.String), 'CTT', handles.CTT);

% VDR profile
display_VDR_profi(handles.VDR_lineplot_axes, handles.height, handles.VDR_Profi, str2double(handles.mol_depol_tb.String) .* ones(size(handles.height)), 'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], 'VDRRange', [str2double(handles.VDR_bottom_tb.String), str2double(handles.VDR_top_tb.String)], 'CBH', str2double(handles.cloud_base_tb.String), 'CTH', str2double(handles.cloud_top_tb.String), 'CTT', handles.CTT);

% Temp profile
display_Temp_profi(handles.Temp_lineplot_axes, handles.height, handles.Temp_Profi, 'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], 'TempRange', [str2double(handles.Temp_bottom_tb.String), str2double(handles.Temp_top_tb.String)], 'CBH', str2double(handles.cloud_base_tb.String), 'CTH', str2double(handles.cloud_top_tb.String), 'CTT', handles.CTT);

%% update status bar
handles.CTT_tb.String = sprintf('%5.1f', handles.CTT);
handles.cloud_top_signal_2_bg_tb.String = sprintf('%6.2f', handles.cloud_top_sig_2_bg);

% Update handles structure
guidata(hObject, handles);

% --- Executes on selection change in RCS_scale_pm.
function RCS_scale_pm_Callback(hObject, eventdata, handles)
% hObject    handle to RCS_scale_pm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns RCS_scale_pm contents as cell array
%        contents{get(hObject,'Value')} returns selected item from RCS_scale_pm


% --- Executes during object creation, after setting all properties.
function RCS_scale_pm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RCS_scale_pm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_btn.
function save_btn_Callback(hObject, eventdata, handles)
% hObject    handle to save_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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
retrievalInfo.LBH = str2double(handles.LayerBase_tb.String);
retrievalInfo.LTH = str2double(handles.LayerTop_tb.String);
retrievalInfo.refH = [str2double(handles.ref_H_bottom_tb.String), str2double(handles.ref_H_top_tb.String)];
retrievalInfo.refValue = str2double(handles.ref_value_tb.String);
retrievalInfo.molDepol= str2double(handles.mol_depol_tb.String);
retrievalInfo.smooth_window = str2double(handles.smoothwin_tb.String);
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
cloud_starttime = datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS');
cloud_stoptime = datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS');
saveFile = fullfile(handles.settings.saveDir, sprintf('cloud_eval_output_%s-%s_%05d-%05d_sm%04d.mat', datestr(cloud_starttime, 'yyyymmdd_HHMM'), datestr(cloud_stoptime, 'yyyymmdd_HHMM'), int32(overviewInfo.CBH * 1000), int32(overviewInfo.CTH * 1000), retrievalInfo.smooth_window));
save(saveFile, 'overviewInfo', 'retrievalInfo', 'settings', 'metadata', 'widgetInfo', '-v6');

%% update status
handles.log_tb.String{end + 1} = sprintf('[%s] Results have been saved to %s', tNow, saveFile);
scrollDownLogBox(handles.log_tb);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in export_fig_btn.
function export_fig_btn_Callback(hObject, eventdata, handles)
% hObject    handle to export_fig_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cloud_starttime = datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS');
cloud_stoptime = datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS');
saveFile = fullfile(handles.settings.saveDir, sprintf('cloud_eval_output_%s-%s_%05d-%05d_sm%s.png', datestr(cloud_starttime, 'yyyymmdd_HHMM'), datestr(cloud_stoptime, 'yyyymmdd_HHMM'), int32(str2double(handles.cloud_base_tb.String) * 1000), int32(str2double(handles.cloud_top_tb.String) * 1000), handles.smoothwin_tb.String));
export_fig(gcf, saveFile, '-r300');

%% update status
handles.log_tb.String{end + 1} = sprintf('[%s] Snapshot of the figure have been saved to %s', tNow, saveFile);
scrollDownLogBox(handles.log_tb);

% Update handles structure
guidata(hObject, handles);


function log_tb_Callback(hObject, eventdata, handles)
% hObject    handle to log_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of log_tb as text
%        str2double(get(hObject,'String')) returns contents of log_tb as a double


% --- Executes during object creation, after setting all properties.
function log_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to log_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ret_starttime_tb_Callback(hObject, eventdata, handles)
% hObject    handle to ret_starttime_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ret_starttime_tb as text
%        str2double(get(hObject,'String')) returns contents of ret_starttime_tb as a double


% --- Executes during object creation, after setting all properties.
function ret_starttime_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ret_starttime_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ret_stoptime_tb_Callback(hObject, eventdata, handles)
% hObject    handle to ret_stoptime_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ret_stoptime_tb as text
%        str2double(get(hObject,'String')) returns contents of ret_stoptime_tb as a double


% --- Executes during object creation, after setting all properties.
function ret_stoptime_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ret_stoptime_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ref_H_top_tb_Callback(hObject, eventdata, handles)
% hObject    handle to ref_H_top_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ref_H_top_tb as text
%        str2double(get(hObject,'String')) returns contents of ref_H_top_tb as a double


% --- Executes during object creation, after setting all properties.

% hObject    handle to ref_H_top_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ref_value_tb_Callback(hObject, eventdata, handles)
% hObject    handle to ref_value_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ref_value_tb as text
%        str2double(get(hObject,'String')) returns contents of ref_value_tb as a double


% --- Executes during object creation, after setting all properties.
function ref_value_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ref_value_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lr_tb_Callback(hObject, eventdata, handles)
% hObject    handle to lr_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lr_tb as text
%        str2double(get(hObject,'String')) returns contents of lr_tb as a double


% --- Executes during object creation, after setting all properties.
function lr_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lr_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mol_depol_tb_Callback(hObject, eventdata, handles)
% hObject    handle to mol_depol_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mol_depol_tb as text
%        str2double(get(hObject,'String')) returns contents of mol_depol_tb as a double


% --- Executes during object creation, after setting all properties.
function mol_depol_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mol_depol_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function LayerTop_tb_Callback(hObject, eventdata, handles)
% hObject    handle to LayerTop_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LayerTop_tb as text
%        str2double(get(hObject,'String')) returns contents of LayerTop_tb as a double


% --- Executes during object creation, after setting all properties.
function LayerTop_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LayerTop_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function LayerBase_tb_Callback(hObject, eventdata, handles)
% hObject    handle to LayerBase_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LayerBase_tb as text
%        str2double(get(hObject,'String')) returns contents of LayerBase_tb as a double


% --- Executes during object creation, after setting all properties.
function LayerBase_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LayerBase_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ret_plot_btn.
function ret_plot_btn_Callback(hObject, eventdata, handles)
% hObject    handle to ret_plot_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% read lidar data
lidarData = PLidar_readdata(handles.settings.dataDir, [datenum(handles.ret_starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.ret_stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], [str2double(handles.ret_H_bottom_tb.String) * 1000, str2double(handles.ret_H_top_tb.String) * 1000], handles.settings.data_version);

if isempty(lidarData.time)
    handles.log_tb.String{end + 1} = sprintf('[%s] No lidar data available.', tNow());
    scrollDownLogBox(handles.log_tb);
    return;
end

% read meteorological data
[ret_Temp_Profi, ret_Pres_Profi, ~] = read_meteordata(mean([datenum(handles.ret_starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.ret_stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')]) - datenum(0, 1, 0, 8, 0, 0), lidarData.altitude, 'meteor_data', handles.meteor_data_pm.String{handles.meteor_data_pm.Value}, 'station', 'wuhan', 'GDAS1Folder', handles.settings.GDAS1Dir, 'RadiosondeFolder', handles.settings.soundingDir, 'ERA5Folder', handles.settings.ERA5Dir);

%% Rayleigh scattering
[molBsc532, molExt532] = rayleigh_scattering(532, ret_Pres_Profi, ret_Temp_Profi + 273.14, 360, 80);
molRCS = molBsc532 .* exp(-2 .* nancumsum([lidarData.height(1), diff(lidarData.height)] .* molExt532));

if isempty(lidarData.height)
    handles.log_tb.String{end + 1} = sprintf('[%s] no data for aerosol retrievals were found!', tNow);
    scrollDownLogBox(handles.log_tb);
    return;
end

%% aerosol retrievals
elSig = (lidarData.CH1_PC + str2double(handles.gainRatio_tb.String) .* lidarData.CH2_PC);
elBG = (lidarData.CH1_BG + str2double(handles.gainRatio_tb.String) .* lidarData.CH2_BG);
sm_win_bins = floor(str2double(handles.smoothwin_tb.String) ./ (lidarData.height(2) - lidarData.height(1)));
if sm_win_bins <= 0
    handles.log_tb.String{end + 1} = sprintf('[%s] not enough data bins.', tNow);
    scrollDownLogBox(handles.log_tb);
end
records = transpose(lidarData.records);
records(records <= 1e-3) = NaN;
PCR2PC = 1000 ./ nansum(records) .* 200;
CH1_PC = transpose(nansum(lidarData.CH1_PC, 2)) .* PCR2PC;
CH2_PC = transpose(nansum(lidarData.CH2_PC, 2)) .* PCR2PC;
CH1_BG = nansum(lidarData.CH1_BG) .* PCR2PC;
CH2_BG = nansum(lidarData.CH2_BG) .* PCR2PC;
elSigPC = transpose(nansum(elSig, 2)) .* PCR2PC;
elBGPC = nansum(elBG) .* PCR2PC;
ret_RCS_Profi = transpose(smooth(transpose(nanmean(elSig, 2)) .* lidarData.height .^ 2, sm_win_bins));

if str2double(handles.ref_H_top_tb.String) >= str2double(handles.ret_H_top_tb.String)
    handles.log_tb.String{end + 1} = sprintf('[%s] reference top is out of range.', tNow);
    scrollDownLogBox(handles.log_tb);

    return;
end

% backscatter
[ret_bsc_Profi, ret_bsc_std_Profi] = PLidar_Fernald(lidarData.height, elSigPC, elBGPC, str2double(handles.lr_tb.String), [str2double(handles.ref_H_bottom_tb.String), str2double(handles.ref_H_top_tb.String)] .* 1000, str2double(handles.ref_value_tb.String) * 1e-6, molBsc532, sm_win_bins);

% depol
ret_VDR_Profi = transpose(smooth(CH2_PC, sm_win_bins) ./ smooth(CH1_PC, sm_win_bins)) .* str2double(handles.gainRatio_tb.String);
ret_VDR_std_Profi = ret_VDR_Profi .* sqrt( 1 ./ PLidar_SNR(CH1_PC, CH1_BG).^2 + 1 ./ PLidar_SNR(CH2_PC, CH2_BG).^2) ./ sqrt(sm_win_bins);
[ret_PDR_Profi, ret_PDR_std_Profi] = PLidar_parDepol(ret_VDR_Profi, ret_VDR_std_Profi, ret_bsc_Profi, ret_bsc_std_Profi, molBsc532, str2double(handles.mol_depol_tb.String), 0);

% dust and nondust
[dustInfo, nondustInfo] = poliphon_1step(ret_bsc_Profi, ret_bsc_std_Profi, ret_PDR_Profi, ret_PDR_std_Profi, 45);
ret_bsc_d_Profi = dustInfo.parBsc;
ret_bsc_d_std_Profi = dustInfo.parBscStd;
ret_mass_d_Profi = dustInfo.massConc;
ret_mass_d_std_Profi = dustInfo.massConcStd;
ret_bsc_nd_Profi = nondustInfo.parBsc;
ret_bsc_nd_std_Profi = nondustInfo.parBscStd;
ret_mass_nd_Profi = nondustInfo.massConc;
ret_mass_nd_std_Profi = nondustInfo.massConcStd;

flagRefH = (lidarData.height <= str2double(handles.ref_H_top_tb.String) * 1000) & (lidarData.height >= str2double(handles.ref_H_bottom_tb.String) * 1000);

%% update data in handles
handles.retLidarData = lidarData;
handles.retMTime = lidarData.time;
handles.ret_height = lidarData.height / 1e3;
handles.ret_Temp_Profi = ret_Temp_Profi;
handles.ret_RCS_Profi = ret_RCS_Profi;
handles.ret_mol_RCS_Profi = molRCS .* nanmean(ret_RCS_Profi(flagRefH)) ./ nanmean(molRCS(flagRefH));
handles.ret_bsc_Profi = ret_bsc_Profi;
handles.ret_bsc_std_Profi = ret_bsc_std_Profi;
handles.ret_bsc_d_Profi = ret_bsc_d_Profi;
handles.ret_bsc_d_std_Profi = ret_bsc_d_std_Profi;
handles.ret_bsc_nd_Profi = ret_bsc_nd_Profi;
handles.ret_bsc_nd_std_Profi = ret_bsc_nd_std_Profi;
handles.ret_VDR_Profi = ret_VDR_Profi;
handles.ret_VDR_std_Profi = ret_VDR_std_Profi;
handles.ret_PDR_Profi = ret_PDR_Profi;
handles.ret_PDR_std_Profi = ret_PDR_std_Profi;
handles.ret_mass_d_Profi = ret_mass_d_Profi;
handles.ret_mass_d_std_Profi = ret_mass_d_std_Profi;
handles.ret_mass_nd_Profi = ret_mass_nd_Profi;
handles.ret_mass_nd_std_Profi = ret_mass_nd_std_Profi;

%% update plots
% RCS colorplot
display_RCS_colorplot(handles.RCS_colorplot_axes, handles.mTime, handles.height, handles.RCS, 'scale', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value}, 'tRange', [datenum(handles.starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], 'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], 'cRange', [str2double(handles.RCS_bottom_tb.String), str2double(handles.RCS_top_tb.String)], 'Temp', handles.Temp, 'CBH', str2double(handles.cloud_base_tb.String), 'CTH', str2double(handles.cloud_top_tb.String), 'CTT', handles.CTT, 'cloud_starttime', datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS'), 'cloud_stoptime', datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS'), 'ret_bottom', str2double(handles.ret_H_bottom_tb.String), 'ret_top', str2double(handles.ret_H_top_tb.String), 'ret_starttime', datenum(handles.ret_starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), 'ret_stoptime', datenum(handles.ret_stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS'));

% VDR colorplot
display_VDR_colorplot(handles.VDR_colorplot_axes, handles.mTime, handles.height, handles.VDR, 'tRange', [datenum(handles.starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], 'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], 'cRange', [str2double(handles.VDR_bottom_tb.String), str2double(handles.VDR_top_tb.String)], 'Temp', handles.Temp, 'CBH', str2double(handles.cloud_base_tb.String), 'CTH', str2double(handles.cloud_top_tb.String), 'CTT', handles.CTT, 'cloud_starttime', datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS'), 'cloud_stoptime', datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS'), 'ret_bottom', str2double(handles.ret_H_bottom_tb.String), 'ret_top', str2double(handles.ret_H_top_tb.String), 'ret_starttime', datenum(handles.ret_starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), 'ret_stoptime', datenum(handles.ret_stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS'));

% sig profile
display_sig_profi(handles.ret_sig_lineplot_axes, handles.ret_height, handles.ret_RCS_Profi, handles.ret_mol_RCS_Profi, 'scale', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value}, 'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], 'RCSRange', [str2double(handles.RCS_bottom_tb.String), str2double(handles.RCS_top_tb.String)], 'caliRange', [str2double(handles.ref_H_bottom_tb.String), str2double(handles.ref_H_top_tb.String)]);

% bsc profile
display_bsc_profi(handles.ret_bsc_lineplot_axes, handles.ret_height, handles.ret_bsc_Profi * 1e6, 'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], 'aerBscRange', [str2double(handles.bsc_bottom_tb.String), str2double(handles.bsc_top_tb.String)], 'LBH', str2double(handles.LayerBase_tb.String), 'LTH', str2double(handles.LayerTop_tb.String), 'dustBsc', handles.ret_bsc_d_Profi * 1e6, 'nondustBsc', handles.ret_bsc_nd_Profi * 1e6);

% depol profile
display_depol_profi(handles.ret_depol_lineplot_axes, handles.ret_height, handles.ret_VDR_Profi, handles.ret_PDR_Profi, 'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], 'DepolRange', [str2double(handles.VDR_bottom_tb.String), str2double(handles.VDR_top_tb.String)], 'LBH', str2double(handles.LayerBase_tb.String), 'LTH', str2double(handles.LayerTop_tb.String));

% mass profile
display_mass_profi(handles.ret_mass_lineplot_axes, handles.ret_height, handles.ret_mass_nd_Profi * 1e9, handles.ret_mass_d_Profi * 1e9, 'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], 'massRange', [str2double(handles.mass_bottom_tb.String), str2double(handles.mass_top_tb.String)], 'LBH', str2double(handles.LayerBase_tb.String), 'LTH', str2double(handles.LayerTop_tb.String));

%% update status bar
flagLayer = (lidarData.height >= str2double(handles.LayerBase_tb.String) * 1000) & (lidarData.height <= str2double(handles.LayerTop_tb.String) * 1000);
massDustTot = nansum(handles.ret_mass_d_Profi(flagLayer) .* (lidarData.height(2) - lidarData.height(1))) * 1e9;
massDustTotStd = sqrt(nansum((handles.ret_mass_d_std_Profi(flagLayer) .* (lidarData.height(2) - lidarData.height(1))).^2)) * 1e9;
massNonDustTot = nansum(handles.ret_mass_nd_Profi(flagLayer) .* (lidarData.height(2) - lidarData.height(1))) * 1e9;
massNonDustTotStd = sqrt(nansum((handles.ret_mass_nd_std_Profi(flagLayer) .* (lidarData.height(2) - lidarData.height(1))).^2)) * 1e9;

flagRefH = (lidarData.height >= str2double(handles.ref_H_bottom_tb.String) * 1000) & (lidarData.height <= str2double(handles.ref_H_top_tb.String) * 1000);
molDepol_meas = str2double(handles.gainRatio_tb.String) .* nansum(CH2_PC(flagRefH)) ./ nansum(CH1_PC(flagRefH));
molDepol_std_meas =  molDepol_meas .* sqrt( 1 ./ PLidar_SNR(nansum(CH1_PC(flagRefH)), sum(flagRefH) * CH1_BG).^2 + 1 ./ PLidar_SNR(nansum(CH2_PC(flagRefH)), sum(flagRefH) * CH2_BG).^2);

handles.log_tb.String{end + 1} = sprintf('Estimated mol depol: %6.4f+-%6.4f', molDepol_meas, molDepol_std_meas);
handles.log_tb.String{end + 1} = sprintf('Layer dust conc.    : %6.1f+-%6.1f ug*m-2', massDustTot, massDustTotStd);
handles.log_tb.String{end + 1} = sprintf('Layer non-dust conc.: %6.1f+-%6.1f ug*m-2', massNonDustTot, massNonDustTotStd);
scrollDownLogBox(handles.log_tb);

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function show_about_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to show_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

progInfo = programInfo();
h = msgbox({sprintf('Authors: %s', progInfo.Author), sprintf('Version: %s', progInfo.Version), sprintf('%s', progInfo.Description)}, 'About');

% --- Executes on key press with focus on setting_btn and none of its controls.
function setting_btn_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to setting_btn (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in cloud_phase_pm.
function cloud_phase_pm_Callback(hObject, eventdata, handles)
% hObject    handle to cloud_phase_pm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cloud_phase_pm contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cloud_phase_pm


% --- Executes during object creation, after setting all properties.
function cloud_phase_pm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cloud_phase_pm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over setting_btn.
function setting_btn_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to setting_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function RCS_bottom_tb_Callback(hObject, eventdata, handles)
% hObject    handle to RCS_bottom_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RCS_bottom_tb as text
%        str2double(get(hObject,'String')) returns contents of RCS_bottom_tb as a double


% --- Executes during object creation, after setting all properties.
function RCS_bottom_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RCS_bottom_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RCS_top_tb_Callback(hObject, eventdata, handles)
% hObject    handle to RCS_top_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RCS_top_tb as text
%        str2double(get(hObject,'String')) returns contents of RCS_top_tb as a double


% --- Executes during object creation, after setting all properties.
function RCS_top_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RCS_top_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in VDR_Range_btn.
function VDR_Range_btn_Callback(hObject, eventdata, handles)
% hObject    handle to VDR_Range_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% update VDR
% RCS colorplot
display_RCS_colorplot(handles.RCS_colorplot_axes, handles.mTime, handles.height, handles.RCS, 'scale', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value}, 'tRange', [datenum(handles.starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], 'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], 'cRange', [str2double(handles.RCS_bottom_tb.String), str2double(handles.RCS_top_tb.String)], 'Temp', handles.Temp, 'CBH', str2double(handles.cloud_base_tb.String), 'CTH', str2double(handles.cloud_top_tb.String), 'CTT', handles.CTT, 'cloud_starttime', datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS'), 'cloud_stoptime', datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS'), 'ret_bottom', str2double(handles.ret_H_bottom_tb.String), 'ret_top', str2double(handles.ret_H_top_tb.String), 'ret_starttime', datenum(handles.ret_starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), 'ret_stoptime', datenum(handles.ret_stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS'));

% VDR colorplot
display_VDR_colorplot(handles.VDR_colorplot_axes, handles.mTime, handles.height, handles.VDR, 'tRange', [datenum(handles.starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], 'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], 'cRange', [str2double(handles.VDR_bottom_tb.String), str2double(handles.VDR_top_tb.String)], 'Temp', handles.Temp, 'CBH', str2double(handles.cloud_base_tb.String), 'CTH', str2double(handles.cloud_top_tb.String), 'CTT', handles.CTT, 'cloud_starttime', datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS'), 'cloud_stoptime', datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS'), 'ret_bottom', str2double(handles.ret_H_bottom_tb.String), 'ret_top', str2double(handles.ret_H_top_tb.String), 'ret_starttime', datenum(handles.ret_starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), 'ret_stoptime', datenum(handles.ret_stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS'));

% VDR profile
display_VDR_profi(handles.VDR_lineplot_axes, handles.height, handles.VDR_Profi, str2double(handles.mol_depol_tb.String) .* ones(size(handles.height)), 'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], 'VDRRange', [str2double(handles.VDR_bottom_tb.String), str2double(handles.VDR_top_tb.String)], 'CBH', str2double(handles.cloud_base_tb.String), 'CTH', str2double(handles.cloud_top_tb.String), 'CTT', handles.CTT);

% depol profile
display_depol_profi(handles.ret_depol_lineplot_axes, handles.ret_height, handles.ret_VDR_Profi, handles.ret_PDR_Profi, 'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], 'DepolRange', [str2double(handles.VDR_bottom_tb.String), str2double(handles.VDR_top_tb.String)], 'LBH', str2double(handles.LayerBase_tb.String), 'LTH', str2double(handles.LayerTop_tb.String));

% Update handles structure
guidata(hObject, handles);

function VDR_bottom_tb_Callback(hObject, eventdata, handles)
% hObject    handle to VDR_bottom_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VDR_bottom_tb as text
%        str2double(get(hObject,'String')) returns contents of VDR_bottom_tb as a double


% --- Executes during object creation, after setting all properties.
function VDR_bottom_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VDR_bottom_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function VDR_top_tb_Callback(hObject, eventdata, handles)
% hObject    handle to VDR_top_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VDR_top_tb as text
%        str2double(get(hObject,'String')) returns contents of VDR_top_tb as a double


% --- Executes during object creation, after setting all properties.
function VDR_top_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VDR_top_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Temp_range_btn.
function Temp_range_btn_Callback(hObject, eventdata, handles)
% hObject    handle to Temp_range_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% update temperature plot
display_Temp_profi(handles.Temp_lineplot_axes, handles.height, handles.Temp_Profi, 'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], 'TempRange', [str2double(handles.Temp_bottom_tb.String), str2double(handles.Temp_top_tb.String)], 'CBH', str2double(handles.cloud_base_tb.String), 'CTH', str2double(handles.cloud_top_tb.String), 'CTT', handles.CTT);

% Update handles structure
guidata(hObject, handles);

function Temp_bottom_tb_Callback(hObject, eventdata, handles)
% hObject    handle to Temp_bottom_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Temp_bottom_tb as text
%        str2double(get(hObject,'String')) returns contents of Temp_bottom_tb as a double


% --- Executes during object creation, after setting all properties.
function Temp_bottom_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Temp_bottom_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Temp_top_tb_Callback(hObject, eventdata, handles)
% hObject    handle to Temp_top_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Temp_top_tb as text
%        str2double(get(hObject,'String')) returns contents of Temp_top_tb as a double


% --- Executes during object creation, after setting all properties.
function Temp_top_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Temp_top_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bsc_range_tb.
function bsc_range_tb_Callback(hObject, eventdata, handles)
% hObject    handle to bsc_range_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% bsc profile
display_bsc_profi(handles.ret_bsc_lineplot_axes, handles.ret_height, handles.ret_bsc_Profi * 1e6, 'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], 'aerBscRange', [str2double(handles.bsc_bottom_tb.String), str2double(handles.bsc_top_tb.String)], 'LBH', str2double(handles.LayerBase_tb.String), 'LTH', str2double(handles.LayerTop_tb.String), 'dustBsc', handles.ret_bsc_d_Profi * 1e6, 'nondustBsc', handles.ret_bsc_nd_Profi * 1e6);

% Update handles structure
guidata(hObject, handles);


function bsc_bottome_tb_Callback(hObject, eventdata, handles)
% hObject    handle to bsc_bottome_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bsc_bottome_tb as text
%        str2double(get(hObject,'String')) returns contents of bsc_bottome_tb as a double


% --- Executes during object creation, after setting all properties.
function bsc_bottome_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bsc_bottome_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bsc_top_tb_Callback(hObject, eventdata, handles)
% hObject    handle to bsc_top_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bsc_top_tb as text
%        str2double(get(hObject,'String')) returns contents of bsc_top_tb as a double


% --- Executes during object creation, after setting all properties.
function bsc_top_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bsc_top_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double


% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mass_top_tb_Callback(hObject, eventdata, handles)
% hObject    handle to mass_top_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mass_top_tb as text
%        str2double(get(hObject,'String')) returns contents of mass_top_tb as a double


% --- Executes during object creation, after setting all properties.
function mass_top_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mass_top_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ref_H_bottom_tb_Callback(hObject, eventdata, handles)
% hObject    handle to ref_H_bottom_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ref_H_bottom_tb as text
%        str2double(get(hObject,'String')) returns contents of ref_H_bottom_tb as a double



function ret_H_bottom_tb_Callback(hObject, eventdata, handles)
% hObject    handle to ret_H_bottom_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ret_H_bottom_tb as text
%        str2double(get(hObject,'String')) returns contents of ret_H_bottom_tb as a double


function scrollDownLogBox(log_box_handle)
% scroll down the log info edit box

jhLogBox = findjobj(log_box_handle);
jEdit = jhLogBox.getComponent(0).getComponent(0);
jEdit.setCaretPosition(jEdit.getDocument.getLength);


% --- Executes on button press in RCS_range_btn.
function RCS_range_btn_Callback(hObject, eventdata, handles)
% hObject    handle to RCS_range_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% update RCS
% RCS colorplot
display_RCS_colorplot(handles.RCS_colorplot_axes, handles.mTime, handles.height, handles.RCS, 'scale', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value}, 'tRange', [datenum(handles.starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], 'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], 'cRange', [str2double(handles.RCS_bottom_tb.String), str2double(handles.RCS_top_tb.String)], 'Temp', handles.Temp, 'CBH', str2double(handles.cloud_base_tb.String), 'CTH', str2double(handles.cloud_top_tb.String), 'CTT', handles.CTT, 'cloud_starttime', datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS'), 'cloud_stoptime', datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS'), 'ret_bottom', str2double(handles.ret_H_bottom_tb.String), 'ret_top', str2double(handles.ret_H_top_tb.String), 'ret_starttime', datenum(handles.ret_starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), 'ret_stoptime', datenum(handles.ret_stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS'));

% VDR colorplot
display_VDR_colorplot(handles.VDR_colorplot_axes, handles.mTime, handles.height, handles.VDR, 'tRange', [datenum(handles.starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], 'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], 'cRange', [str2double(handles.VDR_bottom_tb.String), str2double(handles.VDR_top_tb.String)], 'Temp', handles.Temp, 'CBH', str2double(handles.cloud_base_tb.String), 'CTH', str2double(handles.cloud_top_tb.String), 'CTT', handles.CTT, 'cloud_starttime', datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS'), 'cloud_stoptime', datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS'), 'ret_bottom', str2double(handles.ret_H_bottom_tb.String), 'ret_top', str2double(handles.ret_H_top_tb.String), 'ret_starttime', datenum(handles.ret_starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), 'ret_stoptime', datenum(handles.ret_stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS'));

% RCS profile
display_RCS_profi(handles.RCS_lineplot_axes, handles.height, handles.RCS_Profi, handles.mol_RCS_Profi, 'scale', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value}, 'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], 'RCSRange', [str2double(handles.RCS_bottom_tb.String), str2double(handles.RCS_top_tb.String)], 'CBH', str2double(handles.cloud_base_tb.String), 'CTH', str2double(handles.cloud_top_tb.String), 'CTT', handles.CTT);

% sig profile
display_sig_profi(handles.ret_sig_lineplot_axes, handles.ret_height, handles.ret_RCS_Profi, handles.ret_mol_RCS_Profi, 'scale', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value}, 'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], 'RCSRange', [str2double(handles.RCS_bottom_tb.String), str2double(handles.RCS_top_tb.String)], 'caliRange', [str2double(handles.ref_H_bottom_tb.String), str2double(handles.ref_H_top_tb.String)]);

% Update handles structure
guidata(hObject, handles);


function mass_range_btn_Callback(hObject, eventdata, handles)
% hObject    handle to RCS_range_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% mass profile
display_mass_profi(handles.ret_mass_lineplot_axes, handles.ret_height, handles.ret_mass_nd_Profi * 1e9, handles.ret_mass_d_Profi * 1e9, 'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], 'massRange', [str2double(handles.mass_bottom_tb.String), str2double(handles.mass_top_tb.String)], 'LBH', str2double(handles.LayerBase_tb.String), 'LTH', str2double(handles.LayerTop_tb.String));

% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ret_clear_btn.
function ret_clear_btn_Callback(hObject, eventdata, handles)
% hObject    handle to ret_clear_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% update data in handles
handles.retLidarData = struct();
handles.retMTime = NaN(1, 100);
handles.ret_height = NaN(1, 100);
handles.ret_Temp_Profi = NaN(1, 100);
handles.ret_RCS_Profi = NaN(1, 100);
handles.ret_mol_RCS_Profi = NaN(1, 100);
handles.ret_bsc_Profi = NaN(1, 100);
handles.ret_bsc_d_Profi = NaN(1, 100);
handles.ret_bsc_d_std_Profi = NaN(1, 100);
handles.ret_bsc_nd_Profi = NaN(1, 100);
handles.ret_bsc_nd_std_Profi = NaN(1, 100);
handles.ret_VDR_Profi = NaN(1, 100);
handles.ret_VDR_std_Profi = NaN(1, 100);
handles.ret_PDR_Profi = NaN(1, 100);
handles.ret_PDR_std_Profi = NaN(1, 100);
handles.ret_mass_d_Profi = NaN(1, 100);
handles.ret_mass_d_std_Profi = NaN(1, 100);
handles.ret_mass_nd_Profi = NaN(1, 100);
handles.ret_mass_nd_std_Profi = NaN(1, 100);

%% update plots
% RCS colorplot
display_RCS_colorplot(handles.RCS_colorplot_axes, handles.mTime, handles.height, handles.RCS, 'scale', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value}, 'tRange', [datenum(handles.starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], 'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], 'cRange', [str2double(handles.RCS_bottom_tb.String), str2double(handles.RCS_top_tb.String)], 'Temp', handles.Temp, 'CBH', str2double(handles.cloud_base_tb.String), 'CTH', str2double(handles.cloud_top_tb.String), 'CTT', handles.CTT, 'cloud_starttime', datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS'), 'cloud_stoptime', datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS'));

% VDR colorplot
display_VDR_colorplot(handles.VDR_colorplot_axes, handles.mTime, handles.height, handles.VDR, 'tRange', [datenum(handles.starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], 'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], 'cRange', [str2double(handles.VDR_bottom_tb.String), str2double(handles.VDR_top_tb.String)], 'Temp', handles.Temp, 'CBH', str2double(handles.cloud_base_tb.String), 'CTH', str2double(handles.cloud_top_tb.String), 'CTT', handles.CTT, 'cloud_starttime', datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS'), 'cloud_stoptime', datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS'));

% sig profile
display_sig_profi(handles.ret_sig_lineplot_axes, handles.ret_height, handles.ret_RCS_Profi, handles.ret_mol_RCS_Profi, 'scale', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value}, 'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], 'RCSRange', [str2double(handles.RCS_bottom_tb.String), str2double(handles.RCS_top_tb.String)]);

% bsc profile
display_bsc_profi(handles.ret_bsc_lineplot_axes, handles.ret_height, handles.ret_bsc_Profi * 1e6, 'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], 'aerBscRange', [str2double(handles.bsc_bottom_tb.String), str2double(handles.bsc_top_tb.String)], 'dustBsc', handles.ret_bsc_d_Profi * 1e6, 'nondustBsc', handles.ret_bsc_nd_Profi * 1e6);

% depol profile
display_depol_profi(handles.ret_depol_lineplot_axes, handles.ret_height, handles.ret_VDR_Profi, handles.ret_PDR_Profi, 'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], 'DepolRange', [str2double(handles.VDR_bottom_tb.String), str2double(handles.VDR_top_tb.String)]);

% mass profile
display_mass_profi(handles.ret_mass_lineplot_axes, handles.ret_height, handles.ret_mass_nd_Profi * 1e9, handles.ret_mass_d_Profi * 1e9, 'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], 'massRange', [str2double(handles.mass_bottom_tb.String), str2double(handles.mass_top_tb.String)]);

% Update handles structure
guidata(hObject, handles);


function logPrint(fh, inStr)
    fh.String{end + 1} = inStr;
    scrollDownLogBox(fh);



function cloud_start_tb_Callback(hObject, eventdata, handles)
% hObject    handle to cloud_start_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cloud_start_tb as text
%        str2double(get(hObject,'String')) returns contents of cloud_start_tb as a double


% --- Executes during object creation, after setting all properties.
function cloud_start_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cloud_start_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cloud_stop_tb_Callback(hObject, eventdata, handles)
% hObject    handle to cloud_stop_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cloud_stop_tb as text
%        str2double(get(hObject,'String')) returns contents of cloud_stop_tb as a double


% --- Executes during object creation, after setting all properties.
function cloud_stop_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cloud_stop_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in delete_btn.
function delete_btn_Callback(hObject, eventdata, handles)
% hObject    handle to delete_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Construct a questdlg with three options

choice = questdlg('Delete the case?', ...
    'Delete...', ...
    'Yes','No','Cancel','No');

% Handle response
switch choice
    case 'Yes'
        delete(handles.infoFile);

        handles.log_tb.String{end + 1} = sprintf('Deleted %s', handles.infoFile);
        scrollDownLogBox(handles.log_tb);

    case 'Cake'

        handles.log_tb.String{end + 1} = sprintf('Cancelled to delete %s', handles.infoFile);
        scrollDownLogBox(handles.log_tb);

    case 'No thank you'
        % do nothing

end

end