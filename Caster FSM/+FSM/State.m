classdef State < hgsetget
    % Current state of a state machine.
    properties
        id
        % Identification of a given state (int32).
        name
        % Name of a given state (char).
    end
    
    methods
        function obj = State(id, name)
            % Initializes the state. Note that names do not have to be
            % defined.
            obj.id = int32(id);
            if nargin > 1
                obj.name = name;
            end
        end
        
        function disp(obj)
            % Custom Display Function.
            fprintf('State: %d (%s)\n',obj.id, obj.name);
        end
        
    end
end
