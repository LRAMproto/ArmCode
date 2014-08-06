function connectStateMachine(block_handle)
caster = caster_fsm_setup();
set_param(block_handle,'Userdata',[]);
set_param(block_handle,'Userdata',caster);
end

