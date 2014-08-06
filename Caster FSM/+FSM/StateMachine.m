classdef StateMachine < hgsetget
    % FSM.StateMachine
    % Classes that modifies a given state machine.
    
    properties
        name
        currentState
        transitions = [];
        inTransition = false;
        ignoreDuplicateInput = false;
        lastInput = [];
        
    end
    
    methods
        
        function obj = StateMachine(name, currentState)
            obj.name = name;
            obj.currentState = currentState;
        end
        
        function AddTransition(obj,newTransition)
            % Adds a transition if appropriate.
            if isempty(obj.transitions)
                obj.transitions = newTransition;
            else
                obj.transitions = [obj.transitions, newTransition];
            end
        end
        
        function AddAbsTransition(obj, input, nextState, output)
            % Adds a transition if appropriate.
            if nargin > 3
                newTransition = FSM.Transition('*',input,nextState,output);
                
            else
                newTransition = FSM.Transition('*',input,nextState);
            end
            newTransition.absolute = true;
            
            obj.AddTransition(newTransition);
            
        end
        
        function disp(obj)
            fprintf('<strong>Name:</strong> %s\n',obj.name);
            fprintf('<strong>Current State:</strong> ');
            disp(obj.currentState);
            fprintf('<strong>Transitions:</strong> \n');
            disp(obj.transitions);
        end
        
        function SendSignal(obj,input)
            % Sends an appropriate signal.
            if ~isequal(obj.lastInput,input) || ~(obj.ignoreDuplicateInput)
                
                obj.inTransition = true;
                edata.lastState = obj.currentState;
                
                signalFound = false;
                for k=1:length(obj.transitions)
                    transitionRule = FSM.Transition(obj.currentState,input);
                    if ...
                            MatchesAbs(transitionRule, obj.transitions(k))...
                            ||...
                            Matches(transitionRule, obj.transitions(k));
                        if ~isempty(obj.transitions(k).output)
                            obj.transitions(k).output();
                        end
                        obj.currentState = obj.transitions(k).nextState;
                        signalFound = true;
                        break;
                    end
                end
                if ~signalFound
                    warning('Transition undefined. State not changing.');
                end
                obj.lastInput = input;
                obj.inTransition = false;
                notify(obj,'StateChange',...
                    FSM.StateChangeEventData(...
                    obj,...
                    obj.currentState,...
                    input,...
                    edata.lastState));
            end
            
        end
        
    end
    
    events
        StateChange
    end
    
    
end

