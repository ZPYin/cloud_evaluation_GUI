function [output1, varargout] = error_config_gui(input1, varargin)
% ERROR_CONFIG_GUI MATLAB code for error_config_gui.fig
%      ERROR_CONFIG_GUI, by itself, creates a new ERROR_CONFIG_GUI or raises the existing
%      singleton*.
%
%      H = ERROR_CONFIG_GUI returns the handle to a new ERROR_CONFIG_GUI or the handle to
%      the existing singleton*.
%
%      ERROR_CONFIG_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ERROR_CONFIG_GUI.M with the given input arguments.
%
%      ERROR_CONFIG_GUI('Property','Value',...) creates a new ERROR_CONFIG_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before error_config_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to error_config_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help error_config_gui

% Last Modified by GUIDE v2.5 15-Aug-2023 15:53:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @error_config_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @error_config_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

output1 = input1;
% End initialization code - DO NOT EDIT


% --- Executes just before error_config_gui is made visible.
function error_config_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to error_config_gui (see VARARGIN)

% Choose default command line output for error_config_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes error_config_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = error_config_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function tbxLRError_Callback(hObject, eventdata, handles)
% hObject    handle to tbxLRError (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbxLRError as text
%        str2double(get(hObject,'String')) returns contents of tbxLRError as a double


% --- Executes during object creation, after setting all properties.
function tbxLRError_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbxLRError (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbxRefValError_Callback(hObject, eventdata, handles)
% hObject    handle to tbxRefValError (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbxRefValError as text
%        str2double(get(hObject,'String')) returns contents of tbxRefValError as a double


% --- Executes during object creation, after setting all properties.
function tbxRefValError_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbxRefValError (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
