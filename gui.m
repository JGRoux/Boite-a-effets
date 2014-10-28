function varargout = gui(varargin)
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
handles.choice=0;
handles.changed=0;
handles.dcompress=[0 1 0 0];
handles.dreverb=[1 1 1];
handles.dequa=zeros(3,10);
handles.dequa(1,:)=[32 64 125 250 500 1000 2000 4000 8000 16000];
handles.dequa(3,:)=handles.dequa(3,:)+1;
handles.gain=100;
ylabel(handles.axes1,'Gain (dB)','fontweight','bold','fontsize',8); % trick to make a text vertical
ylabel(handles.axes2,'Gain (%)','fontweight','bold','fontsize',8);
handles.output=hObject;
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --- Executes on button press in openfile.
function openfile_Callback(hObject, eventdata, handles)
[filename,path]=uigetfile('*.wav');
handles.file=strcat(path,filename);
set(handles.textfile, 'String', handles.file);
handles.changed=1;
guidata(hObject,handles);


% --- Executes on button press in Play.
function play_Callback(hObject, eventdata, handles)
handles=compute(handles);
guidata(hObject,handles);
resume(handles.p);

% --- Executes on button press in pause.
function pause_Callback(hObject, eventdata, handles)
pause(handles.p);

% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
stop(handles.p);

% --- Executes during object creation, after setting all properties.
function choose_CreateFcn(hObject, eventdata, handles)

% --- Executes when selected object changed in unitgroup.
function choose_SelectionChangeFcn(hObject, eventdata, handles)
if(hObject == handles.none)
    handles.choice=0;
elseif (hObject == handles.compress)
    handles.choice=1;
elseif (hObject == handles.reverb)
    handles.choice=2;
elseif (hObject == handles.equa)
    handles.choice=3;
end
handles.changed=1;
guidata(hObject,handles);


function sec_Callback(hObject, eventdata, handles)
nb=check_nb(hObject,0.1,8); %nb=check_nb(object,min,max)
handles.dreverb(2)=nb;
handles.changed=1;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function sec_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function m_Callback(hObject, eventdata, handles)
nb=check_nb(hObject,1,20); %nb=check_nb(object,min,max)
handles.dreverb(3)=nb;
handles.changed=1;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function m_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function nb=check_nb(hObject,min,max)
nb=str2num(get(hObject,'String'));
if isempty(nb)
    set(hObject,'string',num2str(min));
    nb=min;
    warndlg('Input must be numerical');
else
    if(nb<min)
        set(hObject,'string',num2str(min));
        nb=min;
    elseif (nb>max)
        set(hObject,'string',num2str(max));
        nb=max;
    end
end


% --- Executes on selection change in listbox.
function listbox_Callback(hObject, eventdata, handles)
handles.dreverb(1)=get(hObject,'Value');
handles.changed=1;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function listbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in mmoins.
function mmoins_Callback(hObject, eventdata, handles)
nb = str2num(get(handles.m,'string'));
if(nb>=2)
    set(handles.m, 'String', num2str(nb-1));
    handles.dreverb(3)=nb-1;
    handles.changed=1;
    guidata(hObject,handles);
end

% --- Executes on button press in mplus.
function mplus_Callback(hObject, eventdata, handles)
nb = str2num(get(handles.m,'string'));
if(nb<=19)
    set(handles.m, 'String', num2str(nb+1));
    handles.dreverb(3)=nb+1;
    handles.changed=1;
    guidata(hObject,handles);
end

% --- Executes on button press in secmoins.
function secmoins_Callback(hObject, eventdata, handles)
nb = str2num(get(handles.sec,'string'));
if(nb>1)
    set(handles.sec, 'String', num2str(nb-1));
    handles.dreverb(2)=nb-1;
    handles.changed=1;
    guidata(hObject,handles);
end

% --- Executes on button press in secplus.
function secplus_Callback(hObject, eventdata, handles)
nb = str2num(get(handles.sec,'string'));
if(nb<=7)
    set(handles.sec, 'String', num2str(nb+1));
    handles.dreverb(2)=nb+1;
    handles.changed=1;
    guidata(hObject,handles);
end

% --- Executes on button press in spectrum.
function spectrum_Callback(hObject, eventdata, handles)
handles=compute(handles);
guidata(hObject,handles);
Plot(handles.Input,handles.Output,handles.Fe,handles.Nbit)


function data=reload_data(handles)
if handles.choice==1
    data=handles.dcompress;
elseif handles.choice==2
    data=handles.dreverb;
elseif handles.choice==3
    data=handles.dequa;
else
    data=0;
end


function handles=compute(handles)
if(handles.changed==1)
    [handles.Input,handles.Output,handles.Fe,handles.Nbit]=Main(handles.file,handles.choice,handles.gain,reload_data(handles));
    handles.changed=0;
    handles.p = audioplayer(handles.Output, handles.Fe);
end


% --- Executes on slider movement.
function fade32_Callback(hObject, eventdata, handles)
get_fade(hObject,handles,1);

% --- Executes during object creation, after setting all properties.
function fade32_CreateFcn(hObject, eventdata, handles)
ini_fade(hObject,-15,15,0,1); %ini_fade(hObject,min,max,ini_value,step)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function fade64_Callback(hObject, eventdata, handles)
get_fade(hObject,handles,2);

% --- Executes during object creation, after setting all properties.
function fade64_CreateFcn(hObject, eventdata, handles)
ini_fade(hObject,-15,15,0,1); %ini_fade(hObject,min,max,ini_value,step)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function fade125_Callback(hObject, eventdata, handles)
get_fade(hObject,handles,3);

% --- Executes during object creation, after setting all properties.
function fade125_CreateFcn(hObject, eventdata, handles)
ini_fade(hObject,-15,15,0,1); %ini_fade(hObject,min,max,ini_value,step)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function fade250_Callback(hObject, eventdata, handles)
get_fade(hObject,handles,4);

% --- Executes during object creation, after setting all properties.
function fade250_CreateFcn(hObject, eventdata, handles)
ini_fade(hObject,-15,15,0,1); %ini_fade(hObject,min,max,ini_value,step)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function fade500_Callback(hObject, eventdata, handles)
get_fade(hObject,handles,5);

% --- Executes during object creation, after setting all properties.
function fade500_CreateFcn(hObject, eventdata, handles)
ini_fade(hObject,-15,15,0,1); %ini_fade(hObject,min,max,ini_value,step)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function fade1k_Callback(hObject, eventdata, handles)
get_fade(hObject,handles,6);

% --- Executes during object creation, after setting all properties.
function fade1k_CreateFcn(hObject, eventdata, handles)
ini_fade(hObject,-15,15,0,1); %ini_fade(hObject,min,max,ini_value,step)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function fade2k_Callback(hObject, eventdata, handles)
get_fade(hObject,handles,7);

% --- Executes during object creation, after setting all properties.
function fade2k_CreateFcn(hObject, eventdata, handles)
ini_fade(hObject,-15,15,0,1); %ini_fade(hObject,min,max,ini_value,step)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function fade4k_Callback(hObject, eventdata, handles)
get_fade(hObject,handles,8);

% --- Executes during object creation, after setting all properties.
function fade4k_CreateFcn(hObject, eventdata, handles)
ini_fade(hObject,-15,15,0,1); %ini_fade(hObject,min,max,ini_value,step)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function fade8k_Callback(hObject, eventdata, handles)
get_fade(hObject,handles,9);

% --- Executes during object creation, after setting all properties.
function fade8k_CreateFcn(hObject, eventdata, handles)
ini_fade(hObject,-15,15,0,1); %ini_fade(hObject,min,max,ini_value,step)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function fade16k_Callback(hObject, eventdata, handles)
get_fade(hObject,handles,10);


% --- Executes during object creation, after setting all properties.
function fade16k_CreateFcn(hObject, eventdata, handles)
ini_fade(hObject,-15,15,0,1); %ini_fade(hObject,min,max,ini_value,step)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function ini_fade(hObject,min,max,ini_value,step)
set(hObject,'Min',min);
set(hObject,'Max',max);
set(hObject, 'Value', ini_value);
set(hObject, 'SliderStep', [step,step]/(max-min));

function get_fade(hObject,handles,i)
handles.dequa(2,i)=roundn(get(hObject,'Value'),-1);
handles.changed=1;
guidata(hObject,handles);

function get_q(hObject,handles,i)
nb=check_nb(hObject,0.5,15); %nb=check_nb(object,min,max)
handles.dequa(3,i)=nb;
handles.changed=1;
guidata(hObject,handles);



function q32_Callback(hObject, eventdata, handles)
get_q(hObject,handles,1);

% --- Executes during object creation, after setting all properties.
function q32_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function q64_Callback(hObject, eventdata, handles)
get_q(hObject,handles,2);

% --- Executes during object creation, after setting all properties.
function q64_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function q125_Callback(hObject, eventdata, handles)
get_q(hObject,handles,3);

% --- Executes during object creation, after setting all properties.
function q125_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function q250_Callback(hObject, eventdata, handles)
get_q(hObject,handles,4);

% --- Executes during object creation, after setting all properties.
function q250_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function q500_Callback(hObject, eventdata, handles)
get_q(hObject,handles,5);

% --- Executes during object creation, after setting all properties.
function q500_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function q1k_Callback(hObject, eventdata, handles)
get_q(hObject,handles,6);

% --- Executes during object creation, after setting all properties.
function q1k_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function q2k_Callback(hObject, eventdata, handles)
get_q(hObject,handles,7);

% --- Executes during object creation, after setting all properties.
function q2k_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function q4k_Callback(hObject, eventdata, handles)
get_q(hObject,handles,8);

% --- Executes during object creation, after setting all properties.
function q4k_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function q8k_Callback(hObject, eventdata, handles)
get_q(hObject,handles,9);

% --- Executes during object creation, after setting all properties.
function q8k_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function q16k_Callback(hObject, eventdata, handles)
get_q(hObject,handles,10);

% --- Executes during object creation, after setting all properties.
function q16k_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function tr_CreateFcn(hObject, eventdata, handles)
ini_fade(hObject,0,40,0,1); %ini_fade(hObject,min,max,ini_value,step)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function tr_Callback(hObject, eventdata, handles)
handles.dcompress(1)=-(ceil(get(hObject,'Value')));
set(handles.trval,'String',strcat(num2str(handles.dcompress(1)),' dB'));
handles.changed=1;
guidata(hObject,handles);


function ratio_Callback(hObject, eventdata, handles)
nb=check_nb(hObject,1,10); %nb=check_nb(object,min,max)
handles.dcompress(2)=nb;
handles.changed=1;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function ratio_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function attack_Callback(hObject, eventdata, handles)
nb=check_nb(hObject,0,300); %nb=check_nb(object,min,max)
handles.dcompress(3)=nb;
handles.changed=1;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function attack_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function released_Callback(hObject, eventdata, handles)
nb=check_nb(hObject,0,300); %nb=check_nb(object,min,max)
handles.dcompress(4)=nb;
handles.changed=1;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function released_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function gainout_Callback(hObject, eventdata, handles)
handles.gain=ceil(get(hObject,'Value'));
set(handles.gainval,'String',strcat(num2str(handles.gain),'%'));
handles.changed=1;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function gainout_CreateFcn(hObject, eventdata, handles)
ini_fade(hObject,0,200,100,10); %ini_fade(hObject,min,max,ini_value,step)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
