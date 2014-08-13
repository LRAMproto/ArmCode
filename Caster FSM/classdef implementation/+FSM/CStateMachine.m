classdef CStateMachine < hgsetget
% Alternate state machine in a compileable form.
%#ok<*NBRAK>    

    properties
        name = 'Undefined State Machine'
        % Name of the state machine. (char)        
        currentState = -1
        % Current State of the state machine. (int)        
        % by default, -1 indicates that a state has not been set.
        initState = -1
        stateEnums = [-1];
        transInitStates = [-1]
        % initial states of transitions (char)
        transInpts = [-1]
        % inputs
        transNextStates = [-1]
        % outputs        
    end
    
    methods
        function obj = CStateMachine(name, initState)
            obj.name = name;
            obj.currentState = initState;
            obj.initState = initState;
            obj.AddState(initState);
        end
        
        function AddState(obj,newState)
            obj.stateEnums = [obj.stateEnums,newState];
        end
    end
    
end

