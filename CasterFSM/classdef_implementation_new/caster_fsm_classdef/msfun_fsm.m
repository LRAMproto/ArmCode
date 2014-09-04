function msfun_fsm(block)
% A MATLAB Level-2 S-Function which uses a defined class
% (FSM2.StateMachine) in order to function.
setup(block)
end

function setup(block)
% Sets structure of ports, etc.
block.NumInputPorts = 1; % input signal
block.NumOutputPorts = 3; % state, inTransition, output
block.NumDialogPrms = 6;

block.RegBlockMethod('SetInputPortSamplingMode',@SetInputPortSamplingMode);
block.RegBlockMethod('Start',@Start);
block.RegBlockMethod('Update',@Update);
block.RegBlockMethod('Outputs',@Outputs);
block.RegBlockMethod('CheckParameters',@CheckParameters);
block.SupportsMultipleExecInstances = true;
ConfigureOutputs(block)
end

function ConfigureOutputs(block)
mode = 0;
for port = 1:block.NumOutputPorts
    block.OutputPort(port).Dimensions = 1;
    block.OutputPort(port).SamplingMode = mode;
end
block.OutputPort(1).DataTypeID = 0; % Double
block.OutputPort(2).DataTypeID = 8; % Boolean
block.OutputPort(3).DataTypeID = 0; % Double
end

function SetInputPortSamplingMode(block,port,mode)
block.InputPort(port).SamplingMode = mode;
end

function CheckParameters(block)
% Checks to see whether the dialog parameters for this FSM block are valid.
% They will return errors visible from the top-level simulink program if
% they are invalid.

%% Loading various parameters
outs = block.DialogPrm(2).data;
% Loading output functions

nsts = block.DialogPrm(1).data;
% Loading next-state transitions

ansts = block.DialogPrm(4).data;
% Loading absolute next-state transitions

ensts = block.DialogPrm(6).data;

%% Checking output functions.

% Checks to see if it is numeric.
if ~isnumeric(outs)
    error(['Outputs must be a numerical matrix ',...
        'of the form [[s1,o1]; [s2,o2]; ...]']);
end

% determines if output size is correct.
if isempty(outs) && (~isempty(nsts) || ~isempty(ansts));
    error('No output symbols defined.');
else
    % determines if output functions are structured properly.
    sz = size(outs);
    if sz(2) ~= 2
        error(['Dimensions incorrect on output functions. ',...
            'Output functions must be an Nx2 array, with ',...
            'rows of states and output symbols in the form ',...
            '[[s1,o1];[s2,o2];...].']);
    end
end

% The following runs checks on NSTs

if ~isnumeric(nsts)
    error(...
        ['Next-state transitions must be an N-by-3 numerical array',...
        'in the form of [[s1,i1,o1];[s2,i2,o2],...]']);
end

sz = size(nsts);

if ~isempty(nsts)
    if sz(2) ~= 3
        error(...
            ['Dimensional mismatch on NSTS. ',...
            'Every NST must be an Nx3 array of states, ',...
            'input symbols, and transitions.']);
    end
end

% The following checks error transitions. These are functionally
% indistinguishable from normal transitions except they are checked first.


if ~isnumeric(ensts)
    error(['Error transitions must be an N-by-2 numerical array,'...
        'in the form of [[i1,o1];[i2,o2],...]']);
end

sz = size(ensts);

if ~isempty(ensts)
    if sz(2) ~= 2
        error(...
            ['Dimensional mismatch on NSTS. ',...
            'Every error transition must be an Nx2 array of states, ',...
            'input symbols, and transitions.']);
    end
end

% The following runs checks on NSTs

if ~isnumeric(ansts)
    error(['Next-state transitions must be an N-by-3 numerical array,'...
        'in the form of [[s1,i1,o1];[s2,i2,o2],...]']);
end

sz = size(ansts);

if ~isempty(ansts) && sz(2) ~= 2
    error(...
        ['Dimensional mismatch on ANSTS. Every ANST must be an ',...
        'nx2 array of input symbols and transitions.']);
end


% The following checks the initial state to see if it is valid.

initState = block.DialogPrm(3).data;
if ~isnumeric(initState)
    error('Initial state is not a numeric value.');
elseif ~isequal(size(initState),[1,1])
    error('Initial state must be a single numerical value.');
end

%
% Note that these are defined as empty matrices beforehand because
% attempting to access the second member of an empty array yields an error.

ansts_outs = [];
nsts_outs = [];

if ~isempty(ansts)
    ansts_outs = ansts(:,2)';
end
if ~isempty(nsts)
    nsts_outs = unique([nsts(:,1)',nsts(:,3)']);
end

% Finds all states.
all_states = unique([nsts_outs, ansts_outs, initState]);

% Finds all states that are not matched with an output
leftovers = setdiff(all_states,outs(:,1));

% If there are leftover states, an error is issued.
if ~isempty(leftovers)
    lstr = sprintf('%d,',leftovers');
    error(...
        ['The following states (',...
        lstr,...
        ') do not have an output symbol defined.'...
        'Please define them in "Output Functions" ', ...
        'in the form [[s1,o1];[s2,o2];...]']);
end

% There is no point in checking whether ignoreRepeatedInputs is valid at
% the moment: if there is, write it here:
%
% irp = block.DialogPrm(5).data;
%
% ...
%
% **********

end

function Start(block)
fsm = FSM2.StateMachine();
nsts = block.DialogPrm(1).data;
outs = block.DialogPrm(2).data;
initState = block.DialogPrm(3).data;
ansts = block.DialogPrm(4).data;
irp = block.DialogPrm(5).data;
ensts = block.DialogPrm(6).data;
fsm.AddNST(nsts);
fsm.AddNST(ansts);
fsm.AddOutputFcn(outs);
fsm.AddErrorNST(ensts);
fsm.Initialize(initState);
fsm.ignoreRepeatedInputs = irp;
set_param(gcb,'userdata', fsm);

end

function Update(block)
fsm = get_param(gcb,'userdata');
fsm.SendInput(block.InputPort(1).data);

end

function Outputs(block)
fsm = get_param(gcb,'userdata');
block.OutputPort(1).Data = fsm.GetCurrentState();
block.OutputPort(2).Data = fsm.IsInTransition();
block.OutputPort(3).Data = fsm.GetOutput();
end