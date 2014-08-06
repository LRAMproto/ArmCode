function caster = caster_fsm_setup()
    % States
    
    STOPPED = FSM.State(0,'Stopped');
    REARM = FSM.State(1,'Rearming');
    READY = FSM.State(2,'Rearming');
    ACCEL = FSM.State(3,'Accelerating');
    SPOOL = FSM.State(4,'Spooling');
    WRAP = FSM.State(5,'Wrapping');

    states = [STOPPED, REARM, READY, ACCEL, SPOOL, WRAP];
    
    INIT_STATE = STOPPED;
    
    caster = FSM.StateMachine('Caster',INIT_STATE);
    set(caster,'ignoreDuplicateInput',true);
    
    caster.AddTransition(FSM.Transition(STOPPED,'Reset',REARM));
    caster.AddTransition(FSM.Transition(REARM,'Done',READY));
    caster.AddTransition(FSM.Transition(READY,'Fire',ACCEL));
    caster.AddTransition(FSM.Transition(ACCEL,'FreeFlightClear',SPOOL));
    caster.AddTransition(FSM.Transition(SPOOL,'AtTarget',WRAP));
    caster.AddTransition(FSM.Transition(WRAP,'Done',STOPPED));
    caster.AddAbsTransition('Error',STOPPED,@DangerWillRobinsonDanger);
    
end

function DangerWillRobinsonDanger
fprintf('<strong>DANGER, WILL ROBINSON! DANGER</strong>\n');
end
