classdef StateChangeEventData < event.EventData
    % FSM.StateChangeEventData
    % Event Data for the given state machine.
    
    properties
        stateMachine
        % The source of the event.
        currentState
        % The current state.
        input
        % The last state.
        lastState
    end
    
    methods
        function obj = StateChangeEventData(...
                stateMachine, currentState, input, lastState)
            obj.stateMachine = stateMachine;
            obj.currentState = currentState;
            obj.input = input;
            obj.lastState = lastState;
        end
    end
    
end

