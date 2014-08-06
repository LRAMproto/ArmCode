classdef State
    % Current state of a state machine.
    properties
        id
        name
    end
    
    methods
        function obj = State(id, name)
            obj.id = int32(id);
            if nargin > 1
                obj.name = name;
            end
        end
        
        function disp(obj)
            fprintf('State: %d (%s)\n',obj.id, obj.name);
        end
        
    end
end
