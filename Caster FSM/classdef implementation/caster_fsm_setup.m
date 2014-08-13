function caster = caster_fsm_setup()
% Sets up the casting robot's state machine data structure. This can be
% done standalone or as part of a Simulink simulation.

% Defined States

STOPPED = FSM.State(0,'Stopped');
REARM = FSM.State(1,'Rearming');
READY = FSM.State(2,'Ready');
ACCEL = FSM.State(3,'Accelerating');
SPOOL = FSM.State(4,'Spooling');
WRAP = FSM.State(5,'Wrapping');

states = [STOPPED, REARM, READY, ACCEL, SPOOL, WRAP];

INIT_STATE = STOPPED;

caster = FSM.StateMachine('Caster',INIT_STATE);

set(caster,'ignoreDuplicateInput',true);
% Tells FSM to ignore duplicate info.

% Adding and enumerating transitions:
% Basically goes as follows:
% * Each transition is defined and added to a list of transitions.
% * Each transition we WANT TO enumerate (for ease of use in Simulink, ui
%   controls, etc, is enumerated.
caster.AddTransition(FSM.Transition(STOPPED,'Reset',REARM));
caster.EnumInput('Reset',1);

caster.AddTransition(FSM.Transition(REARM,'Done',READY));
caster.EnumInput('Done',2);

caster.AddTransition(FSM.Transition(READY,'Fire',ACCEL));
caster.EnumInput('Fire',3);

caster.AddTransition(FSM.Transition(ACCEL,'FreeFlightClear',SPOOL));
caster.EnumInput('FreeFlightClear',4);

caster.AddTransition(FSM.Transition(SPOOL,'AtTarget',WRAP));
caster.EnumInput('AtTarget',5);

caster.AddTransition(FSM.Transition(WRAP,'Done',STOPPED));

% If you want a seperate 'done' here, uncomment.
% caster.AddTransition(FSM.Transition(WRAP,'DoneSimulation',STOPPED));
%caster.EnumInput('DoneSimulation',6);

caster.AddAbsTransition('Error',STOPPED,@DangerWillRobinsonDanger);
caster.EnumInput('Error',7);
% Error is an absolute transition, meaning any initial state, given the
% 'Error' signal, will transition to STOPPED.
end

function DangerWillRobinsonDanger
% Demonstrating use of the output error function.
% May add in paramets such as current state or something depending on 
% helpfulness.
fprintf('<strong>DANGER, WILL ROBINSON! DANGER</strong>\n');
end
