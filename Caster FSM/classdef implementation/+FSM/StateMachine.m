classdef StateMachine < hgsetget
    % FSM.StateMachine
    % Class that models an arbitrary state machine.
    
    properties
        name
        % Name of the state machine. (char)
        
        currentState
        % Current State of the state machine. (FSM.State)
        
        transitions = [];
        % Set of defined transitions (FSM.Transition)
        
        inTransition = false;
        % Determines whether a variable is changing states. (logical)
        
        ignoreDuplicateInput = false;
        % Prevents duplicate input from changing the state of the machine.
        % (logical)
        %
        % When running simulations in Simulink, it can be helpful to tell
        % the state machine to ignore duplicate input signals, as some
        % object may send a continuous signal to a state machine. If this
        % is detected and ignoreDuplicateInfo is set to true, it will
        % ignore a signal sent multiple times.
        
        lastInput = [];
        % used along with ignoreDuplicateInput. (FSM.Input);
        
        inputMap = containers.Map('KeyType','Double','ValueType','any');
        % Maps a given numerical value to one of the defined commands.
        
    end
    
    methods
        
        function obj = StateMachine(name, currentState)
            % Creates a state machine with the name (char) and the current
            % state (FSM.State).
            obj.inputMap.remove(obj.inputMap.keys);
            % Apparently, when re-instantiating an object with the same
            % name or clearing, containers.Map retains the key-value pairs
            % it was assigned in the first place.
            % Purging this from the start removes that issue.
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
            % Adds an absolute transition if appropriate.
            % Absolute Transitions work as follows: no matter what state
            % the state machine is currently in, an absolute transition
            % will send the signal to the front.
            % In future releases, it might be helpful to sort the
            % transitions such that the absolute transitions are last,
            % allowing for custom-defined transitions to override the
            % absolute commands.
            % Abs. Transitions are marked by convention with a '*' for the
            % state. Note that you can define a state marked '*' and there
            % will be no conflict because absolute transitions ignore the
            % defined state entirely.
            %
            if nargin > 3
                % Determines if an output function is defined.
                newTransition = FSM.Transition('*',input,nextState,output);
            else
                % If not, do not assign one to the new transition.
                newTransition = FSM.Transition('*',input,nextState);
            end
            
            newTransition.isAbsolute = true;
            % Makes the transition absolute.
            
            obj.AddTransition(newTransition);
            % Adds the transition.
            
        end
        
        function disp(obj)
            % Custom display function for the state machine.
            fprintf('<strong>Name:</strong> %s\n',obj.name);
            fprintf('<strong>Current State:</strong> ');
            disp(obj.currentState);
            fprintf('<strong>Transitions:</strong> \n');
            disp(obj.transitions);
        end
        
        function SendSignalEnum(obj, enum)
            % Uses a numerical value to determine the appropriate signal to
            % send.
            if obj.inputMap.isKey(enum)
                obj.SendSignal(obj.inputMap(enum));
            else
                warning('Signal Enum %d not recognized.',enum);
            end
        end
        
        function SendSignal(obj,input)
            % Sends an appropriate signal.
            if ~obj.inTransition
                % Checks to see if the object is transitioning. This isn't
                % an issue for the most part in single-threaded MATLAB
                % programs, but SIMULINK supports concurrency and thus
                % possibly runs into the issue of calling a method multiple
                % times from an updating system.
                
                if ~isequal(obj.lastInput,input) || ~(obj.ignoreDuplicateInput)
                    % If the last input and the first input aren't the same, or
                    % the state machine is not ignoring duplicate input.
                    
                    obj.inTransition = true;
                    % Mark class as 'in transition'. This can prevent
                    
                    edata.lastState = obj.currentState;
                    % Captures the last state for record purposes.
                    
                    signalFound = false;
                    
                    transitionRule = FSM.Transition(obj.currentState,input);
                    % Generates a possible rule to compare to current
                    % rules.
                    
                    for k=1:length(obj.transitions)
                        % Runs through the list of transitions.
                        
                        if ...
                                MatchesAbs(...
                                transitionRule, obj.transitions(k)...
                                )...
                                ||...
                                Matches(transitionRule, obj.transitions(k));
                            %
                            % Checks to see if there is an absolute
                            % transition rule that applies.
                            
                            if ~isempty(obj.transitions(k).output)
                                % Executes an output function just before
                                % changing state.
                                obj.transitions(k).output();
                            end
                            
                            obj.currentState = obj.transitions(k).nextState;
                            % Changes state.
                            
                            signalFound = true;
                            % Tells program that an appropriate transition
                            % was found.
                            break;
                            % Note that this terminates after the first
                            % rule found.
                        end
                    end
                    if ~signalFound
                        % If the rule was not found, warn the user but do
                        % not hald execution.
                        warning('Transition undefined. State not changing.');
                    end
                    
                    obj.lastInput = input;
                    % Records last input.
                    obj.inTransition = false;
                    % Marks as no longer in transition.
                    notify(obj,'StateChange',...
                        FSM.StateChangeEventData(...
                        obj,...
                        obj.currentState,...
                        input,...
                        edata.lastState));
                    % Sends an event with pertinent data to be used by an
                    % event listener.
                end
            end
        end
        
        function EnumInput(obj, input,num)
            % Establishes a numerical value to determine the appropriate
            % signal to send. Note that there can be many enums for a
            % single input, or no enums for certain inputs.
            if ~obj.inputMap.isKey(num)
                obj.inputMap(num) = input;
            else
                error('Key "%d" already exists.',num);
            end
        end       
                
    end
    events
        StateChange
        % Broadcasts a change in state to whatever is listening.
    end
    
    
end

