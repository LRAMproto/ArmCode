function monitor(block)
setup(block);
end

function setup(block)

block.numInputPorts = 1;
block.numOutputPorts = 0;

% block.OutputPort(1).Dimensions = 1;
% block.OutputPort(1).DataTypeID = 6;
% block.OutputPort(1).SamplingMode = 'sample';
%
% block.OutputPort(2).Dimensions = 1;
% block.OutputPort(2).SamplingMode = 'sample';
% block.OutputPort(2).DataTypeID = 8;

block.RegBlockMethod('Start',@Start);
block.RegBlockMethod('Update',@Update);
block.SampleTimes = [ 0 0 ];

end

function Start(block)

end


function Update(block)

caster = get_param('fsm_model/STATE MACHINE','UserData');
if ~isempty(caster)
    if caster.inTransition == false
        switch block.InputPort(1).Data
            case 1
                caster.SendSignal('Reset');
            case 2
                caster.SendSignal('Done');
            case 3
                caster.SendSignal('Fire');
            case 4
                caster.SendSignal('FreeFlightClear');
            case 5
                caster.SendSignal('AtTarget');
            case 6
                caster.SendSignal('Done');
            case 7
                caster.SendSignal('Error');
        end
    end
end
end
