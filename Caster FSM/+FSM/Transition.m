classdef Transition < hgsetget
% FSM.Transition
% Transition for FSM.StateMachine
    
    properties
        initialState
        input
        nextState
        output
        absolute = false
        
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
            if (obj.absolute || other.absolute) && isequal(obj.input,other.input)
                result = true;
            else
                result = false;
            end
        end
        function result = Matches(obj,other)
            if isequal(obj.initialState,other.initialState) ...
                    && isequal(obj.input,other.input)
                result = true;
            else
                result = false;
            end
        end
        
    end
    
end

