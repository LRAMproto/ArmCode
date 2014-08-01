function varargout = statecontrol(varargin)
% STATECONTROL MATLAB code for statecontrol.fig
%      STATECONTROL, by itself, creates a new STATECONTROL or raises the existing
%      singleton*.
%
%      H = STATECONTROL returns the handle to a new STATECONTROL or the handle to
%      the existing singleton*.
%
%      STATECONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STATECONTROL.M with the given input arguments.
%
%      STATECONTROL('Property','Value',...) creates a new STATECONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before statecontrol_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to statecontrol_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help statecontrol

% Last Modified by GUIDE v2.5 31-Jul-2014 16:07:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @statecontrol_OpeningFcn, ...
    'gui_OutputFcn',  @statecontrol_OutputFcn, ...
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


% --- Executes just before statecontrol is made visible.
function statecontrol_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to statecontrol (see VARARGIN)

% Choose default command line output for statecontrol
handles.output = hObject;
connectStateMachine();
handles.stateMachine = get_param('statemdemo/STATE MACHINE','UserData');
UpdateInterface(hObject, eventdata, handles);
set(handles.stateDisplay,'String',handles.stateMachine.state);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes statecontrol wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = statecontrol_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in firebutton.
function firebutton_Callback(hObject, eventdata, handles)
% hObject    handle to firebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch handles.stateMachine.state
    case 'READY'
        notify(handles.stateMachine,'Fire');
        set(handles.firebutton,'String','Release');
    case 'ACCEL'
        notify(handles.stateMachine,'Release');
        notify(handles.stateMachine,'FreeFlightCheck');
        set(handles.firebutton,'String','Goal Reached');        
    case 'RELEASE'
        notify(handles.stateMachine,'FreeFlightCheck');
        set(handles.firebutton,'String','Goal Reached');
    case 'SPOOL'
        notify(handles.stateMachine,'AtGoal');
        set(handles.firebutton,'String','Done');
    case 'WRAP'
        notify(handles.stateMachine,'Done');
        set(handles.firebutton,'String','Reset');
    case 'STOP'
        notify(handles.stateMachine,'Reset');
        set(handles.firebutton,'String','Rearm');
    case 'REARM'
        notify(handles.stateMachine,'Done');
        set(handles.firebutton,'String','Fire!');
end
set(handles.stateDisplay,'String',handles.stateMachine.state);
UpdateInterface(hObject, eventdata, handles);


function UpdateInterface(hObject, eventdata, handles)
switch handles.stateMachine.state
    case 'READY'
        set(handles.firebutton,'String','Fire!');
    case 'ACCEL'
        set(handles.firebutton,'String','Release!');        
    case 'RELEASE'
        set(handles.firebutton,'String','Wrap11!');
    case 'SPOOL'
        set(handles.firebutton,'String','Wrap!');
    case 'WRAP'
        set(handles.firebutton,'String','Stop');
    case 'STOP'
        set(handles.firebutton,'String','Reset');
    case 'REARM'
        set(handles.firebutton,'String','Done Rearming.');     
        
end



% --- Executes on button press in abortbutton.
function abortbutton_Callback(hObject, eventdata, handles)
% hObject    handle to abortbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('abort clicked');
notify(handles.stateMachine,'Error');
set(handles.firebutton,'String','Reset');

set(handles.stateDisplay,'String',handles.stateMachine.state);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if ~isempty(handles.stateMachine)
    notify(handles.stateMachine,'Error');
end
delete(hObject);
