function statemachinesfun(block)
    setup(block);
end

function setup(block)

block.numInputPorts = 0;
block.numOutputPorts = 1;
block.OutputPort(1).Dimensions = 1;
block.OutputPort(1).SamplingMode = 'sample';
block.RegBlockMethod('Start',@Start);
block.RegBlockMethod('Update',@Update);
block.SampleTimes = [ 0 0 ];

end

function Start(block)
    if ~isempty(get_param(gcb,'UserData'))
        connectStateMachine();
    end
end


function Update(block)

caster = get_param(gcb,'UserData');
block.OutputPort(1).Data = caster.stateID;

end
