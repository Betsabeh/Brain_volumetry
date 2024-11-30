function varargout = mine(varargin)
% mine M-file for mine.fig
%      mine, by itself, creates a new mine or raises the existing
%      singleton*.
%
%      H = mine returns the handle to a new mine or the handle to
%      the existing singleton*.
%
%      mine('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in mine.M with the given input arguments.
%
%      mine('Property','Value',...) creates a new mine or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mine_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mine_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help mine

% Last Modified by GUIDE v2.5 05-Feb-2008 11:29:19

% Begin initialization code - DO NOT EDIT
clc
mypath;
global image
global removed_image
global nimage
global slice_num
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mine_OpeningFcn, ...
                   'gui_OutputFcn',  @mine_OutputFcn, ...
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


% --- Executes just before mine is made visible.
function mine_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mine (see VARARGIN)

% Choose default command line output for mine
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mine wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mine_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global slice_num
slice_num=get(handles.edit1, 'string');
global image
image=image_show(handles,1,str2double(slice_num));
images = mireadimages ('c:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',str2double(slice_num));
global nimage
nimage = reshape (images, 181, 217);
%figure,
% [fig_handle, image_handle, bar_handle] = viewimage (nimage)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
global image
thresholded_image=otsu(image,2);
se=strel('disk',4);
im=imclose(double(thresholded_image),se);
im=imfill(im,4,'holes');
im=double(im);
[o,p]=find(im==1);
[v_i_1,i]=max(o);
[v_i_2,i]=min(o);
width=v_i_1-v_i_2;
[v_j_1,i]=max(p);
[v_j_2,i]=min(p);
height=v_j_1-v_j_2;
global removed_image
global slice_num
removed_image = activecontour( image, [90 110], 60, 1, 5, 5, 'te',str2double(slice_num ));
%%removed_image=level_set(image,width,height,v_i_2,v_j_2);
axes(handles.axes2);
imshow(removed_image',[])
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
global removed_image
global nimage
[white,csf,gry]=segment2(removed_image,nimage);
axes(handles.axes3);
imshow(white',[])
axes(handles.axes4);
imshow(csf',[])
axes(handles.axes5);
imshow(gry',[])

% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


