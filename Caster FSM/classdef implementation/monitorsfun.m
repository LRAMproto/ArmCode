% S-Function which specifies the behavior of a monitor object to work in
% tandem with a state machine in fsm_model.
% This s-function sends a signal to the state machine depending upon what 
% its input value is.

function monitorsfun(block)
setup(block);
end

function setup(block)

block.numInputPorts = 1;
block.numOutputPorts = 0;

block.RegBlockMethod('Start',@Start);
block.RegBlockMethod('Update',@Update);
block.SampleTimes = [-1, 0];

end

function Start(block)

end


function Update(block)

caster = get_param('fsm_model/STATE MACHINE','UserData');
if ~isempty(caster) && ~caster.inTransition
    caster.SendSignalEnum(block.InputPort(1).Data);
end
end
