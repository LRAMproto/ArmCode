function statemachinesfun(block)
setup(block);
end

function setup(block)

block.numInputPorts = 0;
block.numOutputPorts = 2;

block.OutputPort(1).Dimensions = 1;
block.OutputPort(1).DataTypeID = 6;
block.OutputPort(1).SamplingMode = 'sample';

block.OutputPort(2).Dimensions = 1;
block.OutputPort(2).SamplingMode = 'sample';
block.OutputPort(2).DataTypeID = 8;

block.RegBlockMethod('Start',@Start);
block.RegBlockMethod('Update',@Update);
block.SampleTimes = [ 0 0 ];

connectStateMachine('fsm_model/STATE MACHINE');
end

function Start(block)
if isempty(get_param('fsm_model/STATE MACHINE','UserData'))
    connectStateMachine('fsm_model/STATE MACHINE');
end
end


function Update(block)

caster = get_param('fsm_model/STATE MACHINE','UserData');
block.OutputPort(1).Data = caster.currentState.id;
block.OutputPort(2).Data = caster.inTransition;

end
