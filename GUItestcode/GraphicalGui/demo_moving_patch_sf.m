% Author: David Rebhuhn
% Date: 1/31/2014

% DEMO_MOVING_PATCH_SF.M
% The following code controls the behavior of a matlab level 2 S-Function.
% As I understand it: when you type this function name as a dialog
% parameter (double clicking on any simulink block will give areas to fill
% in variables called 'dialog parameters') of the Matlab Level 2 S Function
% block, it will be called and the base operations will do the initial
% setup BEFORE runtime.
%

%
% Description: A Matlab function which runs the initial setup of base block
% properties (number of inputs and outputs, dialog parameters, registered
% block methods)
%
% Preconditions: a valid block is passed (automatically done when user
% enters this function's name into the 'S-function name' parameter of the
% MATLAB Level-2 S-Function Block.

% level 2 s-function block in a simulink model.
% Postconditions: block is set up with conditions specified.
%
function demo_moving_patch_sf(block)

    % A wrapper function (demo1_sf()) calls the 'setup' function, allowing this
    % s-function on the matlab path to be found.
    
    setup(block);

    % After you hit 'apply', the setup() function will be called and
    % everything will be set up for you to proceed with linking other
    % blocks to it.

end % demo1_sf(block)

%
% Description: 
% Preconditions: a valid block is passed (automatic)
% Postconditions: simulink sets up the block with the required parameters.
%

function setup(block)
% The following setup function is sort of a 'bare bones' approach. It does
% not contain every single possible variable you might want for more
% advanced functions, but it makes it clear which code can run in order to 
% get the basic functionality
% going.

    % Dialog Parameters specify special variables we want to use before the
    % simulation runs. This demo doesn't use them.
    block.NumDialogPrms = 0;
    % 
    
    % The number of input ports to the block. If you ever want to change
    % this, you can either run the simulation or re-submit the dialog
    % parameters to the block.

    block.NumInputPorts = 1; % current arm position

    % Input ports may recieve input in the form of vectors. Here, however,
    % only a single variable is being input.
    
    block.InputPort(1).Dimensions = 1;
    block.InputPort(1).SamplingMode = 'Sample';
    block.InputPort(1).DatatypeID = 0;   
    % see
    % http://www.mathworks.com/help/fixedpoint/ug/data-type-ids.html
    % for a list of all possible data types. 
    %

    % The number of output ports in the block. When you enter this function
    % into the dialog parameters, the block will automatically create this,
    % allowing you to output a variable.
    
    block.NumOutputPorts = 1;   
    
    % Output port is set here to read output from the display.
    
    block.OutputPort(1).Dimensions = 1;
    block.OutputPort(1).SamplingMode = 'Sample';
    block.OutputPort(1).DatatypeID = 0;
    
    % As I understand it, block methods have to be registered in order for
    % the block to call them on its own.
    
    block.RegBlockMethod('Update',@Update);
    block.RegBlockMethod('Start', @Start);
    

    % The following methods are not being used for this demo. I have kept
    % them here for later use.
   
    block.RegBlockMethod('InitializeConditions',@InitConditions);
    block.RegBlockMethod('PostPropagationSetup',@DoPostPropSetup);
    block.RegBlockMethod('Outputs', @Outputs);
    %block.RegBlockMethod('SetInputPortSamplingMode',@SetInputPortSamplingMode);
    
end
%
% Description: This is what happens when the simulation starts.
% Preconditions: S-Function name is supplied in S-Function block
% successfully; Simulink Simulation has started successfully.
% Postconditions: A figure window is open and the Userdata field of the
% block captures the figure window for use in the Update function.
%
function Start(block)
    % My current implementation is that the s-function calls the gui
    % function, sending in the block handle as an argument. It then returns
    % the handle for a figure window, which and uses the set_param API to 
    % load the figure window onto a variable in the block called 'UserData'
    % however, this will likely be replaced with an event-listener routine,
    % to be described in another demo.
    
    % Starts up the GUI and returns the handle of the figure that was
    % instantiated.
    %fig = patGUI(); %deprecated
    fig = armdrag_gui();
    % Sets the 'userdata' parameter of the figure to the newly instantiated
    % model.
    set_param(gcb,'Userdata',fig);
end


%
% Description: Updates the simulation 
% Preconditions: simulation is loaded.
% Postconditions: S function updates the figure window and retrieves data
% from it.
%
function Update(block)
    % Retrieves data about the figure window that is currently open.
    fig = get_param(gcb,'Userdata');
    
    % Clones the handle structure of the current figure.
    handles = guidata(fig);
    % calls the 'setInputDisplay' function which adjusts the display as
    % needed.
    angle = handles.getAngle(handles);
    handles.setCurrentArmPosition(handles,block.InputPort(1).Data);
    block.Dwork(1).Data = angle;
    guidata(fig, handles);
    
end


%
% Description: Specifies information concerning 'DWorks', variables stored
% by the block during runtime. During runtime, Dworks do not change unless
% externally set, and are thus useful for functions such as toggling or
% keeping score.
% Preconditions: block is properly loaded into simulation; simulation has
% begun.
% Postconditions: storage area for block variables is created and ready for
% use.
%    

function DoPostPropSetup(block)

    block.NumDworks = 1;

    block.Dwork(1).Name = 'angledata';
    block.Dwork(1).Dimensions = 1;
    block.Dwork(1).DatatypeID = 0;
    block.Dwork(1).Complexity = 'Real';
    block.Dwork(1).UsedAsDiscState = false;

end

%
% Description: After specifying the Dwork , InitConditions sets the initial
% value for these variables to something reasonable
% Preconditions: block is properly loaded into simulation and simulation
% has begun
% Postconditions: DWORK variables are set to appropriate values.
%
function InitConditions(block)
    block.Dwork(1).Data = 0;
end

%
% Description: Configures output data of the block.
% Preconditions: block is properly loaded into simulation and simulation
% has begun
% Postconditions: block outputs the appropriate value.
%

function Outputs(block)
    block.OutputPort(1).Data = block.Dwork(1).Data;
end

%
% Description: I am fuzzy on the exact details of how this works, but it
% appears that if you want multiple input ports, you have to include this
% function, even if its not implemented in any fashion, to get simulink to
% stop complaining.
% Preconditions: same as above
% Postconditions: input port sampling mode is set?
%
function SetInputPortSamplingMode(block)
end
