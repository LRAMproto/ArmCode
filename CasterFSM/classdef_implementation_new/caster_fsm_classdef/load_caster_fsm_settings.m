function output_param = load_caster_fsm_settings(parameter)
%% Settings of Casting State Machine
% The following generates an appropriate parameter based upon which casting
% thing is being used.
%
% 

%% Stoppped
% Casting robot starts at a stopped state.

%% Stopped state.
caster.states.stopped = 1;
caster.outputs.stopped = 1;

%% Rearming

% Rearming state.
caster.states.rearming = 2;
caster.outputs.rearming = 2;

%% Ready
% Ready state.
caster.states.ready = 3;
caster.outputs.ready = 3;

%% Accelerating
% Accelerating state.
caster.states.accelerating = 4;
caster.outputs.accelerating = 4;

%% Releasing
% Releasing state.
caster.states.spooling = 5;
caster.outputs.spooling = 5;

%% Wrapping
% Wrapping State.
caster.states.wrapping = 6;
caster.outputs.wrapping = 6;

%% Defined inputs
caster.inputs.reset =           1;
caster.inputs.done_rearming =   2;
caster.inputs.fire =            3;
caster.inputs.freeflightclear = 4;
caster.inputs.attarget =        5;
caster.inputs.done_casting = 6;
caster.inputs.error =           7;

%% Initial State
% Change this if you want the casting robot to be stopped at a different
% state.

caster.init_state = caster.states.stopped;

%% Output Functions
caster.output_functions = [...
    [caster.states.stopped,caster.outputs.stopped];...
    [caster.states.rearming,caster.outputs.rearming];...
    [caster.states.ready,caster.outputs.ready];...
    [caster.states.accelerating, caster.outputs.accelerating];...    
    [caster.states.spooling, caster.outputs.spooling];...
    [caster.states.wrapping,caster.outputs.wrapping];...    
    ];

%% Next-State Transitions
caster.next_state_transitions = [...
    [caster.states.stopped, caster.inputs.reset, caster.states.rearming];...
    [caster.states.rearming, caster.inputs.done_rearming, caster.states.ready];...
    [caster.states.ready, caster.inputs.fire, caster.states.accelerating];...
    [caster.states.accelerating, caster.inputs.freeflightclear, caster.states.spooling];...
    [caster.states.spooling, caster.inputs.attarget, caster.states.wrapping];...
    [caster.states.wrapping, caster.inputs.done_casting, caster.states.stopped'];];

%% Error Transitions
caster.error_transitions = [...
    [caster.inputs.error, caster.states.stopped];...
    ];

%% Absolute Next-State Transitions
% None defined at present.

caster.absolute_transitions = [];

%% Giving the appropriate parameter based upon input.

if nargin == 1
switch lower(parameter)
    case 'initial state'
        output_param = caster.init_state;
    case 'output functions'
        output_param = caster.output_functions;
    case 'next state transitions'
        output_param = caster.next_state_transitions;
    case 'error transitions'
        output_param = caster.error_transitions;
    case 'absolute next state transitions'
        output_param = caster.absolute_transitions;
    otherwise
        output_param = [];
end
else
    % Loads all settings as a struct if no output is given.
    output_param = caster;
end

end