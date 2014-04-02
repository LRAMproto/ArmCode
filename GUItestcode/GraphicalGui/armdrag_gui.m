function varargout = armdrag_gui(varargin)
% armdrag_gui MATLAB code for armdrag_gui.fig
%      armdrag_gui, by itself, creates a new armdrag_gui or raises the existing
%      singleton*.
%
%      H = armdrag_gui returns the handle to a new armdrag_gui or the handle to
%      the existing singleton*.
%
%      armdrag_gui('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in armdrag_gui.M with the given input arguments.
%
%      armdrag_gui('Property','Value',...) creates a new armdrag_gui or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the armdrag_gui before armdrag_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to armdrag_gui_OpeningFcn via varargin.
%
%      *See armdrag_gui Options on GUIDE's Tools menu.  Choose "armdrag_gui allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help armdrag_gui

% Last Modified by GUIDE v2.5 12-Feb-2014 13:29:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @armdrag_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @armdrag_gui_OutputFcn, ...
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


% --- Executes just before armdrag_gui is made visible.
function armdrag_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to armdrag_gui (see VARARGIN)

% Choose default command line output for armdrag_gui
handles.output = hObject;

a = .5;

handles.xorigin = [-a a a -a];
handles.yorigin = [-a-9 -a-9 a-9 a-9];
handles.trackline_current = line([0,0],[0,-9],'LineWidth',6,'Color',[0.7 0.7 0.7]);
handles.trackline = line([0,0],[0,-9],'LineWidth',6,'Color',[0.7 0.2 0.2]);
% handles.xtrackline = line([0,0],[-10,10],'LineWidth',2,'Color',[0.2 0.2 0.2]);
% handles.ytrackline = line([-10,10],[0,0],'LineWidth',2,'Color',[0.2 0.2 0.2]);
%handles.glove = line([0,0],[-5,-6],'LineWidth',15,'Color',[0.2 0.2 0.8]);
handles.theta = 0;

% handles.pat = patch('Parent',handles.axes1,...
%     'XData',handles.xorigin,...
%     'YData',handles.yorigin);

set(handles.trackline,'ButtonDownFcn',@PatButtonDown);
set(handles.figure1,'WindowButtonMotionFcn',@PatMotionFcn);
handles.drag = 0;
handles.clicked = 0;
handles.point = [0,0];
%view(handles.axes1,3)
handles.getXData = @getXData;
handles.getYData = @getYData;
handles.getAngle=@getAngle;
handles.setDragAngle=@setDragAngle;
handles.setCurrentArmPosition=@setCurrentArmPosition
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes armdrag_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = armdrag_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% Grabs the patch or releases it
function PatButtonDown(hObject, eventdata)
    handles = guidata(hObject);
    handles.drag = ~handles.drag;
    disp(handles.drag);
    guidata(hObject, handles);
    
function PatMotionFcn(hObject, eventdata)

fig = hObject;
handles = guidata(hObject);
if handles.drag == 1
curr_pt = get(handles.axes1, 'CurrentPoint');
% Convert current point to a polar system
x = curr_pt(1,1);
y = curr_pt(1,2);
disp_theta = atan2(y,x);    % Angle to be processesed by display
theta_cur  = atan2(x,-y);   % Actual angle
% disp(theta_cur);
disp(atan2(x,-y));
%[theta_cur, rho_cur] = cart2pol(x,y);
setDragAngle(fig,disp_theta);
setAngleDisplay(fig, theta_cur);
handles.theta = theta_cur;
guidata(fig, handles);

%handles.point = [curr_pt(1,1),curr_pt(1,2)];
%set(handles.trackline,'XData',[0,curr_pt(1,1)],'YData',[0,curr_pt(1,2)]);
%set(handles.xtrackline,'XData',[curr_pt(1,1),curr_pt(1,1)]);
%set(handles.ytrackline,'YData',[curr_pt(1,2),curr_pt(1,2)]);

%y = get(handles.pat,'YData');


%set(handles.pat,'XData',handles.xorigin+curr_pt(1,1),'YData',handles.yorigin+curr_pt(1,2));
end    

function setAngleDisplay(hObject, newangle)
    fig = hObject;
    handles = guidata(fig);
    set(handles.text1,'String',rad2deg(newangle));
    % guidata(handles);
    set(handles.slider2,'Value',rad2deg(newangle));


function setDragAngle(hObject, newangle)
    fig = hObject;
    handles = guidata(fig);
%     handles.theta = newangle;


    % Find out where it should be set to.

    % Converts trackline data to polar system
    XData_a =get(handles.trackline,'XData');
    YData_a =get(handles.trackline,'YData');
    %[theta_a, rho_a] = cart2pol(-YData_a(2),XData_a(2));
    [theta_a, rho_a] = cart2pol(XData_a(2),YData_a(2));
    % sets the current point's theta to the trackline's theta
%     setAngleDisplay(fig, newangle);
    [newlinex, newliney] = pol2cart(newangle, rho_a);
    set(handles.trackline,'XData',[0,newlinex],'YData',[0,newliney]);

    %XData_g =get(handles.glove,'XData');
    %YData_g =get(handles.glove,'YData');
    %[theta_g1, rho_g1] = cart2pol(XData_g(1),YData_g(1));
    %[theta_g2, rho_g2] = cart2pol(XData_g(2),YData_g(2));

    % sets glove data

    %[newgx(1), newgy(1)] = pol2cart(newangle, rho_g1);
    %[newgx(2), newgy(2)] = pol2cart(newangle, rho_g2);
    %set(handles.glove,'XData',newgx,'YData',newgy);
    guidata(fig, handles);


function angle = getAngle(handles)
angle = handles.theta;


function xdata = getXData(handles)
%xdata = get(handles.pat, 'XData');

function ydata = getYData(handles)
%ydata = get(handles.pat, 'YData');


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function setCurrentArmPosition(handles,newangle)

    % Find out where it should be set to.

    % Converts trackline data to polar system
    XData_c =get(handles.trackline_current,'XData');
    YData_c =get(handles.trackline_current,'YData');
    %[theta_a, rho_a] = cart2pol(-YData_a(2),XData_a(2));
    [theta_c, rho_c] = cart2pol(XData_c(2),YData_c(2));
    % sets the current point's theta to the trackline's theta
    %setAngleDisplay(fig, newangle); % We may want to update the current
    %angle
    [newlinex, newliney] = pol2cart(newangle-pi/2, rho_c);
    set(handles.trackline_current,'XData',[0,newlinex],'YData',[0,newliney]);

