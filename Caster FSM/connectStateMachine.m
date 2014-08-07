function connectStateMachine(block_handle)
% Connects the caster state machine to the given block's UserData field.
%
set_param(block_handle,'Userdata',[]);
% Clears the current FSM. This is important to do first if one is
% continually updating the class definition.
caster = caster_fsm_setup();
% Sets up the new fsm.
set_param(block_handle,'Userdata',caster);
% Adds the new FSM to Userdata.
end

