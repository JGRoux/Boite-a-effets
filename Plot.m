function varargout = Plot(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Plot_OpeningFcn, ...
    'gui_OutputFcn',  @Plot_OutputFcn, ...
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

% --- Executes just before Plot is made visible.
function Plot_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
handles.in=varargin{1};
handles.out=varargin{2};
handles.Fe=varargin{3};
handles.Nbit=varargin{4};
% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using Plot.
if strcmp(get(hObject,'Visible'),'off')
    time_Callback(handles.time, eventdata, handles);
end

% --- Outputs from this function are returned to the command line.
function varargout = Plot_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


% --------------------------------------------------------------------
function menu_Callback(hObject, eventdata, handles)
% hObject    handle to menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function time_Callback(hObject, eventdata, handles)
if strcmp(get(hObject, 'Checked'),'off')
    set(hObject, 'Checked', 'on');
    set(handles.fft, 'Checked', 'off');
    set(handles.gain, 'Checked', 'off');
    set(handles.phase, 'Checked', 'off');
    
    L = length(handles.in);
    l=size(handles.in,1);
    for i=1:l
        h(i)=subplot(l*2,1,i,'Parent',handles.uipanel1);
        plot((0:L-1)./handles.Fe,handles.in(i,:));
        z(i)=zoom;
        setAxesZoomMotion(z(i),h(i),'horizontal');
    end
    
    for i=1:l-1
        pos=get(h,'position');
        set(h(i),'xticklabel',[]);
        pos{i+1}(2)=pos{i}(2)-pos{i}(4)-0.03;
        set(h(i+1),'position',pos{i+1});
        if (mod(i,2)==1)
            ylabel(h(i),strcat('Amplitude L',num2str(i)));
            ylabel(h(i+1),strcat('Amplitude R',num2str(i)));
        end
    end
    title(h(1),'Original signal (in time)','fontweight','bold','fontsize',14);
    xlabel(h(l),'Time (s)');
    if l==1
        ylabel(h(1),'Amplitude')
    end
    
    for i=1:l
        h(i)=subplot(l*2,1,i+l,'Parent',handles.uipanel1);
        plot((0:L-1)./handles.Fe,handles.out(i,:),'Color','red');
        z(i)=zoom;
        setAxesZoomMotion(z(i),h(i),'horizontal');
    end
    
    for i=1:l-1
        pos=get(h,'position');
        set(h(i),'xticklabel',[]);
        pos{i}(2)=pos{i+1}(2)+pos{i+1}(4)+0.02;
        set(h(i),'position',pos{i});
        if (mod(i,2)==1)
            ylabel(h(i),strcat('Amplitude L',num2str(i)));
            ylabel(h(i+1),strcat('Amplitude R',num2str(i)));
        end
    end
    
    title(h(1),'Modified signal (in time)','fontweight','bold','fontsize',14);
    xlabel(h(l),'Time (s)');
    if l==1
        ylabel(h(1),'Amplitude')
    end
end


% --------------------------------------------------------------------
function freq_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function fft_Callback(hObject, eventdata, handles)
if strcmp(get(hObject, 'Checked'),'off')
    set(hObject, 'Checked', 'on');
    set(handles.time, 'Checked', 'off');
    set(handles.gain, 'Checked', 'off');
    set(handles.phase, 'Checked', 'off');
    
    L = length(handles.in);
    l=size(handles.in,1);
    f=(0:L/2)*handles.Fe/L;
    
    for i=1:l
        h(i)=subplot(l*2,1,i,'Parent',handles.uipanel1);
        x=fftshift(abs(fft(handles.in(i,:))));
        plot(f,x(ceil(L/2):L));
        z(i)=zoom;
        setAxesZoomMotion(z(i),h(i),'horizontal');
    end
    
    for i=1:l-1
        pos=get(h,'position');
        set(h(i),'xticklabel',[]);
        pos{i+1}(2)=pos{i}(2)-pos{i}(4)-0.02;
        set(h(i+1),'position',pos{i+1});
        if (mod(i,2)==1)
            ylabel(h(i),strcat('Amplitude L',num2str(i)));
            ylabel(h(i+1),strcat('Amplitude R',num2str(i)));
        end
    end
    title(h(1),'Original signal (in frequency)','fontweight','bold','fontsize',14);
    xlabel(h(l),'Frequency (Hz)');
    if l==1
        ylabel(h(1),'Amplitude')
    end
    
    for i=1:l
        h(i)=subplot(l*2,1,i+l,'Parent',handles.uipanel1);
        x=fftshift(abs(fft(handles.out(i,:))));
        plot(f,x(ceil(L/2):L),'Color','red');
        z(i)=zoom;
        setAxesZoomMotion(z(i),h(i),'horizontal');
    end
    
    for i=1:l-1
        pos=get(h,'position');
        set(h(i),'xticklabel',[]);
        pos{i}(2)=pos{i+1}(2)+pos{i+1}(4)+0.02;
        set(h(i),'position',pos{i});
        if (mod(i,2)==1)
            ylabel(h(i),strcat('Amplitude L',num2str(i)));
            ylabel(h(i+1),strcat('Amplitude R',num2str(i)));
        end
    end
    
    title(h(1),'Modified signal (in frequency)','fontweight','bold','fontsize',14);
    xlabel(h(l),'Frequency (Hz)');
    if l==1
        ylabel(h(1),'Amplitude')
    end
end

% --------------------------------------------------------------------
function phase_Callback(hObject, eventdata, handles)
if strcmp(get(hObject, 'Checked'),'off')
    set(hObject, 'Checked', 'on');
    set(handles.time, 'Checked', 'off');
    set(handles.fft, 'Checked', 'off');
    set(handles.gain, 'Checked', 'off');
    
    L = length(handles.in);
    l=size(handles.in,1);
    f=(0:L/2)*handles.Fe/L;
    
    for i=1:l
        h(i)=subplot(l*2,1,i,'Parent',handles.uipanel1);
        x=fftshift(fft(handles.in(i,:))/handles.Nbit^2);
        plot(f,unwrap(angle(x(ceil(L/2):L)))*180/pi);
        z(i)=zoom;
        setAxesZoomMotion(z(i),h(i),'horizontal');
    end
    
    for i=1:l-1
        pos=get(h,'position');
        set(h(i),'xticklabel',[]);
        pos{i+1}(2)=pos{i}(2)-pos{i}(4)-0.02;
        set(h(i+1),'position',pos{i+1});
        if (mod(i,2)==1)
            ylabel(h(i),strcat(strcat('Angle L',num2str(i)),' (°)'));
            ylabel(h(i+1),strcat(strcat('Angle R',num2str(i)),' (°)'));
        end
    end
    title(h(1),'Original signal (in phase)','fontweight','bold','fontsize',14);
    xlabel(h(l),'Frequency (Hz)');
    if l==1
        ylabel(h(1),'Angle (°)')
    end
    
    for i=1:l
        h(i)=subplot(l*2,1,i+l,'Parent',handles.uipanel1);
        x=fftshift(fft(handles.out(i,:))/handles.Nbit^2);
        plot(f,unwrap(angle(x(ceil(L/2):L)))*180/pi,'Color','red');
        z(i)=zoom;
        setAxesZoomMotion(z(i),h(i),'horizontal');
    end
    
    for i=1:l-1
        pos=get(h,'position');
        set(h(i),'xticklabel',[]);
        pos{i}(2)=pos{i+1}(2)+pos{i+1}(4)+0.02;
        set(h(i),'position',pos{i});
        if (mod(i,2)==1)
            ylabel(h(i),strcat(strcat('Angle L',num2str(i)),' (°)'));
            ylabel(h(i+1),strcat(strcat('Angle R',num2str(i)),' (°)'));
        end
    end
    
    title(h(1),'Modified signal (in phase)','fontweight','bold','fontsize',14);
    xlabel(h(l),'Frequency (Hz)');
    if l==1
        ylabel(h(1),'Angle (°)')
    end
end


% --------------------------------------------------------------------
function gain_Callback(hObject, eventdata, handles)
if strcmp(get(hObject, 'Checked'),'off')
    set(hObject, 'Checked', 'on');
    set(handles.time, 'Checked', 'off');
    set(handles.fft, 'Checked', 'off');
    set(handles.phase, 'Checked', 'off');
    
    L = length(handles.in);
    l=size(handles.in,1);
    f=(0:L/2)*handles.Fe/L;
    for i=1:l
        h(i)=subplot(l*2,1,i,'Parent',handles.uipanel1);
        x=mag2db(fftshift(abs(fft(handles.in(i,:))))/handles.Nbit^2);
        plot(f,x(ceil(L/2):L));
        z(i)=zoom;
        setAxesZoomMotion(z(i),h(i),'horizontal');
    end
    
    for i=1:l-1
        pos=get(h,'position');
        set(h(i),'xticklabel',[]);
        pos{i+1}(2)=pos{i}(2)-pos{i}(4)-0.02;
        set(h(i+1),'position',pos{i+1});
        if (mod(i,2)==1)
            ylabel(h(i),strcat(strcat('Gain L',num2str(i)),' (dB)'));
            ylabel(h(i+1),strcat(strcat('Gain R',num2str(i)),' (dB)'));
        end
    end
    title(h(1),'Original signal (in frequency)','fontweight','bold','fontsize',14);
    xlabel(h(l),'Frequency (Hz)');
    if l==1
        ylabel(h(1),'Gain (dB)')
    end
    
    for i=1:l
        h(i)=subplot(l*2,1,i+l,'Parent',handles.uipanel1);
        x=mag2db(fftshift(abs(fft(handles.out(i,:))))/handles.Nbit^2);
        plot(f,x(ceil(L/2):L),'Color','red');
        z(i)=zoom;
        setAxesZoomMotion(z(i),h(i),'horizontal');
    end
    
    for i=1:l-1
        pos=get(h,'position');
        set(h(i),'xticklabel',[]);
        pos{i}(2)=pos{i+1}(2)+pos{i+1}(4)+0.02;
        set(h(i),'position',pos{i});
        if (mod(i,2)==1)
            ylabel(h(i),strcat(strcat('Gain L',num2str(i)),' (dB)'));
            ylabel(h(i+1),strcat(strcat('Gain R',num2str(i)),' (dB)'));
        end
    end
    
    title(h(1),'Modified signal (in frequency)','fontweight','bold','fontsize',14);
    xlabel(h(l),'Frequency (Hz)');
    if l==1
        ylabel(h(1),'Gain (dB)')
    end
end
