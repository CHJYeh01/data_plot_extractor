function varargout = data_plot_extractor_v01(varargin)
% DATA_PLOT_EXTRACTOR_V01 MATLAB code for data_plot_extractor_v01.fig
%      DATA_PLOT_EXTRACTOR_V01, by itself, creates a new DATA_PLOT_EXTRACTOR_V01 or raises the existing
%      singleton*.
%
%      H = DATA_PLOT_EXTRACTOR_V01 returns the handle to a new DATA_PLOT_EXTRACTOR_V01 or the handle to
%      the existing singleton*.
%
%      DATA_PLOT_EXTRACTOR_V01('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATA_PLOT_EXTRACTOR_V01.M with the given input arguments.
%
%      DATA_PLOT_EXTRACTOR_V01('Property','Value',...) creates a new DATA_PLOT_EXTRACTOR_V01 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before data_plot_extractor_v01_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to data_plot_extractor_v01_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help data_plot_extractor_v01

% Last Modified by GUIDE v2.5 10-Aug-2016 14:39:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @data_plot_extractor_v01_OpeningFcn, ...
                   'gui_OutputFcn',  @data_plot_extractor_v01_OutputFcn, ...
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


% --- Executes just before data_plot_extractor_v01 is made visible.
function data_plot_extractor_v01_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to data_plot_extractor_v01 (see VARARGIN)

% Choose default command line output for data_plot_extractor_v01
handles.output = hObject;
set(handles.ref_table,'rowname',{'x','y'},'data',nan(2,2));
handles.din.num_pts=0;
handles.din.flag=1;%this flag is set to 1 to define behavior during first iteration of commands
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes data_plot_extractor_v01 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = data_plot_extractor_v01_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
try%get the file
    [filename,pathname]=uigetfile([handles.din.pathname,'*.*']);
catch
    [filename,pathname]=uigetfile('*.*');
end
%show filepath in tooltip string and string fields
handles.filename_txt.TooltipString=['<html>filename: ',filename,'<br/> pathname: ',pathname];
handles.filename_txt.String=filename;%
handles.status.String='Status: Plot loaded!';%update status bar
I=imread([pathname,filename]);%read file
axes(handles.axes1);
imshow(I);%shoe image
impixelinfo;
handles.din.imfinfo=imfinfo([pathname,filename]);
% store and show metadat information of the plot image
disp(handles.din.imfinfo);
im_info={['FileModDate: ',handles.din.imfinfo.FileModDate];...
    ['FileSize: ',num2str(handles.din.imfinfo.FileSize)];...
    ['Format: ',num2str(handles.din.imfinfo.Format)];...
    ['Width: ',num2str(handles.din.imfinfo.Width)];...
    ['Height: ',num2str(handles.din.imfinfo.Height)];...
    ['BitDepth: ',num2str(handles.din.imfinfo.BitDepth)];...
    ['ColorType: ',handles.din.imfinfo.ColorType]};
handles.metadata.String=im_info;
handles.din.I=I;%store image in handles structure
handles.din.filename=filename;
handles.din.pathname=pathname;
guidata(handles.figure1,handles);

% --- Executes on button press in origin.
function origin_Callback(hObject, eventdata, handles)
try
    delete(handles.din.origin);
catch
end
origin=impoint(handles.axes1);
setColor(origin,'c');%set color of the origin marker to cyan
handles.din.origin=origin;
handles.din.origin_pos=getPosition(origin);
handles.origin.TooltipString=['<html>X position: ',num2str(handles.din.origin_pos(1)),'<br/>Y position: ',num2str(handles.din.origin_pos(2))];
guidata(handles.figure1,handles);


% --- Executes on button press in x_end.
function x_end_Callback(hObject, eventdata, handles)
try
    delete(handles.din.x_end);
end
x_end=impoint(handles.axes1);
setColor(x_end,'b');%set color of the x reference marker to blue
handles.din.x_end=x_end;
handles.din.x_end_pos=getPosition(x_end);
handles.x_end.TooltipString=['<html>X position: ',num2str(handles.din.x_end_pos(1)),'<br/>Y position: ',num2str(handles.din.x_end_pos(2))];
guidata(handles.figure1,handles);


% --- Executes on button press in y_end.
function y_end_Callback(hObject, eventdata, handles)
try
    delete(handles.din.y_end);
end
y_end=impoint(handles.axes1);
setColor(y_end,'r');%set color of the y reference maker to red
handles.din.y_end=y_end;
handles.din.y_end_pos=getPosition(y_end);
handles.y_end.TooltipString=['<html>X position: ',num2str(handles.din.y_end_pos(1)),'<br/>Y position: ',num2str(handles.din.y_end_pos(2))];
guidata(handles.figure1,handles);

% --- Executes on button press in select.
function select_Callback(hObject, eventdata, handles)
num_pts=handles.din.num_pts;
if hObject.Value==1
    %Get state of zoom and pan tools
    default{1}=handles.uitoggletool1.State;
    default{2}=handles.uitoggletool2.State;
    default{3}=handles.uitoggletool3.State;
    %turn off zoom and pan tools and clear button
    set(handles.uitoggletool1,'state','off','visible','off');
    set(handles.uitoggletool2,'state','off','visible','off');
    set(handles.uitoggletool3,'state','off','visible','off');
    set(handles.clear,'visible','off');
    while hObject.Value==1
        try
            num_pts=num_pts+1;
            handles.din.select.(['pt_',num2str(num_pts)])=impoint(handles.axes1);
            setColor(handles.din.select.(['pt_',num2str(num_pts)]),'g');
            disp(['Datapt ',num2str(num_pts),' selected!']);
            set(handles.status,'string',['Datapt ',num2str(num_pts),' selected!']);
            handles.din.num_pts=num_pts;
            guidata(handles.figure1,handles);            
        end
    end
    %re-enable zoom and pan tools and clear button
    set(handles.uitoggletool1,'state',default{1},'visible','on');
    set(handles.uitoggletool2,'state',default{2},'visible','on');
    set(handles.uitoggletool3,'state',default{3},'visible','on');
    if strcmp(default{1},'on')
        h=zoom(handles.figure1);
        h.Enable=default{1};
        h.Direction='in';
    end
    if strcmp(default{2},'on')
        h=zoom(handles.figure1);
        h.Enable=default{2};
        h.Direction='out';
    end
    if strcmp(default{3},'on')
        h=pan(handles.figure1);
        h.Enable=default{3};
    end
    set(handles.clear,'visible','on');
    try
        handles=ref_pts(handles);
    end
else
    uiresume(handles.figure1);
end

function handles=ref_pts(handles)
%this fucntion converts the pixel values to meaningful values
num_pts=handles.din.num_pts;%total number of points
%return the function if there are no values
try names=fieldnames(handles.din.select);
catch
    handles.uitable2.Data=[];
    return    
end
ref_data=handles.ref_table.Data;%get reference data
xdat2pix=(ref_data(1,2)-ref_data(1,1))/(handles.din.x_end_pos(1)-handles.din.origin_pos(1));
ydat2pix=(ref_data(2,2)-ref_data(2,1))/(handles.din.y_end_pos(2)-handles.din.origin_pos(2));
sel_data=nan(length(names),3);
for dum=1:length(names)
    pt=num2str(names{dum}(4:end));
    pos=getPosition(handles.din.select.(names{dum}));
    xpixl=pos(1)-handles.din.origin_pos(1);
    ypixl=pos(2)-handles.din.origin_pos(2);
    xl=xpixl*xdat2pix+ref_data(1,1);
    yl=ypixl*ydat2pix+ref_data(2,1);
    sel_data(dum,:)=[xl,yl,1];
end
handles.uitable2.Data=sel_data;
guidata(handles.figure1,handles);

% --- Executes when entered data in editable cell(s) in ref_table.
function ref_table_CellEditCallback(hObject, eventdata, handles)



% --- Executes on button press in h_button.
function h_button_Callback(hObject, eventdata, handles)
assignin('base','handles',handles);
disp('handles structure exported to base workspace!');
handles.status.String='Status: handles structure exported to base workspace!';


% --- Executes on button press in refresh.
function refresh_Callback(hObject, eventdata, handles)
% Refresh the values of selected datapoints
try
    handles.din.origin_pos=getPosition(handles.din.origin);
    handles.din.x_end_pos=getPosition(handles.din.x_end);
    handles.din.y_end_pos=getPosition(handles.din.y_end);
    handles.x_end.TooltipString=['<html>X position: ',num2str(handles.din.x_end_pos(1)),'<br/>Y position: ',num2str(handles.din.x_end_pos(2))];
    handles.y_end.TooltipString=['<html>X position: ',num2str(handles.din.y_end_pos(1)),'<br/>Y position: ',num2str(handles.din.y_end_pos(2))];
    handles.origin.TooltipString=['<html>X position: ',num2str(handles.din.origin_pos(1)),'<br/>Y position: ',num2str(handles.din.origin_pos(2))];
end
try
    handles=ref_pts(handles);
end
guidata(handles.figure1,handles);


% --- Executes on button press in export.
function export_Callback(hObject, eventdata, handles)
disp('Saving...');
set(handles.status,'string','Status: Saving...');
data=handles.uitable2.Data;
if iscell(data)==1||isempty(data)==1
    disp('No data selected!');
    return
end
include=find(data(:,3)==1);
export_data=data(include,1:2);
[~,index]=sort(export_data(:,1));
export_data=export_data(index,:);
metadata={'Data extracted with: ',handles.figure1.UserData};
try
    if handles.din.flag==1
        [ex_file,ex_path]=uiputfile([handles.din.pathname,'*.mat']);
    else
        [ex_file,ex_path]=uiputfile([handles.din.ex_path,'*.mat']);
    end
catch
    [ex_file,ex_path]=uiputfile('*.mat');
end
if ex_file==0
    disp('Export cancelled!')
    return
end
handles.din.ex_path=ex_path;
guidata(handles.figure1,handles);
save([ex_path,ex_file],'export_data','metadata');
disp(['Data saved and exported to: ',ex_path,ex_file])
set(handles.status,'string',['Status: Data saved and exported to: ',ex_path,ex_file]);


% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)
% Confirm with user that data will be cleared
button=questdlg('Are you sure you want to clear all datapoints?');
switch button
    case 'No'
        return
    case 'Cancel'
        return
end
%check to see if fieldname exists
if isfield(handles,'select')==0
    return
end
names=fieldnames(handles.din.select);
for dum=1:length(names)
    delete(handles.din.select.(names{dum}));    
end

if isfield(handles.din,'select')
    handles.din=rmfield(handles.din,'select');
end
handles.din.num_pts=0;
refresh_Callback(hObject, eventdata, handles)
guidata(handles.figure1,handles);
disp('Selected datapoints cleared!');
set(handles.status,'string','Status: Selected datapoints cleared!');
