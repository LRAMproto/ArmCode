function test_caster_fsm_settings()
%% Dry test of running through all FSM settings.
settings = load_caster_fsm_settings;

caster = FSM2.StateMachine();

LoadSettingsTest(settings, caster);

StartupTest(settings, caster);

InputTest(settings, caster);

disp(caster);

end

function LoadSettingsTest(settings, caster)
caster.AddNST(load_caster_fsm_settings('Next State Transitions'));
caster.AddNST(load_caster_fsm_settings('Absolute Next State Transitions'));
caster.AddErrorNST(load_caster_fsm_settings('Error Transitions'));
caster.AddOutputFcn(load_caster_fsm_settings('Output Functions'));
end

function StartupTest(settings, caster)
caster.Initialize(load_caster_fsm_settings('Initial State'));
assert(caster.GetCurrentState() == settings.init_state);
assert(caster.GetOutput() == settings.outputs.stopped);

end

function InputTest(settings, caster)

caster.SendInput(settings.inputs.reset);
assert(caster.GetCurrentState == settings.states.rearming);
assert(caster.GetOutput() == settings.outputs.rearming);

caster.SendInput(settings.inputs.done_rearming);
assert(caster.GetCurrentState() == settings.states.ready);
assert(caster.GetOutput() == settings.outputs.ready);

caster.SendInput(settings.inputs.fire);
assert(caster.GetCurrentState == settings.states.accelerating);
assert(caster.GetOutput() == settings.outputs.accelerating);

caster.SendInput(settings.inputs.freeflightclear);
assert(caster.GetCurrentState == settings.states.spooling);
assert(caster.GetOutput() == settings.outputs.spooling);

caster.SendInput(settings.inputs.attarget);
assert(caster.GetCurrentState == settings.states.wrapping);
assert(caster.GetOutput() == settings.outputs.wrapping);

caster.SendInput(settings.inputs.done_casting);
assert(caster.GetCurrentState() == settings.states.stopped);
assert(caster.GetOutput() == settings.outputs.stopped);

%% Do sequence again but introduce error.

caster.SendInput(settings.inputs.reset);
assert(caster.GetCurrentState == settings.states.rearming);
assert(caster.GetOutput() == settings.outputs.rearming);

caster.SendInput(settings.inputs.done_rearming);
assert(caster.GetCurrentState() == settings.states.ready);
assert(caster.GetOutput() == settings.outputs.ready);

caster.SendInput(settings.inputs.fire);
assert(caster.GetCurrentState == settings.states.accelerating);
assert(caster.GetOutput() == settings.outputs.accelerating);

caster.SendInput(settings.inputs.error);
assert(caster.GetCurrentState() == settings.states.stopped);
assert(caster.GetOutput() == settings.outputs.stopped);

end