classdef CasterStateMachine < hgsetget
    %CASTERSTATEMACHINE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name = 'Caster';
        state = 'READY';
        stateID = 1;
        % Event Listeners
        
        fireFcn;
        releaseFcn;
        freeFlightCheckFcn;
        atGoalFcn;
        errorFcn;
        resetFcn;
        doneFcn;
        
        fireEventListener;
        releaseEventListener;
        freeFlightCheckEventListener;
        atGoalListener;
        errorListener;
        resetListener;
        doneListener;
    end
    
    methods
        function obj = CasterStateMachine(state)
            obj.state = state;
            obj.setStateID();
        end
        
        function obj = set.state(obj,val)
            obj.state = val;
            obj.setStateID();
        end
        
        function setStateID(obj)
            switch obj.state
                case 'READY'
                    obj.stateID = 1;
                case 'ACCEL'
                    obj.stateID =2;
                case 'RELEASE'
                    obj.stateID = 3;
                case 'SPOOL'
                    obj.stateID = 4;
                case 'WRAP'
                    obj.stateID = 5;                    
                case 'STOP'
                    obj.stateID = 6;
                case 'REARM'
                    obj.stateID = 7;
            end
        end
        
   
    function disp(obj)
    fprintf('%s, State: %s\n',obj.name, obj.state);
    end
    
    function Initialize(obj)
    obj.fireEventListener = addlistener(obj,'Fire',obj.fireFcn);
    obj.releaseEventListener = addlistener(obj,'Release',obj.releaseFcn);
    obj.freeFlightCheckEventListener = addlistener(obj,'FreeFlightCheck',obj.freeFlightCheckFcn);
    obj.atGoalListener = addlistener(obj,'AtGoal',obj.atGoalFcn);
    obj.errorListener = addlistener(obj,'Error',obj.errorFcn);
    obj.resetListener = addlistener(obj,'Reset',obj.resetFcn);
    obj.doneListener = addlistener(obj,'Done',obj.doneFcn);
    end
end

events
    Fire
    Release
    FreeFlightCheck
    AtGoal
    Error
    Reset
    Done
end

end

