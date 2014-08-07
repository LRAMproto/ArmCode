classdef StateChangeEventData < event.EventData
    % FSM.StateChangeEventData
    % Eventdata structure for use in interpreting StateChange events of
    % objects of type FSM.StateMachine.
    
    properties
        stateMachine
        % The source of the event. (FSM.StateMachine)
        currentState
        % The current state. (FSM.State)
        input
        % The last input. (char)
        lastState
        % The previous state (FSM.State)
    end
    
    methods
        function obj = StateChangeEventData(...
                stateMachine, currentState, input, lastState)
            % Defines the eventdata structure.
            obj.stateMachine = stateMachine;
            obj.currentState = currentState;
            obj.input = input;
            obj.lastState = lastState;
        end
    end
    
end

