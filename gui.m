function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 31-Jan-2020 11:47:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
addpath('Database')
addpath('functions')

% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
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
clc;
load net
axes(handles.axes1);imshow(255)
axes(handles.axes2);imshow(255)
axes(handles.axes3);imshow(255);
set(handles.edit1,'String',num2str(''));
set(handles.edit2,'String',num2str(''));
set(handles.edit4,'String',num2str(''));
set(handles.edit6,'String',num2str(''));
set(handles.edit8,'String',num2str(''));
set(handles.edit12,'String',num2str(''));
set(handles.edit13,'String',num2str(''));
set(handles.edit14,'String',num2str(''));
set(handles.edit15,'String',num2str(''));
set(handles.edit16,'String',num2str(''));
set(handles.edit17,'String',num2str(''));
[f,p] = uigetfile('*.*','Load Image');
IR=imread([p,f]);
[rows, columns, numberOfColorChannels] = size(IR);
if numberOfColorChannels > 1
    IR = rgb2gray(IR);
end
IR= imresize(IR, [475 575]);
set(handles.edit1,'String',num2str(f));
axes(handles.axes1);imshow(IR);
[f,p] = uigetfile('*.*','Load Image');
VIS=imread([p,f]);
[rows, columns, numberOfColorChannels] = size(VIS);
if numberOfColorChannels > 1
    VIS = rgb2gray(VIS);
end
 VIS= imresize(VIS, [475 575]);
axes(handles.axes2);imshow(VIS);
pause(0.5);
%====================Iteration 1===========================================
irgf_d1 = im2double(imgaussfilt(IR,0.01));
visgf_d1=im2double(imgaussfilt(VIS,0.01));
ir_jbf_d1=im2double(jbfltGray(irgf_d1,irgf_d1,0.1,0.2,3));
vis_jbf_d1=im2double(jbfltGray(visgf_d1,visgf_d1,0.1,0.2,3));
%====================Iteration 2===========================================
irgf_d2 = im2double(imgaussfilt(ir_jbf_d1,0.01));
visgf_d2=im2double(imgaussfilt(vis_jbf_d1,0.01));
ir_jbf_d2=im2double(jbfltGray(irgf_d2,irgf_d2,0.1,0.2,3));
vis_jbf_d2=im2double(jbfltGray(visgf_d2,visgf_d2,0.1,0.1,3));
%====================Iteration 3===========================================
irgf_d3 = im2double(imgaussfilt(ir_jbf_d2,0.01));
visgf_d3=im2double(imgaussfilt(vis_jbf_d2,0.01));
ir_jbf_d3=im2double(jbfltGray(irgf_d3,irgf_d3,0.1,0.2,3));
vis_jbf_d3=im2double(jbfltGray(visgf_d3,visgf_d3,0.1,0.2,3));
%====================Iteration 4===========================================
irgf_d4 = im2double(imgaussfilt(ir_jbf_d3,0.01));
visgf_d4=im2double(imgaussfilt(vis_jbf_d3,0.01));
ir_jbf_d4=im2double(jbfltGray(irgf_d4,irgf_d4,0.1,0.2,3));
vis_jbf_d4=im2double(jbfltGray(visgf_d4,visgf_d4,0.1,0.2,3));
% figure;imshow(ir_jbf_d4)
% figure;imshow(vis_jbf_d4)
%===================================high-pass image========================
HP_ir = locallapfilt(IR, 0.4, 0.5);
HP_vis= locallapfilt(VIS, 0.4, 0.5);
%===================================Low-pass image==========+==============
SM_ir=HP_ir;
SM_vis=HP_vis;
vOtype_1 = get(handles.radiobutton1,'Value');
vOtype_2 = get(handles.radiobutton2,'Value');
if(vOtype_2)
%==================================Initial Weight MAp======================
IWP_ir=zeros(size(SM_ir,1),size(SM_ir,2));
for i=1:size(SM_ir,1)
    for j=1:size(SM_ir,2)
        if(SM_ir(i,j)>(SM_vis(i,j)))
            IWP_ir(i,j)=1;
        else
            IWP_ir(i,j)=0;
        end
    end
end
IWP_vis=zeros(size(SM_vis,1),size(SM_vis,2));
for i=1:size(SM_vis,1)
    for j=1:size(SM_vis,2)
        if(SM_ir(i,j)<(SM_vis(i,j)))
            IWP_vis(i,j)=1;
        else
            IWP_vis(i,j)=0;
        end
    end
end
%==========================Final Weight Map================================
FWP_ir=imguidedfilter(IWP_ir,IR);
FWP_vis=imguidedfilter(IWP_vis,VIS);
%=========================Base Layer Fusion================================
B_fusion=FWP_ir.*im2double(irgf_d4)+FWP_vis.*im2double(visgf_d4);
%=========================Detailed Layer Fusion============================
A=padarray(ir_jbf_d4,[1,1],0,'both');
for m=2:size(A,1)-1
    for n=2:size(A,2)-1
        temp=A(m-1:m+1,n-1:n+1);
        avg_ir(m-1,n-1)=mean2(temp);
    end
end
I=padarray(vis_jbf_d4,[1,1],0,'both');
for m=2:size(I,1)-1
    for n=2:size(I,2)-1
        temp=I(m-1:m+1,n-1:n+1);
        avg_vis(m-1,n-1)=mean2(temp);
    end
end
en_devil=zeros(size(avg_ir,1),size(avg_ir,2));
for i=1:size(avg_ir,1)-1
    for j=1:size(avg_ir,2)-1
        en_devil(i,j)=((avg_ir(i,j))/(avg_ir(i,j)+avg_vis(i,j)));
    end
end
Th=0.6;
alpha=(Th/1+Th);
beta=((1/1)+Th);
a=zeros((size(en_devil,1)),(size(en_devil,2)));
for m=1:size(en_devil,1)
    for n=1:size(en_devil,2)
        if((en_devil(m,n))>=0.5 && (en_devil(m,n))<=beta)
            a(m,m)=(0.5+0.5*((1-2*en_devil(m,n) / (1-2*beta))));
        elseif((en_devil(m,n))>=0.5 && (en_devil(m,n))<=alpha)
            a(m,m)=(0.5-0.5*((1-2*en_devil(m,n) / (1-2*beta))));
        elseif((en_devil(m,n))>=0 && (en_devil(m,n))>=alpha)
            a(m,m)=0;
        elseif((en_devil(m,n))>= 1 && (en_devil(m,n))<=beta)
            a(m,m)=1;
        end
    end
    D_fusion=zeros((size(en_devil,1)),(size(en_devil,2)));
    for i=1:(size(en_devil,1))
        for j=1:(size(en_devil,2))
            D_fusion(i,j)=((1-(en_devil(i,j).*vis_jbf_d3(i,j))+((en_devil(i,j).*ir_jbf_d3(i,j)))));
        end
    end
end
IR = im2double(IR);
VIS = im2double(VIS);
B_fusion = NormalizeData(B_fusion);
D_fusion = NormalizeData(D_fusion);
B_fusion = B_fusion(:);
D_fusion = D_fusion(:);
input_all = [B_fusion,D_fusion];
x = input_all';
Fused_out = net(x);
Fused_out = reshape(Fused_out,size(IR,1),size(IR,2));
Fused_out_1 = imadjust(Fused_out);
axes(handles.axes3);imshow(Fused_out_1);
en = image_entropy(Fused_out);
model = brisqueModel(rand(10,1),47,rand(10,36),0.25);
q_val = Qabf(IR, VIS, Fused_out);
xc = XC(VIS,Fused_out);
imse = immse(VIS,Fused_out);
peaksnr = psnr(VIS,Fused_out);
ssimval = ssim(VIS,Fused_out);
iscore_brisque = brisque(VIS,model);
niqe_model = niqe(Fused_out);
brisqueInoise = brisque(Fused_out);
mi = MutualInformation(VIS,Fused_out);
% fprintf('%s\n',['1)En--------------->',num2str(en)])
% fprintf('%s\n',['2)Qe------------------->',num2str(q_val)])
% fprintf('%s\n',['2)XC------------------->',num2str(xc)])
% fprintf('%s\n',['2)MSE------------------->',num2str(imse)])
set(handles.edit2,'String',num2str(en));
set(handles.edit4,'String',num2str(q_val));
set(handles.edit6,'String',num2str(xc));
set(handles.edit8,'String',num2str(imse));
set(handles.edit12,'String',num2str(peaksnr));
set(handles.edit13,'String',num2str(ssimval));
set(handles.edit14,'String',num2str(iscore_brisque));
set(handles.edit15,'String',num2str(niqe_model));
set(handles.edit16,'String',num2str(brisqueInoise));
set(handles.edit17,'String',num2str(mi));
save B_fusion B_fusion
save D_fusion D_fusion
save Fused_out Fused_out
elseif(vOtype_1)
%====================Iteration 1===========================================
irgf_d1 = im2double(imgaussfilt(IR,0.01));
visgf_d1=im2double(imgaussfilt(VIS,0.01));
ir_jbf_d1=im2double(jbfltGray(irgf_d1,irgf_d1,0.01,0.02,1));
vis_jbf_d1=im2double(jbfltGray(visgf_d1,visgf_d1,0.01,0.02,1));
%====================Iteration 2===========================================
irgf_d2 = im2double(imgaussfilt(ir_jbf_d1,0.01));
visgf_d2=im2double(imgaussfilt(vis_jbf_d1,0.01));
ir_jbf_d2=im2double(jbfltGray(irgf_d2,irgf_d2,0.01,0.02,1));
vis_jbf_d2=im2double(jbfltGray(visgf_d2,visgf_d2,0.01,0.02,1));
%====================Iteration 3===========================================
irgf_d3 = im2double(imgaussfilt(ir_jbf_d2,0.01));
visgf_d3=im2double(imgaussfilt(vis_jbf_d2,0.01));
ir_jbf_d3=im2double(jbfltGray(irgf_d3,irgf_d3,0.01,0.02,1));
vis_jbf_d3=im2double(jbfltGray(visgf_d3,visgf_d3,0.01,0.02,1));
%====================Iteration 4===========================================
irgf_d4 = im2double(imgaussfilt(ir_jbf_d3,0.01));
visgf_d4=im2double(imgaussfilt(vis_jbf_d3,0.01));
ir_jbf_d4=im2double(jbfltGray(irgf_d4,irgf_d4,0.01,0.02,1));
vis_jbf_d4=im2double(jbfltGray(visgf_d4,visgf_d4,0.01,0.2,1));
%===================================high-pass image========================
HP_ir = locallapfilt(IR, 0.4, 0.5);
HP_vis= locallapfilt(VIS, 0.4, 0.5);
%===================================Low-pass image==========+==============
SM_ir=HP_ir;
SM_vis=HP_vis;
%==================================Initial Weight MAp======================
IWP_ir=zeros(size(SM_ir,1),size(SM_ir,2));
for i=1:size(SM_ir,1)
    for j=1:size(SM_ir,2)
        if(SM_ir(i,j)>(SM_vis(i,j)))
            IWP_ir(i,j)=1;
        else
            IWP_ir(i,j)=0;
        end
    end
end
IWP_vis=zeros(size(SM_vis,1),size(SM_vis,2));
for i=1:size(SM_vis,1)
    for j=1:size(SM_vis,2)
        if(SM_ir(i,j)<(SM_vis(i,j)))
            IWP_vis(i,j)=1;
        else
            IWP_vis(i,j)=0;
        end
    end
end
%==========================Final Weight Map================================
FWP_ir=imguidedfilter(IWP_ir,IR);
FWP_vis=imguidedfilter(IWP_vis,VIS);
%=========================Base Layer Fusion================================
B_fusion=FWP_ir.*im2double(irgf_d4)+FWP_vis.*im2double(visgf_d4);
%=========================Detailed Layer Fusion============================
A=padarray(ir_jbf_d4,[1,1],0,'both');
for m=2:size(A,1)-1
    for n=2:size(A,2)-1
        temp=A(m-1:m+1,n-1:n+1);
        avg_ir(m-1,n-1)=mean2(temp);
    end
end
I=padarray(vis_jbf_d4,[1,1],0,'both');
for m=2:size(I,1)-1
    for n=2:size(I,2)-1
        temp=I(m-1:m+1,n-1:n+1);
        avg_vis(m-1,n-1)=mean2(temp);
    end
end
en_devil=zeros(size(avg_ir,1),size(avg_ir,2));
for i=1:size(avg_ir,1)-1
    for j=1:size(avg_ir,2)-1
        en_devil(i,j)=((avg_ir(i,j))/(avg_ir(i,j)+avg_vis(i,j)));
    end
end
Th=0.6;
alpha=(Th/1+Th);
beta=((1/1)+Th);
a=zeros((size(en_devil,1)),(size(en_devil,2)));
for m=1:size(en_devil,1)
    for n=1:size(en_devil,2)
        if((en_devil(m,n))>=0.5 && (en_devil(m,n))<=beta)
            a(m,m)=(0.5+0.5*((1-2*en_devil(m,n) / (1-2*beta))));
        elseif((en_devil(m,n))>=0.5 && (en_devil(m,n))<=alpha)
            a(m,m)=(0.5-0.5*((1-2*en_devil(m,n) / (1-2*beta))));
        elseif((en_devil(m,n))>=0 && (en_devil(m,n))>=alpha)
            a(m,m)=0;
        elseif((en_devil(m,n))>= 1 && (en_devil(m,n))<=beta)
            a(m,m)=1;
        end
    end
end
D_fusion=zeros((size(en_devil,1)),(size(en_devil,2)));
for i=1:(size(en_devil,1))
    for j=1:(size(en_devil,2))
        D_fusion(i,j)=((1-(en_devil(i,j).*vis_jbf_d3(i,j))+((en_devil(i,j).*ir_jbf_d3(i,j)))));
    end
end
IR = im2double(IR);
VIS = im2double(VIS);
B_fusion = NormalizeData(B_fusion);
D_fusion = NormalizeData(D_fusion);
Fused_out = 0.4*B_fusion + 0.4*D_fusion;
axes(handles.axes3);imshow(Fused_out);
en = image_entropy(Fused_out);
q_val = Qabf(IR, VIS, Fused_out);
opinionScores = 100*rand(1,1);
model = brisqueModel(rand(10,1),47,rand(10,36),0.25);
xc = XC(VIS,Fused_out);
imse = immse(VIS,Fused_out);
peaksnr = psnr(VIS,Fused_out);
ssimval = ssim(VIS,Fused_out);
iscore_brisque = brisque(VIS,model);
niqe_model = niqe(Fused_out);
brisqueInoise = brisque(Fused_out);
mi = MutualInformation(VIS,Fused_out);
% fprintf('%s\n',['1)En------------------->',num2str(en)])
% fprintf('%s\n',['2)Qe------------------->',num2str(q_val)])
% fprintf('%s\n',['3)IMMSE---------------->',num2str(imse)])
% fprintf('%s\n',['4)XC------------------->',num2str(xc)])
% fprintf('%s\n',['5)PEAK_SNR------------->',num2str(peaksnr)])
% fprintf('%s\n',['6)SSIMVAL-------------->',num2str(ssimval)])
% fprintf('%s\n',['7)BRISQUE-------------->',num2str(iscore_brisque)])
% fprintf('%s\n',['8)NIQE----------------->',num2str(niqe_model)])
% fprintf('%s\n',['9)BRISQUE_INOISE------->',num2str(brisqueInoise)])
% fprintf('%s\n',['10)Mutual Information------->',num2str(mi)])
set(handles.edit2,'String',num2str(en));
set(handles.edit4,'String',num2str(q_val));
set(handles.edit6,'String',num2str(xc));
set(handles.edit8,'String',num2str(imse));
set(handles.edit12,'String',num2str(peaksnr));
set(handles.edit13,'String',num2str(ssimval));
set(handles.edit14,'String',num2str(iscore_brisque));
set(handles.edit15,'String',num2str(niqe_model));
set(handles.edit16,'String',num2str(brisqueInoise));
set(handles.edit17,'String',num2str(mi));
save B_fusion B_fusion
save B_fusion B_fusion
save D_fusion D_fusion
save Fused_out Fused_out

end
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



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
set(handles.radiobutton1,'Value',1)
set(handles.radiobutton2,'Value',0)

% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
set(handles.radiobutton1,'Value',0)
set(handles.radiobutton2,'Value',1)

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



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
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



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
