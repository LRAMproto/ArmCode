classdef Transition < hgsetget
% FSM.Transition
% Transition for FSM.StateMachine.
    
    properties
        initialState
        % initial condition (FSM.State, '*' if absolute transition.
        input
        % input (char)
        nextState
        % next state (FSM.State)
        output
        % Output (function_handle)
        isAbsolute = false
        % Tells you whether the function is an absolute rule (instructing
        % the FSM to ignore the initial state).
        
    end
    
    methods
        function obj = Transition(initialState, input, nextState, output)
            obj.initialState = initialState;
            obj.input = input;
            if nargin > 2
                obj.nextState = nextState;
            end
            if nargin > 3
                obj.output = output;
            end
        end
        
        function disp(obj)
            for k=1:length(obj)
                fprintf('<strong>Transition Rule:</strong>\n');
                fprintf('\t<strong>Initial State:</strong> ');
                disp(obj(k).initialState);
                fprintf('\t<strong>Input:</strong> ');
                disp(obj(k).input);
                fprintf('\t<strong>Next State: </strong>');
                disp(obj(k).nextState);
                fprintf('\t<strong>Output:</strong> ');
                if isempty(obj(k).output)
                    fprintf('none');
                end
                disp(obj(k).output);
                fprintf('\n');
            end
        end
        
        function result = MatchesAbs(obj,other)
            % Determines the inputs of two transitions are the same, and if
            % they are both absolute rules.
            if (obj.isAbsolute || other.isAbsolute) ...
                    && isequal(obj.input,other.input)
                result = true;
            else
                result = false;
            end
        end
        
        function result = Matches(obj,other)
            % Determines if a defined rule's intial state and input match.
            if isequal(obj.initialState,other.initialState) ...
                    && isequal(obj.input,other.input)
                result = true;
            else
                result = false;
            end
        end
        
    end
    
end

