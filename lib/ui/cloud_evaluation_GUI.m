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

% Last Modified by GUIDE v2.5 01-Jul-2022 17:11:33

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
settingTemplate = fullfile(projectDir, 'lib', 'settings_global.yml');
settings = load_settings(settingFile, settingTemplate);
handles.settings = settings;
handles.setting_tb.String = settingFile;
logPrint(handles.log_tb, sprintf('[%s] load settings successfully!', tNow()));

% Choose default command line output for cloud_evaluation_GUI
handles.output = hObject;
handles.lidarData = struct();
handles.mTime = linspace(datenum(2010, 1, 1, 0, 0, 0), ...
                         datenum(2010, 1, 1, 1, 0, 0), 100);
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
handles.ret_Temp_Profi = NaN(1, 100);
handles.ret_Pres_Profi = NaN(1, 100);
handles.ret_mol_RCS_Profi = NaN(1, 100);
handles.ret_bsc_Profi = NaN(1, 100);
handles.ret_bsc_std_Profi = NaN(1, 100);
handles.ret_bsc_d_Profi = NaN(1, 100);
handles.ret_bsc_d_std_Profi = NaN(1, 100);
handles.ret_bsc_nd_Profi = NaN(1, 100);
handles.ret_bsc_nd_std_Profi = NaN(1, 100);
handles.ret_VDR_Profi = NaN(1, 100);
handles.ret_VDR_std_Profi = NaN(1, 100);
handles.ret_PDR_Profi = NaN(1, 100);
handles.ret_PDR_std_Profi = NaN(1, 100);
handles.ret_mass_nd_Profi = NaN(1, 100);
handles.ret_mass_nd_std_Profi = NaN(1, 100);
handles.ret_mass_d_Profi = NaN(1, 100);
handles.ret_mass_d_std_Profi = NaN(1, 100);
handles.projectDir = projectDir;
logPrint(handles.log_tb, 'Enjoy the day');

%% initialize the figures
% RCS colorplot
display_RCS_colorplot(handles.RCS_colorplot_axes, handles.mTime, ...
                      handles.height, handles.RCS, ...
                      'scale', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value}, ...
                      'tRange', [datenum(handles.starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], ...
                      'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], ...
                      'cRange', [str2double(handles.RCS_bottom_tb.String), str2double(handles.RCS_top_tb.String)], ...
                      'Temp', handles.Temp, ...
                      'cmap', handles.cmap_pm.String{handles.cmap_pm.Value});

% VDR colorplot
display_VDR_colorplot(handles.VDR_colorplot_axes, handles.mTime, ...
                      handles.height, handles.VDR, ...
                      'tRange', [datenum(handles.starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], ...
                      'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], ...
                      'cRange', [str2double(handles.VDR_bottom_tb.String), str2double(handles.VDR_top_tb.String)], ...
                      'Temp', handles.Temp, ...
                      'cmap', handles.cmap_pm.String{handles.cmap_pm.Value});

% RCS profile
display_RCS_profi(handles.RCS_lineplot_axes, handles.height, handles.RCS_Profi, ...
                  handles.mol_RCS_Profi, ...
                  'scale', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value}, ...
                  'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], ...
                  'RCSRange', [str2double(handles.RCS_bottom_tb.String), str2double(handles.RCS_top_tb.String)]);

% RH profile
display_RH_profi(handles.RH_lineplot_axes, handles.height, handles.RH_Profi, ...
    'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], ...
    'RHRange', [0, 100]);

% VDR profile
display_VDR_profi(handles.VDR_lineplot_axes, ...
                  handles.height, ...
                  handles.VDR_Profi, ...
                  str2double(handles.mol_depol_tb.String) .* ones(size(handles.height)), ...
                  'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], ...
                  'VDRRange', [str2double(handles.VDR_bottom_tb.String), str2double(handles.VDR_top_tb.String)]);

% Temp profile
display_Temp_profi(handles.Temp_lineplot_axes, ...
                   handles.height, ...
                   handles.Temp_Profi, ...
                   'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], ...
                   'TempRange', [str2double(handles.Temp_bottom_tb.String), str2double(handles.Temp_top_tb.String)]);

% sig profile
display_sig_profi(handles.ret_sig_lineplot_axes, ...
                  handles.ret_height, ...
                  handles.ret_RCS_Profi, ...
                  handles.ret_mol_RCS_Profi, ...
                  'scale', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value}, ...
                  'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], ...
                  'RCSRange', [str2double(handles.RCS_bottom_tb.String), str2double(handles.RCS_top_tb.String)]);

% bsc profile
display_bsc_profi(handles.ret_bsc_lineplot_axes, ...
                  handles.ret_height, ...
                  handles.ret_bsc_Profi, ...
                  'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], ...
                  'aerBscRange', [str2double(handles.bsc_bottom_tb.String), str2double(handles.bsc_top_tb.String)]);

% depol profile
display_depol_profi(handles.ret_depol_lineplot_axes, ...
                    handles.ret_height, ...
                    handles.ret_VDR_Profi, ...
                    handles.ret_PDR_Profi, ...
                    'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], ...
                    'DepolRange', [str2double(handles.VDR_bottom_tb.String), str2double(handles.VDR_top_tb.String)]);

% mass profile
display_mass_profi(handles.ret_mass_lineplot_axes, ...
                   handles.ret_height, ...
                   handles.ret_mass_nd_Profi, ...
                   handles.ret_mass_d_Profi, ...
                   'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], ...
                   'massRange', [str2double(handles.mass_bottom_tb.String), str2double(handles.mass_top_tb.String)]);

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
    handles.setting_tb.String = sprintf('%s', handles.settingFile);

    % read settings
    settingFile = handles.settingFile;
    settingTemplate = fullfile(handles.projectDir, 'lib', 'settings_global.yml');
    settings = load_settings(settingFile, settingTemplate);
    handles.settings = settings;

    logPrint(handles.log_tb, sprintf('[%s] load settings successfully!', tNow()));

    % validate settings
    if ~ exist(settings.dataDir, 'dir')
        logPrint(handles.log_tb, sprintf('[%s] dataDir does not exist', tNow()));
    end

end

guidata(hObject, handles);


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

if infoFile ~= 0
    handles.infoFile_tb.String = sprintf('%s', fullfile(infoPath, infoFile));

    % read infos
    load(handles.infoFile);

    progInfo = programInfo();
    if ~ strcmp(metadata.processor_version, progInfo.Version)
        logPrint(handles.log_tb, ...
            sprintf('[%s] Incompatible version\nVersion (infoFile): %s;\nVersion (working): %s;\nIssues may happen! Try to download the suitable version at https://github.com/ZPYin/cloud_evaluation_GUI/releases', ...
            tNow(), ...
            metadata.processor_version, ...
            progInfo.Version));
    end

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
    if ~ isfield(widgetInfo, 'offset')
        handles.offset_tb.String = '0.000';
    else
        handles.offset_tb.String = widgetInfo.offset;
    end
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
    if ~ isfield(widgetInfo, 'cmap')
        handles.cmap_pm.Value = 1;
    else
        handles.cmap_pm.Value = find(strcmpi(handles.cmap_pm.String, widgetInfo.cmap));
    end
    handles.RCS_scale_pm.Value = find(strcmpi(handles.RCS_scale_pm.String, widgetInfo.RCS_scale));
    handles.RCS_bottom_tb.String = widgetInfo.RCS_bottom;
    handles.RCS_top_tb.String = widgetInfo.RCS_top;
    handles.VDR_bottom_tb.String = widgetInfo.VDR_bottom;
    handles.VDR_top_tb.String = widgetInfo.VDR_top;
    handles.Temp_bottom_tb.String = widgetInfo.Temp_bottom;
    handles.Temp_top_tb.String = widgetInfo.Temp_top;

    logPrint(handles.log_tb, sprintf('[%s] load info file successfully!', tNow()));

    handles.infoFile_tb.String = handles.infoFile;
end


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
    logPrint(handles.log_tb, ...
             sprintf('[%s] Lidar data does not exist: %s', tNow, handles.setting_tb.String));
end

% read lidar data
lidarData = PLidar_readdata(handles.settings.dataDir, ...
    [datenum(handles.starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], ...
    [str2double(handles.H_base_tb.String) * 1000, ...
    str2double(handles.H_top_tb.String) * 1000], ...
    'dVersion', handles.settings.data_version);

if isempty(lidarData.time)
    logPrint(handles.log_tb, sprintf('[%s] No lidar data available.', tNow()));
    return;
end

% read meteorological data
[Temp_Profi, Pres_Profi, RH_Profi] = read_meteordata(...
    mean([datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS')]) - datenum(0, 1, 0, 8, 0, 0), ...
    lidarData.altitude, ...
    'meteor_data', handles.meteor_data_pm.String{handles.meteor_data_pm.Value}, ...
    'station', handles.settings.station, ...
    'GDAS1Folder', handles.settings.GDAS1Dir, ...
    'RadiosondeFolder', handles.settings.soundingDir, ...
    'ERA5Folder', handles.settings.ERA5Dir);
Temp_2D = read_gridTemp(lidarData.time - datenum(0, 1, 0, 8, 0, 0), ...
    lidarData.altitude, ...
    'meteor_data', handles.meteor_data_pm.String{handles.meteor_data_pm.Value}, ...
    'station', handles.settings.station, ...
    'GDAS1Folder', handles.settings.GDAS1Dir, ...
    'RadiosondeFolder', handles.settings.soundingDir, ...
    'ERA5Folder', handles.settings.ERA5Dir);

%% Rayleigh scattering
[molBsc, molExt] = rayleigh_scattering(str2double(handles.wavelength_tb.String), Pres_Profi, Temp_Profi + 273.14, 360, 80);
molRCS = molBsc .* exp(-2 .* nancumsum([lidarData.height(1), diff(lidarData.height)] .* molExt));

flagClH = (lidarData.height >= str2double(handles.cloud_base_tb.String) * 1000) & ...
          (lidarData.height <= str2double(handles.cloud_top_tb.String) * 1000);
%% update data in handles
handles.lidarData = lidarData;
handles.mTime = lidarData.time;
handles.height = lidarData.height / 1e3;
elSig = (lidarData.sigCH1 + str2double(handles.gainRatio_tb.String) .* lidarData.sigCH2);
elBG = (lidarData.BGCH1 + str2double(handles.gainRatio_tb.String) .* lidarData.BGCH2);
flagCloud = (lidarData.time >= datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS')) & ...
            (lidarData.time <= datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS'));
handles.RCS = elSig .* repmat(lidarData.height', 1, length(lidarData.time)).^2;
handles.VDR = str2double(handles.gainRatio_tb.String) .* lidarData.sigCH2 ./ lidarData.sigCH1 - str2double(handles.offset_tb.String);
handles.Temp = Temp_2D;
handles.RCS_Profi = transpose(nanmean(elSig(:, flagCloud), 2)) .* lidarData.height .^ 2;
handles.VDR_Profi = transpose(nanmean(lidarData.sigCH2(:, flagCloud), 2) ./ nanmean(lidarData.sigCH1(:, flagCloud), 2)) .* ...
    str2double(handles.gainRatio_tb.String) - str2double(handles.offset_tb.String);
handles.mol_RCS_Profi = molRCS .* (nanmean(handles.RCS_Profi(flagClH)) ./ nanmean(molRCS(flagClH)));
handles.Temp_Profi = Temp_Profi;
handles.CTT = Temp_Profi(find(lidarData.height >= str2double(handles.cloud_top_tb.String) * 1000, 1));
handles.RH_Profi = RH_Profi;

cloudTopLayerIndx = (lidarData.height >= str2double(handles.cloud_top_tb.String) * 1000) & ...
                    (lidarData.height <= str2double(handles.cloud_top_tb.String) * 1000 + 500);
handles.cloud_top_sig_2_bg = nanmean(nanmean(elSig(cloudTopLayerIndx, :), 1), 2) ./ nanmean(elBG);

%% update plots
% RCS colorplot
display_RCS_colorplot(handles.RCS_colorplot_axes, ...
                      handles.mTime, handles.height, ...
                      handles.RCS, ...
                      'scale', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value}, ...
                      'tRange', [datenum(handles.starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], ...
                      'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], ...
                      'cRange', [str2double(handles.RCS_bottom_tb.String), str2double(handles.RCS_top_tb.String)], ...
                      'Temp', handles.Temp, ...
                      'CBH', str2double(handles.cloud_base_tb.String), ...
                      'CTH', str2double(handles.cloud_top_tb.String), ...
                      'CTT', handles.CTT, ...
                      'cloud_starttime', datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
                      'cloud_stoptime', datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
                      'ret_bottom', str2double(handles.ret_H_bottom_tb.String), ...
                      'ret_top', str2double(handles.ret_H_top_tb.String), ...
                      'ret_starttime', datenum(handles.ret_starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
                      'ret_stoptime', datenum(handles.ret_stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
                      'cmap', handles.cmap_pm.String{handles.cmap_pm.Value});

% VDR colorplot
display_VDR_colorplot(handles.VDR_colorplot_axes, ...
                      handles.mTime, handles.height, ...
                      handles.VDR, ...
                      'tRange', [datenum(handles.starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], ...
                      'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], ...
                      'cRange', [str2double(handles.VDR_bottom_tb.String), str2double(handles.VDR_top_tb.String)], ...
                      'Temp', handles.Temp, ...
                      'CBH', str2double(handles.cloud_base_tb.String), ...
                      'CTH', str2double(handles.cloud_top_tb.String), ...
                      'CTT', handles.CTT, ...
                      'cloud_starttime', datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
                      'cloud_stoptime', datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
                      'ret_bottom', str2double(handles.ret_H_bottom_tb.String), ...
                      'ret_top', str2double(handles.ret_H_top_tb.String), ...
                      'ret_starttime', datenum(handles.ret_starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
                      'ret_stoptime', datenum(handles.ret_stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
                      'cmap', handles.cmap_pm.String{handles.cmap_pm.Value});

% RCS profile
display_RCS_profi(handles.RCS_lineplot_axes, ...
                  handles.height, ...
                  handles.RCS_Profi, ...
                  handles.mol_RCS_Profi, ...
                  'scale', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value}, ...
                  'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], ...
                  'RCSRange', [str2double(handles.RCS_bottom_tb.String), str2double(handles.RCS_top_tb.String)], ...
                  'CBH', str2double(handles.cloud_base_tb.String), ...
                  'CTH', str2double(handles.cloud_top_tb.String), ...
                  'CTT', handles.CTT);

% RH profile
display_RH_profi(handles.RH_lineplot_axes, ...
                 handles.height, ...
                 handles.RH_Profi, ...
                 'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], ...
                 'RHRange', [0, 100], ...
                 'CBH', str2double(handles.cloud_base_tb.String), ...
                 'CTH', str2double(handles.cloud_top_tb.String), ...
                 'CTT', handles.CTT);

% VDR profile
display_VDR_profi(handles.VDR_lineplot_axes, ...
                  handles.height, ...
                  handles.VDR_Profi, ...
                  str2double(handles.mol_depol_tb.String) .* ones(size(handles.height)), ...
                  'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], ...
                  'VDRRange', [str2double(handles.VDR_bottom_tb.String), str2double(handles.VDR_top_tb.String)], ...
                  'CBH', str2double(handles.cloud_base_tb.String), ...
                  'CTH', str2double(handles.cloud_top_tb.String), ...
                  'CTT', handles.CTT);

% Temp profile
display_Temp_profi(handles.Temp_lineplot_axes, ...
                   handles.height, ...
                   handles.Temp_Profi, ...
                   'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], ...
                   'TempRange', [str2double(handles.Temp_bottom_tb.String), str2double(handles.Temp_top_tb.String)], ...
                   'CBH', str2double(handles.cloud_base_tb.String), ...
                   'CTH', str2double(handles.cloud_top_tb.String), ...
                   'CTT', handles.CTT);

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

cloud_starttime = datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS');
cloud_stoptime = datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS');

saveFile = fullfile(handles.settings.saveDir, ...
                    sprintf('cloud_eval_output_%s-%s_%05d-%05d_sm%04d.mat', ...
                        datestr(cloud_starttime, 'yyyymmdd_HHMM'), ...
                        datestr(cloud_stoptime, 'yyyymmdd_HHMM'), ...
                        int32(str2double(handles.cloud_base_tb.String) * 1000), ...
                        int32(str2double(handles.cloud_top_tb.String) * 1000), ...
                        str2double(handles.smoothwin_tb.String)));

save_2_mat(handles, saveFile);

%% update status
logPrint(handles.log_tb, sprintf('[%s] Results have been saved to %s', tNow, saveFile));

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in export_fig_btn.
function export_fig_btn_Callback(hObject, eventdata, handles)
% hObject    handle to export_fig_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cloud_starttime = datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS');
cloud_stoptime = datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS');
saveFile = fullfile(handles.settings.saveDir, ...
    sprintf('cloud_eval_output_%s-%s_%05d-%05d_sm%s.png', ...
        datestr(cloud_starttime, 'yyyymmdd_HHMM'), ...
        datestr(cloud_stoptime, 'yyyymmdd_HHMM'), ...
        int32(str2double(handles.cloud_base_tb.String) * 1000), ...
        int32(str2double(handles.cloud_top_tb.String) * 1000), ...
        handles.smoothwin_tb.String));
export_fig(gcf, saveFile, '-r300');

%% update status
logPrint(handles.log_tb, sprintf('[%s] Snapshot of the figure have been saved to %s', tNow, saveFile));

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
lidarData = PLidar_readdata(handles.settings.dataDir, ...
    [datenum(handles.ret_starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.ret_stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], ...
    [str2double(handles.ret_H_bottom_tb.String) * 1000, ...
    str2double(handles.ret_H_top_tb.String) * 1000], ...
    'dVersion', handles.settings.data_version);

if isempty(lidarData.time)
    logPrint(handles.log_tb, sprintf('[%s] No lidar data available.', tNow()));
    return;
end

% read meteorological data
[ret_Temp_Profi, ret_Pres_Profi, ~] = read_meteordata(...
    mean([datenum(handles.ret_starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.ret_stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')]) - datenum(0, 1, 0, 8, 0, 0), ...
    lidarData.altitude, ...
    'meteor_data', handles.meteor_data_pm.String{handles.meteor_data_pm.Value}, ...
    'station', handles.settings.station, ...
    'GDAS1Folder', handles.settings.GDAS1Dir, ...
    'RadiosondeFolder', handles.settings.soundingDir, ...
    'ERA5Folder', handles.settings.ERA5Dir);

%% Rayleigh scattering
[molBsc, molExt] = rayleigh_scattering(str2double(handles.wavelength_tb.String), ret_Pres_Profi, ret_Temp_Profi + 273.14, 360, 80);
molRCS = molBsc .* exp(-2 .* nancumsum([lidarData.height(1), diff(lidarData.height)] .* molExt));

if isempty(lidarData.height)
    logPrint(handles.log_tb, sprintf('[%s] no data for aerosol retrievals were found!', tNow));
    return;
end

%% aerosol retrievals
elSig = (lidarData.sigCH1 + str2double(handles.gainRatio_tb.String) .* lidarData.sigCH2);
elBG = (lidarData.BGCH1 + str2double(handles.gainRatio_tb.String) .* lidarData.BGCH2);
sm_win_bins = floor(str2double(handles.smoothwin_tb.String) ./ (lidarData.height(2) - lidarData.height(1)));
if sm_win_bins <= 0
    logPrint(handles.log_tb, sprintf('[%s] not enough data bins.', tNow));
end
sigCH1 = transpose(nansum(lidarData.sigCH1, 2));
sigCH2 = transpose(nansum(lidarData.sigCH2, 2));
BGCH1 = nansum(lidarData.BGCH1);
BGCH2 = nansum(lidarData.BGCH2);
elSigSum = transpose(nansum(elSig, 2));
elBG = nansum(elBG);
ret_RCS_Profi = transpose(smooth(transpose(nanmean(elSig, 2)) .* lidarData.height .^ 2, sm_win_bins));

if str2double(handles.ref_H_top_tb.String) >= str2double(handles.ret_H_top_tb.String)
    logPrint(handles.log_tb, sprintf('[%s] reference top is out of range.', tNow));

    return;
end

% backscatter
[ret_bsc_Profi, ret_bsc_std_Profi] = PLidar_Fernald(lidarData.height, ...
    elSigSum, elBG, str2double(handles.lr_tb.String), ...
    [str2double(handles.ref_H_bottom_tb.String), str2double(handles.ref_H_top_tb.String)] .* 1000, ...
    str2double(handles.ref_value_tb.String) * 1e-6, ...
    molBsc, ...
    'window_size', sm_win_bins, ...
    'detectMode', handles.settings.detect_mode);

% depol
ret_VDR_Profi = transpose(smooth(sigCH2, sm_win_bins) ./ smooth(sigCH1, sm_win_bins)) .* ...
    str2double(handles.gainRatio_tb.String) - str2double(handles.offset_tb.String);
ret_VDR_std_Profi = ret_VDR_Profi .* ...
    sqrt( 1 ./ PLidar_SNR(sigCH1, BGCH1, 'detectMode', handles.settings.detect_mode).^2 + 1 ./ PLidar_SNR(sigCH2, BGCH2, 'detectMode', handles.settings.detect_mode).^2) ./ sqrt(sm_win_bins);
[ret_PDR_Profi, ret_PDR_std_Profi] = PLidar_parDepol(ret_VDR_Profi, ...
    ret_VDR_std_Profi, ...
    ret_bsc_Profi, ...
    ret_bsc_Profi * 0.1, ...
    molBsc, ...
    str2double(handles.mol_depol_tb.String), ...
    0.2 * str2double(handles.mol_depol_tb.String));

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

flagRefH = (lidarData.height <= str2double(handles.ref_H_top_tb.String) * 1000) & ...
           (lidarData.height >= str2double(handles.ref_H_bottom_tb.String) * 1000);

%% update data in handles
handles.retLidarData = lidarData;
handles.retMTime = lidarData.time;
handles.ret_height = lidarData.height / 1e3;
handles.ret_Temp_Profi = ret_Temp_Profi;
handles.ret_Pres_Profi = ret_Pres_Profi;
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
display_RCS_colorplot(handles.RCS_colorplot_axes, ...
    handles.mTime, ...
    handles.height, ...
    handles.RCS, ...
    'scale', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value}, ...
    'tRange', [datenum(handles.starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], ...
    'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], ...
    'cRange', [str2double(handles.RCS_bottom_tb.String), str2double(handles.RCS_top_tb.String)], ...
    'Temp', handles.Temp, ...
    'CBH', str2double(handles.cloud_base_tb.String), ...
    'CTH', str2double(handles.cloud_top_tb.String), ...
    'CTT', handles.CTT, ...
    'cloud_starttime', datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'cloud_stoptime', datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'ret_bottom', str2double(handles.ret_H_bottom_tb.String), ...
    'ret_top', str2double(handles.ret_H_top_tb.String), ...
    'ret_starttime', datenum(handles.ret_starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'ret_stoptime', datenum(handles.ret_stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'cmap', handles.cmap_pm.String{handles.cmap_pm.Value});

% VDR colorplot
display_VDR_colorplot(handles.VDR_colorplot_axes, ...
    handles.mTime, ...
    handles.height, ...
    handles.VDR, ...
    'tRange', [datenum(handles.starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], ...
    'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], ...
    'cRange', [str2double(handles.VDR_bottom_tb.String), str2double(handles.VDR_top_tb.String)], ...
    'Temp', handles.Temp, ...
    'CBH', str2double(handles.cloud_base_tb.String), ...
    'CTH', str2double(handles.cloud_top_tb.String), ...
    'CTT', handles.CTT, ...
    'cloud_starttime', datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'cloud_stoptime', datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'ret_bottom', str2double(handles.ret_H_bottom_tb.String), ...
    'ret_top', str2double(handles.ret_H_top_tb.String), ...
    'ret_starttime', datenum(handles.ret_starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'ret_stoptime', datenum(handles.ret_stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'cmap', handles.cmap_pm.String{handles.cmap_pm.Value});

% sig profile
display_sig_profi(handles.ret_sig_lineplot_axes, ...
                  handles.ret_height, ...
                  handles.ret_RCS_Profi, ...
                  handles.ret_mol_RCS_Profi, ...
                  'scale', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value}, ...
                  'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], ...
                  'RCSRange', [str2double(handles.RCS_bottom_tb.String), str2double(handles.RCS_top_tb.String)], ...
                  'caliRange', [str2double(handles.ref_H_bottom_tb.String), str2double(handles.ref_H_top_tb.String)]);

% bsc profile
display_bsc_profi(handles.ret_bsc_lineplot_axes, ...
                  handles.ret_height, ...
                  handles.ret_bsc_Profi * 1e6, ...
                  'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], ...
                  'aerBscRange', [str2double(handles.bsc_bottom_tb.String), str2double(handles.bsc_top_tb.String)], ...
                  'LBH', str2double(handles.LayerBase_tb.String), ...
                  'LTH', str2double(handles.LayerTop_tb.String), ...
                  'dustBsc', handles.ret_bsc_d_Profi * 1e6, ...
                  'nondustBsc', handles.ret_bsc_nd_Profi * 1e6);

% depol profile
display_depol_profi(handles.ret_depol_lineplot_axes, ...
                    handles.ret_height, ...
                    handles.ret_VDR_Profi, ...
                    handles.ret_PDR_Profi, ...
                    'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], ...
                    'DepolRange', [str2double(handles.VDR_bottom_tb.String), str2double(handles.VDR_top_tb.String)], ...
                    'LBH', str2double(handles.LayerBase_tb.String), ...
                    'LTH', str2double(handles.LayerTop_tb.String));

% mass profile
display_mass_profi(handles.ret_mass_lineplot_axes, ...
                   handles.ret_height, ...
                   handles.ret_mass_nd_Profi * 1e9, ...
                   handles.ret_mass_d_Profi * 1e9, ...
                   'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], ...
                   'massRange', [str2double(handles.mass_bottom_tb.String), str2double(handles.mass_top_tb.String)], ...
                   'LBH', str2double(handles.LayerBase_tb.String), ...
                   'LTH', str2double(handles.LayerTop_tb.String));

%% update status bar
flagLayer = (lidarData.height >= str2double(handles.LayerBase_tb.String) * 1000) & (lidarData.height <= str2double(handles.LayerTop_tb.String) * 1000);
massDustTot = nansum(handles.ret_mass_d_Profi(flagLayer) .* (lidarData.height(2) - lidarData.height(1))) * 1e9;
massDustTotStd = sqrt(nansum((handles.ret_mass_d_std_Profi(flagLayer) .* (lidarData.height(2) - lidarData.height(1))).^2)) * 1e9;
massNonDustTot = nansum(handles.ret_mass_nd_Profi(flagLayer) .* (lidarData.height(2) - lidarData.height(1))) * 1e9;
massNonDustTotStd = sqrt(nansum((handles.ret_mass_nd_std_Profi(flagLayer) .* (lidarData.height(2) - lidarData.height(1))).^2)) * 1e9;

flagRefH = (lidarData.height >= str2double(handles.ref_H_bottom_tb.String) * 1000) & (lidarData.height <= str2double(handles.ref_H_top_tb.String) * 1000);
molDepol_meas = str2double(handles.gainRatio_tb.String) .* nansum(sigCH2(flagRefH)) ./ nansum(sigCH1(flagRefH));
molDepol_std_meas =  molDepol_meas .* ...
    sqrt( 1 ./ PLidar_SNR(nansum(sigCH1(flagRefH)), sum(flagRefH) * BGCH1, 'detectMode', handles.settings.detect_mode).^2 + ...
          1 ./ PLidar_SNR(nansum(sigCH2(flagRefH)), sum(flagRefH) * BGCH2, 'detectMode', handles.settings.detect_mode).^2);

logPrint(handles.log_tb, sprintf('Estimated mol depol: %6.4f+-%6.4f', molDepol_meas, molDepol_std_meas));
logPrint(handles.log_tb, sprintf('Layer dust conc.    : %6.1f+-%6.1f ug*m-2', massDustTot, massDustTotStd));
logPrint(handles.log_tb, sprintf('Layer non-dust conc.: %6.1f+-%6.1f ug*m-2', massNonDustTot, massNonDustTotStd));

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
display_RCS_colorplot(handles.RCS_colorplot_axes, ...
    handles.mTime, ...
    handles.height, ...
    handles.RCS, ...
    'scale', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value}, ...
    'tRange', [datenum(handles.starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], ...
    'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], ...
    'cRange', [str2double(handles.RCS_bottom_tb.String), str2double(handles.RCS_top_tb.String)], ...
    'Temp', handles.Temp, ...
    'CBH', str2double(handles.cloud_base_tb.String), ...
    'CTH', str2double(handles.cloud_top_tb.String), ...
    'CTT', handles.CTT, ...
    'cloud_starttime', datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'cloud_stoptime', datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'ret_bottom', str2double(handles.ret_H_bottom_tb.String), ...
    'ret_top', str2double(handles.ret_H_top_tb.String), ...
    'ret_starttime', datenum(handles.ret_starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'ret_stoptime', datenum(handles.ret_stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'cmap', handles.cmap_pm.String{handles.cmap_pm.Value});

% VDR colorplot
display_VDR_colorplot(handles.VDR_colorplot_axes, ...
    handles.mTime, ...
    handles.height, ...
    handles.VDR, ...
    'tRange', [datenum(handles.starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], ...
    'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], ...
    'cRange', [str2double(handles.VDR_bottom_tb.String), str2double(handles.VDR_top_tb.String)], ...
    'Temp', handles.Temp, ...
    'CBH', str2double(handles.cloud_base_tb.String), ...
    'CTH', str2double(handles.cloud_top_tb.String), ...
    'CTT', handles.CTT, ...
    'cloud_starttime', datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'cloud_stoptime', datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'ret_bottom', str2double(handles.ret_H_bottom_tb.String), ...
    'ret_top', str2double(handles.ret_H_top_tb.String), ...
    'ret_starttime', datenum(handles.ret_starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'ret_stoptime', datenum(handles.ret_stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'cmap', handles.cmap_pm.String{handles.cmap_pm.Value});

% VDR profile
display_VDR_profi(handles.VDR_lineplot_axes, ...
    handles.height, ...
    handles.VDR_Profi, ...
    str2double(handles.mol_depol_tb.String) .* ones(size(handles.height)), ...
    'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], ...
    'VDRRange', [str2double(handles.VDR_bottom_tb.String), str2double(handles.VDR_top_tb.String)], ...
    'CBH', str2double(handles.cloud_base_tb.String), ...
    'CTH', str2double(handles.cloud_top_tb.String), ...
    'CTT', handles.CTT);

% depol profile
display_depol_profi(handles.ret_depol_lineplot_axes, ...
    handles.ret_height, ...
    handles.ret_VDR_Profi, ...
    handles.ret_PDR_Profi, ...
    'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], ...
    'DepolRange', [str2double(handles.VDR_bottom_tb.String), str2double(handles.VDR_top_tb.String)], ...
    'LBH', str2double(handles.LayerBase_tb.String), ...
    'LTH', str2double(handles.LayerTop_tb.String));

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
display_Temp_profi(handles.Temp_lineplot_axes, ...
    handles.height, ...
    handles.Temp_Profi, ...
    'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], ...
    'TempRange', [str2double(handles.Temp_bottom_tb.String), str2double(handles.Temp_top_tb.String)], ...
    'CBH', str2double(handles.cloud_base_tb.String), ...
    'CTH', str2double(handles.cloud_top_tb.String), ...
    'CTT', handles.CTT);

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
display_bsc_profi(handles.ret_bsc_lineplot_axes, ...
    handles.ret_height, ...
    handles.ret_bsc_Profi * 1e6, ...
    'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], ...
    'aerBscRange', [str2double(handles.bsc_bottom_tb.String), str2double(handles.bsc_top_tb.String)], ...
    'LBH', str2double(handles.LayerBase_tb.String), ...
    'LTH', str2double(handles.LayerTop_tb.String), ...
    'dustBsc', handles.ret_bsc_d_Profi * 1e6, ...
    'nondustBsc', handles.ret_bsc_nd_Profi * 1e6);

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
display_RCS_colorplot(handles.RCS_colorplot_axes, ...
    handles.mTime, ...
    handles.height, ...
    handles.RCS, ...
    'scale', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value}, ...
    'tRange', [datenum(handles.starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], ...
    'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], ...
    'cRange', [str2double(handles.RCS_bottom_tb.String), str2double(handles.RCS_top_tb.String)], ...
    'Temp', handles.Temp, ...
    'CBH', str2double(handles.cloud_base_tb.String), ...
    'CTH', str2double(handles.cloud_top_tb.String), ...
    'CTT', handles.CTT, ...
    'cloud_starttime', datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'cloud_stoptime', datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'ret_bottom', str2double(handles.ret_H_bottom_tb.String), ...
    'ret_top', str2double(handles.ret_H_top_tb.String), ...
    'ret_starttime', datenum(handles.ret_starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'ret_stoptime', datenum(handles.ret_stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'cmap', handles.cmap_pm.String{handles.cmap_pm.Value});

% VDR colorplot
display_VDR_colorplot(handles.VDR_colorplot_axes, ...
    handles.mTime, ...
    handles.height, ...
    handles.VDR, ...
    'tRange', [datenum(handles.starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], ...
    'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], ...
    'cRange', [str2double(handles.VDR_bottom_tb.String), str2double(handles.VDR_top_tb.String)], ...
    'Temp', handles.Temp, ...
    'CBH', str2double(handles.cloud_base_tb.String), ...
    'CTH', str2double(handles.cloud_top_tb.String), ...
    'CTT', handles.CTT, ...
    'cloud_starttime', datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'cloud_stoptime', datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'ret_bottom', str2double(handles.ret_H_bottom_tb.String), ...
    'ret_top', str2double(handles.ret_H_top_tb.String), ...
    'ret_starttime', datenum(handles.ret_starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'ret_stoptime', datenum(handles.ret_stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'cmap', handles.cmap_pm.String{handles.cmap_pm.Value});

% RCS profile
display_RCS_profi(handles.RCS_lineplot_axes, ...
    handles.height, ...
    handles.RCS_Profi, ...
    handles.mol_RCS_Profi, ...
    'scale', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value}, ...
    'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], ...
    'RCSRange', [str2double(handles.RCS_bottom_tb.String), str2double(handles.RCS_top_tb.String)], ...
    'CBH', str2double(handles.cloud_base_tb.String), ...
    'CTH', str2double(handles.cloud_top_tb.String), ...
    'CTT', handles.CTT);

% sig profile
display_sig_profi(handles.ret_sig_lineplot_axes, ...
    handles.ret_height, ...
    handles.ret_RCS_Profi, ...
    handles.ret_mol_RCS_Profi, ...
    'scale', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value}, ...
    'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], ...
    'RCSRange', [str2double(handles.RCS_bottom_tb.String), str2double(handles.RCS_top_tb.String)], ...
    'caliRange', [str2double(handles.ref_H_bottom_tb.String), str2double(handles.ref_H_top_tb.String)]);

% Update handles structure
guidata(hObject, handles);


function mass_range_btn_Callback(hObject, eventdata, handles)
% hObject    handle to RCS_range_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% mass profile
display_mass_profi(handles.ret_mass_lineplot_axes, ...
    handles.ret_height, ...
    handles.ret_mass_nd_Profi * 1e9, ...
    handles.ret_mass_d_Profi * 1e9, ...
    'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], ...
    'massRange', [str2double(handles.mass_bottom_tb.String), str2double(handles.mass_top_tb.String)], ...
    'LBH', str2double(handles.LayerBase_tb.String), ...
    'LTH', str2double(handles.LayerTop_tb.String));

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
display_RCS_colorplot(handles.RCS_colorplot_axes, ...
    handles.mTime, ...
    handles.height, ...
    handles.RCS, ...
    'scale', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value}, ...
    'tRange', [datenum(handles.starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], ...
    'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], ...
    'cRange', [str2double(handles.RCS_bottom_tb.String), str2double(handles.RCS_top_tb.String)], ...
    'Temp', handles.Temp, ...
    'CBH', str2double(handles.cloud_base_tb.String), ...
    'CTH', str2double(handles.cloud_top_tb.String), ...
    'CTT', handles.CTT, ...
    'cloud_starttime', datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'cloud_stoptime', datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'cmap', handles.cmap_pm.String{handles.cmap_pm.Value});

% VDR colorplot
display_VDR_colorplot(handles.VDR_colorplot_axes, ...
    handles.mTime, ...
    handles.height, ...
    handles.VDR, ...
    'tRange', [datenum(handles.starttime_tb.String, 'yyyy-mm-dd HH:MM:SS'), datenum(handles.stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS')], ...
    'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)], ...
    'cRange', [str2double(handles.VDR_bottom_tb.String), str2double(handles.VDR_top_tb.String)], ...
    'Temp', handles.Temp, ...
    'CBH', str2double(handles.cloud_base_tb.String), ...
    'CTH', str2double(handles.cloud_top_tb.String), ...
    'CTT', handles.CTT, ...
    'cloud_starttime', datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'cloud_stoptime', datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS'), ...
    'cmap', handles.cmap_pm.String{handles.cmap_pm.Value});

% sig profile
display_sig_profi(handles.ret_sig_lineplot_axes, ...
    handles.ret_height, ...
    handles.ret_RCS_Profi, ...
    handles.ret_mol_RCS_Profi, ...
    'scale', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value}, ...
    'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], ...
    'RCSRange', [str2double(handles.RCS_bottom_tb.String), str2double(handles.RCS_top_tb.String)]);

% bsc profile
display_bsc_profi(handles.ret_bsc_lineplot_axes, ...
    handles.ret_height, ...
    handles.ret_bsc_Profi * 1e6, ...
    'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], ...
    'aerBscRange', [str2double(handles.bsc_bottom_tb.String), str2double(handles.bsc_top_tb.String)], ...
    'dustBsc', handles.ret_bsc_d_Profi * 1e6, ...
    'nondustBsc', handles.ret_bsc_nd_Profi * 1e6);

% depol profile
display_depol_profi(handles.ret_depol_lineplot_axes, ...
    handles.ret_height, ...
    handles.ret_VDR_Profi, ...
    handles.ret_PDR_Profi, ...
    'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], ...
    'DepolRange', [str2double(handles.VDR_bottom_tb.String), str2double(handles.VDR_top_tb.String)]);

% mass profile
display_mass_profi(handles.ret_mass_lineplot_axes, ...
    handles.ret_height, ...
    handles.ret_mass_nd_Profi * 1e9, ...
    handles.ret_mass_d_Profi * 1e9, ...
    'hRange', [str2double(handles.ret_H_bottom_tb.String), str2double(handles.ret_H_top_tb.String)], ...
    'massRange', [str2double(handles.mass_bottom_tb.String), str2double(handles.mass_top_tb.String)]);

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
    'Yes','No','Cancel');

% Handle response
switch choice
case 'Yes'
    delete(handles.infoFile_tb.String);

    logPrint(handles.log_tb, sprintf('[%s] Deleted %s', tNow(), handles.infoFile_tb.String));

case 'Cancel'

    logPrint(handles.log_tb, sprintf('[%s] Cancelled to delete %s', tNow(), handles.infoFile_tb.String));

case 'No'
    % do nothing

end


% --- Executes on key press with focus on infoFile_tb and none of its controls.
function infoFile_tb_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to infoFile_tb (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

switch eventdata.Key
case 'return'
    handles.infoFile = handles.infoFile_tb.String;

    % read infos
    try
        load(handles.infoFile);
    catch
        logPrint(handles.log_tb, sprintf('error in loading infoFile: %s', handles.infoFile_tb.String));
        return;
    end

    progInfo = programInfo();
    if ~ strcmp(metadata.processor_version, progInfo.Version)
        logPrint(handles.log_tb, sprintf('[%s] Incompatible version\nVersion (infoFile): %s;\nVersion (working): %s;\nIssues may happen! Try to download the suitable version at https://github.com/ZPYin/cloud_evaluation_GUI/releases', tNow(), metadata.processor_version, progInfo.Version));
    end

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
    if ~ isfield(widgetInfo, 'offset')
        handles.offset_tb.String = '0.000';
    else
        handles.offset_tb.String = widgetInfo.offset;
    end
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
    if ~ isfield(widgetInfo, 'cmap')
        handles.cmap_pm.Value = 1;
    else
        handles.cmap_pm.Value = find(strcmpi(handles.cmap_pm.String, widgetInfo.cmap));
    end
    handles.RCS_scale_pm.Value = find(strcmpi(handles.RCS_scale_pm.String, widgetInfo.RCS_scale));
    handles.RCS_bottom_tb.String = widgetInfo.RCS_bottom;
    handles.RCS_top_tb.String = widgetInfo.RCS_top;
    handles.VDR_bottom_tb.String = widgetInfo.VDR_bottom;
    handles.VDR_top_tb.String = widgetInfo.VDR_top;
    handles.Temp_bottom_tb.String = widgetInfo.Temp_bottom;
    handles.Temp_top_tb.String = widgetInfo.Temp_top;

    logPrint(handles.log_tb, sprintf('[%s] load info file successfully!', tNow()));

end

guidata(hObject, handles);


% --------------------------------------------------------------------
function uiROIBox_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uiROIBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles, 'rect_RCS')
    delete(handles.rect_RCS);
end

if isfield(handles, 'rect_VDR')
    delete(handles.rect_VDR);
end

% Change mouse pointer (cursor) to an cross.
set(gcf, 'Pointer', 'cross');
drawnow;  % Cursor won't change right away unless you do this.

[startPos, endPos, handles.rect_RCS, handles.rect_VDR] = rubberbandbox(handles.RCS_colorplot_axes, handles.VDR_colorplot_axes);

cloud_startT = min([startPos(1), endPos(1)]);
cloud_stopT = max([startPos(1), endPos(1)]);
cloud_baseH = min([startPos(2), endPos(2)]);
cloud_topH = max([startPos(2), endPos(2)]);

handles.cloud_start_tb.String = datestr(cloud_startT, 'yyyy-mm-dd HH:MM:SS');
handles.cloud_stop_tb.String = datestr(cloud_stopT, 'yyyy-mm-dd HH:MM:SS');
handles.cloud_base_tb.String = sprintf('%6.3f', cloud_baseH);
handles.cloud_top_tb.String = sprintf('%6.3f', cloud_topH);

% Change mouse pointer (cursor) to an arrow.
set(gcf, 'Pointer', 'arrow');
drawnow;  % Cursor won't change right away unless you do this.

handles.uiROIBox.State = 'off';

guidata(hObject, handles);


% --------------------------------------------------------------------

% hObject    handle to uiROIBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uitoggletool3_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uitoggletool5_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function file_menu_Callback(hObject, eventdata, handles)
% hObject    handle to file_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function edit_menu_Callback(hObject, eventdata, handles)
% hObject    handle to edit_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function tools_menu_Callback(hObject, eventdata, handles)
% hObject    handle to tools_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function tutorial_Callback(hObject, eventdata, handles)
% hObject    handle to tutorial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

web('https://github.com/ZPYin/cloud_evaluation_GUI/wiki', '-browser')

% --------------------------------------------------------------------
function update_Callback(hObject, eventdata, handles)
% hObject    handle to update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

web('https://github.com/ZPYin/cloud_evaluation_GUI/releases', '-browser');

% --------------------------------------------------------------------
function version_Callback(hObject, eventdata, handles)
% hObject    handle to version (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

progInfo = programInfo();
h = msgbox({sprintf('Authors: %s', progInfo.Author), sprintf('Version: %s', progInfo.Version), sprintf('%s', progInfo.Description)}, 'About');


% --------------------------------------------------------------------
function convert_mat_2_ascii_Callback(hObject, eventdata, handles)
% hObject    handle to convert_mat_2_ascii (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cloudCaseDir = uigetdir(handles.settings.dataDir, 'Choose the cloud case directory...');

if isequal(cloudCaseDir, 0)
    logPrint(handles.log_tb, sprintf('[%s] No directory was selected!', tNow()));
else
    cloudCases = listfile(cloudCaseDir, '\w*.mat');

    if isempty(cloudCases)
        logPrint(handles.log_tb, sprintf('[%s] No cloud cases were found!', tNow()));

        return;
    end

    for iCase = 1:length(cloudCases)
        logPrint(handles.log_tb, sprintf('Finished %6.2f%%: Starting %s', (iCase - 1)/length(cloudCases) * 100, cloudCases{iCase}));

        matFile = cloudCases{iCase};
        txtFile = [rmext(matFile), '.txt'];

        convert_mat_2_txt(matFile, txtFile);
    end
end

% --------------------------------------------------------------------
function open_cloudcase_Callback(hObject, eventdata, handles)
% hObject    handle to open_cloudcase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[infoFile, infoPath] = uigetfile(fullfile(handles.settings.saveDir, '*.mat'), 'Select info file...');
handles.infoFile = fullfile(infoPath, infoFile);

if infoFile ~= 0
    handles.infoFile_tb.String = sprintf('%s', fullfile(infoPath, infoFile));

    % read infos
    load(handles.infoFile);

    progInfo = programInfo();
    if ~ strcmp(metadata.processor_version, progInfo.Version)
        logPrint(handles.log_tb, sprintf('[%s] Incompatible version\nVersion (infoFile): %s;\nVersion (working): %s;\nIssues may happen! Try to download the suitable version at https://github.com/ZPYin/cloud_evaluation_GUI/releases', tNow(), metadata.processor_version, progInfo.Version));
    end

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
    if ~ isfield(widgetInfo, 'offset')
        handles.offset_tb.String = '0.000';
    else
        handles.offset_tb.String = widgetInfo.offset;
    end
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
    if ~ isfield(widgetInfo, 'cmap')
        handles.cmap_pm.Value = 1;
    else
        handles.cmap_pm.Value = find(strcmpi(handles.cmap_pm.String, widgetInfo.cmap));
    end
    handles.RCS_scale_pm.Value = find(strcmpi(handles.RCS_scale_pm.String, widgetInfo.RCS_scale));
    handles.RCS_bottom_tb.String = widgetInfo.RCS_bottom;
    handles.RCS_top_tb.String = widgetInfo.RCS_top;
    handles.VDR_bottom_tb.String = widgetInfo.VDR_bottom;
    handles.VDR_top_tb.String = widgetInfo.VDR_top;
    handles.Temp_bottom_tb.String = widgetInfo.Temp_bottom;
    handles.Temp_top_tb.String = widgetInfo.Temp_top;

    logPrint(handles.log_tb, sprintf('[%s] load info file successfully!', tNow()));
    handles.infoFile_tb.String = handles.infoFile;
end

guidata(hObject, handles);


% --------------------------------------------------------------------
function save_cloudcase_Callback(hObject, eventdata, handles)
% hObject    handle to save_cloudcase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cloud_starttime = datenum(handles.cloud_start_tb.String, 'yyyy-mm-dd HH:MM:SS');
cloud_stoptime = datenum(handles.cloud_stop_tb.String, 'yyyy-mm-dd HH:MM:SS');

saveFile = fullfile(handles.settings.saveDir, ...
    sprintf('cloud_eval_output_%s-%s_%05d-%05d_sm%04d.mat', ...
        datestr(cloud_starttime, 'yyyymmdd_HHMM'), ...
        datestr(cloud_stoptime, 'yyyymmdd_HHMM'), ...
        int32(str2double(handles.cloud_base_tb.String) * 1000), ...
        int32(str2double(handles.cloud_top_tb.String) * 1000), ...
        str2double(handles.smoothwin_tb.String)));

save_2_mat(handles, saveFile);

%% update status
logPrint(handles.log_tb, sprintf('[%s] Results have been saved to %s', tNow, saveFile));

guidata(hObject, handles);

% --------------------------------------------------------------------
function saveas_cloudcase_Callback(hObject, eventdata, handles)
% hObject    handle to saveas_cloudcase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[saveFile, savePath, fileExtIndx] = uiputfile({'*.mat'; '*.txt'}, 'Save the cloud case as ...');

if isequal(saveFile, 0)
    logPrint(handles.log_tb, sprintf('[%s] Cancel saving the cloud case!', tNow()));
else
    logPrint(handles.log_tb, sprintf('[%s] Save the cloud case to %s', tNow(), saveFile));
end

switch fileExtIndx
case 1   % mat file
    save_2_mat(handles, fullfile(savePath, saveFile));
case 2   % txt file
    save_2_txt(handles, fullfile(savePath, saveFile));
otherwise
    % do nothing
end

guidata(hObject, handles);

% --------------------------------------------------------------------
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(hObject);


% --------------------------------------------------------------------
function bug_report_Callback(hObject, eventdata, handles)
% hObject    handle to bug_report (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

web('https://github.com/ZPYin/cloud_evaluation_GUI/issues', '-browser');


% --------------------------------------------------------------------
function save_retrieval_Callback(hObject, eventdata, handles)
% hObject    handle to save_retrieval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ret_starttime = datenum(handles.ret_starttime_tb.String, 'yyyy-mm-dd HH:MM:SS');
ret_stoptime = datenum(handles.ret_stoptime_tb.String, 'yyyy-mm-dd HH:MM:SS');

defaultFilename = fullfile(handles.settings.saveDir, ...
    sprintf('averaged_profile_%s-%s_%05d-%05d_sm%04d.h5', ...
        datestr(ret_starttime, 'yyyymmdd_HHMM'), ...
        datestr(ret_stoptime, 'yyyymmdd_HHMM'), ...
        int32(str2double(handles.ret_H_bottom_tb.String) * 1000), ...
        int32(str2double(handles.ret_H_top_tb.String) * 1000), ...
        str2double(handles.smoothwin_tb.String)));
[saveFile, savePath, fileExtIndx] = uiputfile({'*.h5';}, 'Save the retrieving results as ...', defaultFilename);

if isequal(saveFile, 0)
    logPrint(handles.log_tb, sprintf('[%s] Cancel saving the retrieving results!', tNow()));
else
    logPrint(handles.log_tb, sprintf('[%s] Save the retrieving results to %s', tNow(), saveFile));
end

switch fileExtIndx
case 1   % mat file
    save_retrieval_2_h5(handles, fullfile(savePath, saveFile));
otherwise
    % do nothing
end

guidata(hObject, handles);


% --------------------------------------------------------------------
function uiROIBox_OnCallback(hObject, eventdata, handles)
% hObject    handle to uiROIBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uitoggletool2_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function sliceTool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to sliceTool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles, 'sliceLine_RCS')
    delete(handles.sliceLine_RCS);
end

if isfield(handles, 'sliceLine_VDR')
    delete(handles.sliceLine_VDR);
end

% Change mouse pointer (cursor) to an cross.
set(gcf, 'Pointer', 'hand');
drawnow;  % Cursor won't change right away unless you do this.

[linePos, handles.sliceLine_RCS, handles.sliceLine_VDR] = draw_slice_line('ax1', handles.RCS_colorplot_axes, ...
    'ax2', handles.VDR_colorplot_axes, ...
    'color', 'r', ...
    'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)]);

% Change mouse pointer (cursor) to an arrow.
set(gcf, 'Pointer', 'arrow');
drawnow;  % Cursor won't change right away unless you do this.

% draw signal profile
profiTime = linePos(1);
[Temp_Profi, Pres_Profi, RH_Profi] = read_meteordata(profiTime - datenum(0, 1, 0, 8, 0, 0), ...
    handles.lidarData.altitude, ...
    'meteor_data', handles.meteor_data_pm.String{handles.meteor_data_pm.Value}, ...
    'station', handles.settings.station, ...
    'GDAS1Folder', handles.settings.GDAS1Dir, ...
    'RadiosondeFolder', handles.settings.soundingDir, ...
    'ERA5Folder', handles.settings.ERA5Dir);

[minLapse, tIndx] = min(abs(handles.lidarData.time - profiTime));
if minLapse < datenum(0, 1, 0, 0, 1, 0)
    profiIndx = tIndx;

    profiTime = handles.lidarData.time(tIndx);
else
    logPrint(handles.log_tb, sprintf('[%s] No profile can be found!', tNow()));
    handles.sliceTool.State = 'off';

    guidata(hObject, handles);
    return
end

CH1_Sig_Profi = transpose(handles.lidarData.sigCH1(:, profiIndx));
CH1_BG_Profi = handles.lidarData.BGCH1(profiIndx) * ones(1, length(handles.lidarData.height));
CH2_Sig_Profi = transpose(handles.lidarData.sigCH2(:, profiIndx));
BGCH2_Profi = handles.lidarData.BGCH2(profiIndx) * ones(1, length(handles.lidarData.height));
elSig_Profi = (CH1_Sig_Profi + str2double(handles.gainRatio_tb.String) .* CH2_Sig_Profi) .* handles.lidarData.height .^ 2;
VDR_Profi = str2double(handles.gainRatio_tb.String) .* CH2_Sig_Profi ./ CH1_Sig_Profi - str2double(handles.offset_tb.String);

display_sliceLine_profile(profiTime, ...
    handles.lidarData.height / 1e3, ...
    CH1_Sig_Profi, CH1_BG_Profi, ...
    CH2_Sig_Profi, BGCH2_Profi, ...
    elSig_Profi, VDR_Profi, Temp_Profi, Pres_Profi, RH_Profi, ...
    'RCSRange', [str2double(handles.RCS_bottom_tb.String), str2double(handles.RCS_top_tb.String)], ...
    'RCS_Scale', handles.RCS_scale_pm.String{handles.RCS_scale_pm.Value}, ...
    'VDR_Range', [str2double(handles.VDR_bottom_tb.String), str2double(handles.VDR_top_tb.String)], ...
    'RH_Range', [0, 100], ...
    'Temp_Range', [str2double(handles.Temp_bottom_tb.String), str2double(handles.Temp_top_tb.String)], ...
    'hRange', [str2double(handles.H_base_tb.String), str2double(handles.H_top_tb.String)]);

handles.sliceTool.State = 'off';

guidata(hObject, handles);



function offset_tb_Callback(hObject, eventdata, handles)
% hObject    handle to offset_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of offset_tb as text
%        str2double(get(hObject,'String')) returns contents of offset_tb as a double


% --- Executes during object creation, after setting all properties.
function offset_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offset_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wavelength_tb_Callback(hObject, eventdata, handles)
% hObject    handle to wavelength_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wavelength_tb as text
%        str2double(get(hObject,'String')) returns contents of wavelength_tb as a double


% --- Executes during object creation, after setting all properties.
function wavelength_tb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wavelength_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
