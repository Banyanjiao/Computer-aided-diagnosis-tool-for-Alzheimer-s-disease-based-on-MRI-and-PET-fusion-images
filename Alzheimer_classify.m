function varargout = Alzheimer_classify(varargin)
% ALZHEIMER_CLASSIFY MATLAB code for Alzheimer_classify.fig
%      ALZHEIMER_CLASSIFY, by itself, creates a new ALZHEIMER_CLASSIFY or raises the existing
%      singleton*.
%
%      H = ALZHEIMER_CLASSIFY returns the handle to a new ALZHEIMER_CLASSIFY or the handle to
%      the existing singleton*.
%
%      ALZHEIMER_CLASSIFY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ALZHEIMER_CLASSIFY.M with the given input arguments.
%
%      ALZHEIMER_CLASSIFY('Property','Value',...) creates a new ALZHEIMER_CLASSIFY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Alzheimer_classify_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Alzheimer_classify_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Alzheimer_classify

% Last Modified by GUIDE v2.5 05-Mar-2021 16:56:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Alzheimer_classify_OpeningFcn, ...
                   'gui_OutputFcn',  @Alzheimer_classify_OutputFcn, ...
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


% --- Executes just before Alzheimer_classify is made visible.
function Alzheimer_classify_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Alzheimer_classify (see VARARGIN)

% Choose default command line output for Alzheimer_classify
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Alzheimer_classify wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Alzheimer_classify_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
disp('Select MRI Image')
[fname,pname,index]=uigetfile({'*.jpg;*.bmp;*.png;*.tif;*.gif;*.jpeg'},'Select MRI Image');
if index
    name=[pname fname];
    temp=imread(name);
    [m,n]=size(temp);
    m=num2str(m);
    n=num2str(n);
    imsize=['  ',m,'*',n];
    handles.ImsizeI=imsize;
    handles.filenameI=name;
    handles.names_dispI=[fname,imsize];
end
guidata(hObject,handles);

disp('Show MRI Image')
axes(handles.axes1)
I=imread(handles.filenameI);
imshow(I)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
disp('Select the Corresponding  PET Image')
[fname,pname,index]=uigetfile({'*.jpg;*.bmp;*.png;*.tif;*.gif;*.jpeg'},'Select the Corresponding  PET Image');
if index
    name=[pname fname];
    temp=imread(name);
    [m,n]=size(temp);
    m=num2str(m);
    n=num2str(n);
    imsize=['  ',m,'*',n];
    handles.ImsizeJ=imsize;
    handles.filenameJ=name;
    handles.names_dispJ=[fname,imsize];
end
img_name = char(fname);
picname = img_name(1:2);
   if strcmp(picname,'AD')==1
      set(handles.edit4,'string','AD');
   elseif strcmp(picname,'CN')==1
      set(handles.edit4,'string','CN');
   else
      set(handles.edit4,'string','MCI');
   end
guidata(hObject,handles);

disp('Show PET Image')
axes(handles.axes2)
J=imread(handles.filenameJ);
imshow(J)

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
disp('Check whether the reference image and floating image have been input')
axesIbox=get(handles.axes1,'box');
axesJbox=get(handles.axes2,'box');
if strcmp(axesIbox,'off')||strcmp(axesJbox,'off')
    errordlg('Please select Image for Registration','Error')
    error('NO Image!')
end

disp('Load the image')
II=imread(handles.filenameI);
JI=imread(handles.filenameJ);
handles.Old_I=II;
handles.Old_J=JI;
I=II;
J=JI;
handles.I=I;
handles.J=J;
handles.ImgDatam = II;
handles.ImgDatap = JI;
guidata(hObject,handles);

disp('Fusion Image')
tic
FusionImage=Fusion(handles);
toc
ElapsedTime=toc;

disp('Show the fusion result')
axes(handles.axes3)
imshow(FusionImage)
imwrite(FusionImage,'fusion.png');
set(handles.edit5,'String',ElapsedTime);

imgf = imread('fusion.png');
handles.ImgData = imgf;
guidata(hObject,handles);


% --- Executes on button press in pushbutton5.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'ImgData')
   load ('D:\matlab\my\GUI\net\res18_net.mat');
   load ('D:\matlab\my\GUI\net\res18_netm.mat');
   load ('D:\matlab\my\GUI\net\res18_netp.mat');
   
   net = res18_net;
   netm = res18_netm;
   netp = res18_netp;
   inputSize = net.Layers(1).InputSize;
   
   img = handles.ImgData;
   imgm = handles.ImgDatam;
   imgp = handles.ImgDatap;
   
   img = imresize(img,inputSize(1:2));
   imgm = imresize(imgm,inputSize(1:2));
   imgp = imresize(imgp,inputSize(1:2));
   
   result = classify(net,img);
   resultm = classify(netm,imgm);
   resultp = classify(netp,imgp);
   
   pic = char(result);
   pic1 = char(resultm);
   pic2 = char(resultp);
   
   picf = pic(1:2);
   if strcmp(picf,'AD')==1
      set(handles.edit3,'string','AD');
   elseif strcmp(picf,'CN')==1
      set(handles.edit3,'string','CN');
   else
      set(handles.edit3,'string','MCI');
   end
   
   picm = pic1(1:2);
   if strcmp(picm,'AD')==1
      set(handles.edit1,'string','AD');
   elseif strcmp(picm,'CN')==1
      set(handles.edit1,'string','CN');
   else
      set(handles.edit1,'string','MCI');
   end
   
   picp = pic2(1:2);
   if strcmp(picp,'AD')==1
      set(handles.edit2,'string','AD');
   elseif strcmp(picp,'CN')==1
      set(handles.edit2,'string','CN');
   else
      set(handles.edit2,'string','MCI');
   end
   
end


% --- Executes on button press in pushbutton6.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'ImgData')
   load ('D:\matlab\my\GUI\net\res50_net.mat');
   load ('D:\matlab\my\GUI\net\res50_netm.mat');
   load ('D:\matlab\my\GUI\net\res50_netp.mat');
   
   net = res50_net;
   netm = res50_netm;
   netp = res50_netp;
   inputSize = net.Layers(1).InputSize;
   
   img = handles.ImgData;
   imgm = handles.ImgDatam;
   imgp = handles.ImgDatap;
   
   img = imresize(img,inputSize(1:2));
   imgm = imresize(imgm,inputSize(1:2));
   imgp = imresize(imgp,inputSize(1:2));
   
   result = classify(net,img);
   resultm = classify(netm,imgm);
   resultp = classify(netp,imgp);
   
   pic = char(result);
   pic1 = char(resultm);
   pic2 = char(resultp);
   picf = pic(1:2);
   if picf == 'AD'
      set(handles.edit3,'string','AD');
   elseif picf == 'CN'
      set(handles.edit3,'string','CN');
   else
      set(handles.edit3,'string','MCI');
   end
   
   picm = pic1(1:2);
   if picm == 'AD'
      set(handles.edit1,'string','AD');
   elseif picm == 'CN'
      set(handles.edit1,'string','CN');
   else
      set(handles.edit1,'string','MCI');
   end
   
   picp = pic2(1:2);
   if picp == 'AD'
      set(handles.edit2,'string','AD');
   elseif picp == 'CN'
      set(handles.edit2,'string','CN');
   else
      set(handles.edit2,'string','MCI');
   end
   
end


% --- Executes on button press in pushbutton7.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'ImgData')
   load ('D:\matlab\my\GUI\net\res101_net.mat');
   load ('D:\matlab\my\GUI\net\res101_netm.mat');
   load ('D:\matlab\my\GUI\net\res101_netp.mat');
   
   net = res101_net;
   netm = res101_netm;
   netp = res101_netp;
   inputSize = net.Layers(1).InputSize;
   
   img = handles.ImgData;
   imgm = handles.ImgDatam;
   imgp = handles.ImgDatap;
   
   img = imresize(img,inputSize(1:2));
   imgm = imresize(imgm,inputSize(1:2));
   imgp = imresize(imgp,inputSize(1:2));
   
   result = classify(net,img);
   resultm = classify(netm,imgm);
   resultp = classify(netp,imgp);
   
   pic = char(result);
   pic1 = char(resultm);
   pic2 = char(resultp);
   picf = pic(1:2);
   if picf == 'AD'
      set(handles.edit3,'string','AD');
   elseif picf == 'CN'
      set(handles.edit3,'string','CN');
   else
      set(handles.edit3,'string','MCI');
   end
   
   picm = pic1(1:2);
   if picm == 'AD'
      set(handles.edit1,'string','AD');
   elseif picm == 'CN'
      set(handles.edit1,'string','CN');
   else
      set(handles.edit1,'string','MCI');
   end
   
   picp = pic2(1:2);
   if picp == 'AD'
      set(handles.edit2,'string','AD');
   elseif picp == 'CN'
      set(handles.edit2,'string','CN');
   else
      set(handles.edit2,'string','MCI');
   end
   
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'ImgData')
   load ('D:\matlab\my\GUI\net\google_net.mat');
   load ('D:\matlab\my\GUI\net\google_netm.mat');
   load ('D:\matlab\my\GUI\net\google_netp.mat');
   
   net = google_net;
   netm = google_netm;
   netp = google_netp;
   inputSize = net.Layers(1).InputSize;
   
   img = handles.ImgData;
   imgm = handles.ImgDatam;
   imgp = handles.ImgDatap;
   
   img = imresize(img,inputSize(1:2));
   imgm = imresize(imgm,inputSize(1:2));
   imgp = imresize(imgp,inputSize(1:2));
   
   result = classify(net,img)
   resultm = classify(netm,imgm)
   resultp = classify(netp,imgp)
   
   pic = char(result);
   pic1 = char(resultm);
   pic2 = char(resultp);
   picf = pic(1:2);
   if picf == 'AD'
      set(handles.edit3,'string','AD');
   elseif picf == 'CN'
      set(handles.edit3,'string','CN');
   else
      set(handles.edit3,'string','MCI');
   end
   
   picm = pic1(1:2);
   if picm == 'AD'
      set(handles.edit1,'string','AD');
   elseif picm == 'CN'
      set(handles.edit1,'string','CN');
   else
      set(handles.edit1,'string','MCI');
   end
   
   picp = pic2(1:2);
   if picp == 'AD'
      set(handles.edit2,'string','AD');
   elseif picp == 'CN'
      set(handles.edit2,'string','CN');
   else
      set(handles.edit2,'string','MCI');
   end
   
end


% --- Executes on button press in pushbutton4.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'ImgData')
   load ('D:\matlab\my\GUI\net\squeeze_net.mat');
   load ('D:\matlab\my\GUI\net\squeeze_netm.mat');
   load ('D:\matlab\my\GUI\net\squeeze_netp.mat');
   
   net = squeeze_net;
   netm = squeeze_netm;
   netp = squeeze_netp;
   inputSize = net.Layers(1).InputSize;
   
   img = handles.ImgData;
   imgm = handles.ImgDatam;
   imgp = handles.ImgDatap;
   
   img = imresize(img,inputSize(1:2));
   imgm = imresize(imgm,inputSize(1:2));
   imgp = imresize(imgp,inputSize(1:2));
   
   result = classify(net,img);
   resultm = classify(netm,imgm);
   resultp = classify(netp,imgp);
   
   pic = char(result);
   pic1 = char(resultm);
   pic2 = char(resultp);
   picf = pic(1:2);
   if picf == 'AD'
      set(handles.edit3,'string','AD');
   elseif picf == 'CN'
      set(handles.edit3,'string','CN');
   else
      set(handles.edit3,'string','MCI');
   end
   
   picm = pic1(1:2);
   if picm == 'AD'
      set(handles.edit1,'string','AD');
   elseif picm == 'CN'
      set(handles.edit1,'string','CN');
   else
      set(handles.edit1,'string','MCI');
   end
   
   picp = pic2(1:2);
   if picp == 'AD'
      set(handles.edit2,'string','AD');
   elseif picp == 'CN'
      set(handles.edit2,'string','CN');
   else
      set(handles.edit2,'string','MCI');
   end
   
end



% --- Executes on button press in pushbutton4.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'ImgData')
   load ('D:\matlab\my\GUI\net\shuffle_net.mat');
   load ('D:\matlab\my\GUI\net\shuffle_netm.mat');
   load ('D:\matlab\my\GUI\net\shuffle_netp.mat');
   
   net = shuffle_net;
   netm = shuffle_netm;
   netp = shuffle_netp;
   inputSize = net.Layers(1).InputSize;
   
   img = handles.ImgData;
   imgm = handles.ImgDatam;
   imgp = handles.ImgDatap;
   
   img = imresize(img,inputSize(1:2));
   imgm = imresize(imgm,inputSize(1:2));
   imgp = imresize(imgp,inputSize(1:2));
   
   result = classify(net,img);
   resultm = classify(netm,imgm);
   resultp = classify(netp,imgp);
   
   pic = char(result);
   pic1 = char(resultm);
   pic2 = char(resultp);
   picf = pic(1:2);
   if picf == 'AD'
      set(handles.edit3,'string','AD');
   elseif picf == 'CN'
      set(handles.edit3,'string','CN');
   else
      set(handles.edit3,'string','MCI');
   end
   
   picm = pic1(1:2);
   if picm == 'AD'
      set(handles.edit1,'string','AD');
   elseif picm == 'CN'
      set(handles.edit1,'string','CN');
   else
      set(handles.edit1,'string','MCI');
   end
   
   picp = pic2(1:2);
   if picp == 'AD'
      set(handles.edit2,'string','AD');
   elseif picp == 'CN'
      set(handles.edit2,'string','CN');
   else
      set(handles.edit2,'string','MCI');
   end
   
end


function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'ImgData')
   load ('D:\matlab\my\GUI\net\densenet201_net.mat');
   load ('D:\matlab\my\GUI\net\densenet201_netm.mat');
   load ('D:\matlab\my\GUI\net\densenet201_netp.mat');
   
   net = dense201_net;
   netm = dense201_netm;
   netp = dense201_netp;
   inputSize = net.Layers(1).InputSize;
   
   img = handles.ImgData;
   imgm = handles.ImgDatam;
   imgp = handles.ImgDatap;
   
   img = imresize(img,inputSize(1:2));
   imgm = imresize(imgm,inputSize(1:2));
   imgp = imresize(imgp,inputSize(1:2));
   
   result = classify(net,img);
   resultm = classify(netm,imgm);
   resultp = classify(netp,imgp);
   
   pic = char(result);
   pic1 = char(resultm);
   pic2 = char(resultp);
   picf = pic(1:2);
   if picf == 'AD'
      set(handles.edit3,'string','AD');
   elseif picf == 'CN'
      set(handles.edit3,'string','CN');
   else
      set(handles.edit3,'string','MCI');
   end
   
   picm = pic1(1:2);
   if picm == 'AD'
      set(handles.edit1,'string','AD');
   elseif picm == 'CN'
      set(handles.edit1,'string','CN');
   else
      set(handles.edit1,'string','MCI');
   end
   
   picp = pic2(1:2);
   if picp == 'AD'
      set(handles.edit2,'string','AD');
   elseif picp == 'CN'
      set(handles.edit2,'string','CN');
   else
      set(handles.edit2,'string','MCI');
   end
   
end


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 重置清空图片
choice=questdlg('Do you want to clear all？','Clear','Yes','No','No')%问题对话框，默认为No
switch choice,
    case 'Yes'
        cla(handles.axes1,'reset');
        cla(handles.axes2,'reset');
        cla(handles.axes3,'reset');

        % 重置清空动态txt的文字 
        set(handles.edit1,'string','')
        set(handles.edit2,'string','')
        set(handles.edit3,'string','')
        set(handles.edit4,'string','')
        set(handles.edit5,'string','')
        return;
    case 'No'
        return;
end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choice=questdlg('Do you want to close it？','Close','Yes','No','No')%问题对话框，默认为No
switch choice,
    case 'Yes'
        close;
        return;
    case 'No'
        return;
end
