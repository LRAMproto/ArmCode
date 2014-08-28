classdef StateMachine < hgsetget
    %%% FSM2.StateMachine
    % Written by David Rebhuhn, 2014
    %
    % A MATLAB classdef approach to a state machine data structure.
    %
    % This approach follows a mathematical structuring of a finite state
    % machine as modelled in
    %
    % |MATHEMATICAL STRUCTURES IN COMPUTER SCIENCE| (c) JUDITH L. GERSTING,
    % 2006
    %
    % Section 8.2 (Finite-State Machines)
    %
    % Certain steps are taken to ensure its usefulness in SIMULINK code
    % generation.
    %
    
    %% *Introduction: Mathematical Model of a StateMachine*
    % Mathematically, state machines can be modelled as follows:
    %
    % $M = [S,I,O,f_s, f_o]$
    %
    % Where $S$ is the set of states, $I$ is the set of inputs, $O$ is the
    % set of outputs, $f_s$ is the set of next-state transitions, and $f_o$
    % is the set of outputs.
    %
    % This state machine implementation is structured more closely to the
    % following model:
    %
    % $M = [S,s_i,s_0,I,O,f_s, f_{err}, f_{abs},f_o]$
    %
    % Where $s_i$ is the current state, $s_o$ is the initial state,
    % $f_{err}$ and $f_{abs}$ are of a form that can be called  _absolute
    % next-state transitions_.
    %
    % For the purpose of this state machine, numerical values are
    % preferred; however, this state machine could use any class that can
    % be modified to be used in the matlab language's union/unique/setdiff
    % operations. This design choice reflects its intended implementation
    % as a compileable data structure with MATLAB's SIMULINK code
    % generation tool.
    
    %% *Defined Properties of FSM2.StateMachine*
    % The following are the properties of the state machine as defined in
    % this implementation.
    
    properties
        %% si : Current State
        % Current State of the machine.
        
        si = -1111;
        
        %% isInitialized
        % Determines whether machine is initialized or not. No actions can
        % be performed in an uninitialized state machine other than adding
        % state function definitions.
        
        isInitialized = false
        
        %% s0 : Initial State
        % Initial state of the state machine. Set in call to the method
        % 'Initialize'.
        
        s0 = -1111;
        
        %% output : Current Output
        % Output of current simulation.
        
        output = -1111;
        
        %% s_defined : Defined States
        % The set $S$ of explicitly-defined states. You don't need to
        % declare any states. but if you do, this structure can be used to
        % determine if they are reachable. The values present are
        % placeholders for code generation.
        
        s_defined = [-1111,-2222,-3333];
        
        %% hasDefinedStates
        % Boolean variable which tells us whether a state machine has
        % defined states. This allows us to add placeholders for variables
        % for MATLAB code generation.
        
        hasDefinedStates = false;
        
        %% i_defined : Defined Inputs
        % The set $I$ of explicitly defined inputs. You don't need to
        % declare any inputs, but if you do, this structure can be used to
        % determine if they are being used. The default values are
        % placeholders used for code generation.
        
        I_defined = [-1111,-2222,-3333];
        
        %% hasDefinedInputs
        % Boolean variable which tells us whether a state machine has
        % defined inputs. This allows us to add placeholders for variables
        % for MATLAB code generation.
        
        hasDefinedInputs = false;
        
        %% O_defined : Defined Outputs
        % Defined outputs. You don't need to declare any output symbols,
        % but if you do, this can help you determine if any are being used.
        % The current placeholder values are there for code generation
        % purposes.
        
        O_defined = [-1111, -2222, -3333];
        
        %% hasDefinedOutputs
        % Boolean variable which tells us whether a state machine has
        % defined outputs. This allows us to add placeholders for variables
        % for MATLAB code generation.
        
        hasDefinedOutputs = false;
        
        %% fs : Next-State Functions
        % The set $f_s$ of Next-State Functions. Default values present for
        % code generation purposes.
        
        fs = [[-1111,-1111,2222];[-1111,2222,-3333]];
        
        %% hasNextStateFcns
        % Boolean variable which tells us whether a state machine has
        % next-state functions. This allows us to add placeholders for
        % variables for MATLAB code generation.
        
        hasNextStateFcns = false;
        
        %% f_error : Error Functions
        % The state of error next-state functions $f_{err}$ It is necessary
        % at times to bring a program to a halted state as soon as
        % possible. Hence, $f_{err}$ defines functions which will be
        % checked first to determine if a state change is necessary.
        
        f_error = [[-1111,-2222],[-2222,3333]];
        
        %% hasErrorFcns
        % Boolean variable which tells us whether a state machine has error
        % functions. This allows us to add placeholders for variables for
        % MATLAB code generation.
        hasErrorFcns = false;
        
        %% afs : Absolute Next-State Functions
        % List of Next-State Functions. Placeholder values are for code
        % generation.
        afs = [[8888,-8888];[9999,-9999]];
        
        %% hasAbsNextStateFcns
        % Boolean variable which tells us whether a state machine has
        % absolute next-state functions. This allows us to add placeholders
        % for variables for MATLAB code generation.
        
        hasAbsNextStateFcns = false;
        
        %% fo : Output Functions
        % The set $f_o$ of output functions.
        fo = [[-1111,-1111];[-1111,2222]];
        
        %% hasOutputFcns
        % Boolean variable which tells us whether a state machine has
        % output functions. This allows us to add placeholders for
        % variables for MATLAB code generation.
        
        hasOutputFcns = false;
        
        %% last_input : Last Input
        % The last sent input. If ignoreRepeatedInputs is set to true, then
        % this is checked to determine whether the state transition should
        % occur.
        last_input = -1111;
        
        %% ignoreRepeatedInputs
        % Set ignoreRepeatedInputs to true if running a program which
        % continuously sends an input command.
        
        ignoreRepeatedInputs = false;
        
        %% inTransition
        % Determines of the state machine is transitioning from one state
        % to another.
        
        inTransition = false
        
        
    end
    %% *Defined methods of FSM2.StateMachine:*
    
    %TODO: Add plural wrapper methods for bulk addition functions.
    
    methods
        %% *Constructor*
        % Method which is used to initialize the state machine.
        
        %% self = StateMachine()
        % Constructor for StateMachine.
        
        function self = StateMachine()
            % Does nothing currently, but may be redefined to include
            % additional capabilities.
        end
        
        %% *Adding Information*
        % The following methods allow for adding information on-the-fly to
        % the state machine.
        
        
        %% AddErrorNST(self, transitions) : Add Error Transitions
        % Adds an error transition or transition(s) to the set $f_err$
        % (self.f_error).
        
        function AddErrorNST(self,transitions)
            
            sz = size(transitions);
            
            if (sz(2) == 2)
                for k = 1:sz(1)
                    if ~self.HasDefinedErrorFcns()
                        self.f_error = transitions(k,:);
                        self.hasErrorFcns = true;
                    else
                        self.f_error = union(...
                            self.f_error,transitions(k,:),'rows');
                    end
                end
            end
        end
        
        %% AddInput(self, inpts) : Add Input Symbol
        % Adds an input symbol to the set $I$ of input symbols
        % (StateMachine.i_defined);
        function AddInput(self, inpts)
            
            if self.HasDefinedInputs() == false
                self.I_defined = unique(inpts);
                self.hasDefinedInputs = true;
            else
                self.I_defined = union(self.I_defined, inpts);
            end
        end
        %% AddNST : Add a Next-State Transition
        % Adds a next-state transition or set of next-state transitions to
        % the state machine.
        %  The function $f(s_i, i) = s_{i+1}$ is
        % represented as the matrix $[s_i, i, s_{i+1}]$
        
        function AddNST(self, transitions)
            sz = size(transitions);
            if (sz(2) == 3)
                for k = 1:sz(1)
                    if ~self.HasDefinedNSTs()
                        self.fs = transitions(k,:);
                        self.hasNextStateFcns = true;
                    else
                        self.fs = union(...
                            self.fs,transitions(k,:),'rows');
                    end
                end
                
            elseif (sz(2) == 2)
                for k = 1:sz(1)
                    if isempty(self.afs)
                        self.afs = transitions(k,:);
                    else
                        self.afs = union(self.afs,transitions(k,:),'rows');
                    end
                end
                
            elseif ~isempty(transitions)
                entrystr = sprintf('%d ',transitions');
                warning(['The entry [',entrystr,'is not recognized, ', ...
                    'and will thus not be added. Please check that all',...
                    'entries are n-by-2 or n-by-3 arrays.']);
            end
            
        end
        
        %% AddOutput(self, outpts) : Add Output Symbol
        % Adds an output symbol to the set $O$ of output symbols
        % (StateMachine.O_defined);
        function AddOutput(self, outpts)
            
            if (self.hasDefinedOutputs == false)
                self.O_defined = unique(outpts);
                self.hasDefinedOutputs = true;
            else
                self.O_defined = union(self.O_defined, outpts);
            end
        end
        
        %% AddOutputFcn(self,outputfcns) : Add an Output Function
        % Adds an output function to the set $fs$ of output functions
        % (StateMachine.fs).
        function AddOutputFcn(self,outputfcns)
            sz = size(outputfcns);
            if sz(2) ~= 2
                error(...
                    ['Output functions must be row(s) of 1-by-2',...
                    ' numerical matrices within an ',...
                    'N-by-2 numerical matrix.']);
            end
            for k = 1:sz(1)
                if ~self.HasDefinedOutputFcns()
                    self.fo = outputfcns(k,:);
                    self.hasOutputFcns = true;
                else
                    self.fo = union(self.fo,outputfcns(k,:),'rows');
                end
                self.AddOutput(outputfcns(2)');
                self.AddState(outputfcns(1)');
            end
        end
        
        %% AddState(self,states) : Add a defined state.
        % Adds a state to the set $S$ of states (StateMachine.s_defined).
        % Can add a single state or a matrix of defined states in the form:
        %
        % $[s_1,s_2,s_3,...,s_{n-2},s_{n-1},s_n]$;
        function AddState(self,states)
            
            if self.hasDefinedStates == false;
                self.s_defined = unique(states);
                self.hasDefinedStates = true;
            else
                self.s_defined = union(self.s_defined, states);
            end
        end
        
        %% AddStateTable(self, presentInput, stateTable)
        %
        % This method allows the state machine to interpret a state table,
        % a defined format for finite state machines.
        %
        % |presentInput| is a 1-by-N vector of input symbols. |stateTable|
        % is a M-by-(N+2) array which consists of M rows, which specify the
        % following:
        %
        %  Initial state. Next states, a 1-by-N vector vector which
        %  determines the next
        %   state for every input in presentInput
        %  output, which has a 1-1 corruspondance to the current
        %   state. Note that multiple states can share an output.
        %
        % Example:
        %
        % fsm = FSM2.StateMachine();
        %
        % presentInput =     [i1, i2]; stateTable = [ [s1, s1, s4, o1];...
        %                [s2, s3, s4, o2];... [s3, s4, s1, o1];... [s4, s1,
        %                s2, o3];...
        %              ];
        function AddStateTable(self, presentInput, stateTable)
            outs = [stateTable(:,1),stateTable(:,end)];
            self.AddOutputFcn(outs);
            % Adds input functions based on state table.
            sz = size(stateTable);
            for j = 1:sz(1)
                for k = 1:length(presentInput)
                    nst = [...
                        stateTable(j,1),...
                        presentInput(k),...
                        stateTable(j,k+1)];
                    
                    self.AddNST(nst);
                end
            end
        end
        
        %% *Value-Checking Functions*
        % The following determine whether certain conditions are met.
        
        %% HasDefinedANSTs(self)
        % Returns true if the state machine has any defined NSTs, false if
        % not.
        
        function result = HasDefinedANSTs(self)
            result = self.hasAbsNextStateFcns;
        end
        
        %% HasDefinedErrorFcns(self)
        % Returns true if the state machine has any defined error
        % functions, false if not.
        
        function result = HasDefinedErrorFcns(self)
            result = self.hasErrorFcns;
        end
        
        %% HasDefinedInputs(self)
        % Returns true if the state machine has any defined inputs, false
        % if not.
        
        function result = HasDefinedInputs(self)
            result = self.hasDefinedInputs;
        end
        
        
        %% HasDefinedNSTs(self)
        % Returns true if the state machine has any defined NSTs, false if
        % not.
        
        function result = HasDefinedNSTs(self)
            result = self.hasNextStateFcns;
        end
        
        %% HasDefinedOutputs(self)
        % Returns true if the state machine has any defined outputs, false
        % if not.
        
        function result = HasDefinedOutputs(self)
            result = self.hasDefinedOutputs;
        end
        
        %% HasDefinedOutputFcns(self)
        % Returns true if the state machine has any defined outputs, false
        % if not.
        
        function result = HasDefinedOutputFcns(self)
            result = self.hasOutputFcns;
        end
        
        %% HasDefinedOutputFor(self,val)
        % Checks to see whether an input has an output value defined.
        % Returns true if it does and false if the appropriate output
        % cannot be located.
        
        function result = HasDefinedOutputFor(self,val)
            if ~self.HasDefinedOutputs()
                result = false;
            elseif ~isempty(ismember(val,self.fo(1)))
                result = true;
            else
                result = false;
            end
        end
        
        %% HasDefinedStates(self)
        % Checks whether the state machine has defined states.
        
        function result = HasDefinedStates(self)
            result = self.hasDefinedStates;
        end
        
        
        
        %% IgnoresRepeatedInputs(self)
        % Checks to see if the state machine ignores repeated inputs.
        
        function result = IgnoresRepeatedInputs(self)
            result = self.ignoreRepeatedInputs;
        end
        
        %% IsInitialized(self)
        % Checks to see if the state machine is initialized. Returns true
        % if it is, and false if it isn't.
        
        function result = IsInitialized(self)
            result = self.isInitialized;
        end
        
        %% IsInTransition(self)
        % Checks to see if the machine is in transition.
        
        function result = IsInTransition(self)
            result = self.inTransition;
        end
        
        %% WasLastInput(self,inpt):
        % Checks to see if the last input was defined.
        function result = WasLastInput(self,inpt)
            result = inpt ~= self.last_input;
        end
        
        %% *Runtime Methods:*
        % These methods occur during and after the initialization of the
        % state machine.
        
        %% BeginTransition(self)
        % Changes the transition state of the machine to affirmative.
        % Remember to call 'endtransition' before throwing an error.
        
        function BeginTransition(self)
            self.inTransition = true;
        end
        
        %% EndTransition(self)
        % Changes the transition state of the machine to negative
        
        function EndTransition(self)
            self.inTransition = false;
        end
        %% GenOutput(self)
        % Generates an appropriate output for the state machine based on
        % the current input state. Does nothing if the appropriate output
        % is not found.
        
        
        function GenOutput(self)
            self.BeginTransition();
            idx = find(ismember(self.fo(:,1), self.si,'rows'),1);
            if ~isempty(idx)
                self.output = self.fo(idx,2);
            end
            self.EndTransition();
            
        end
        
        %% Initialize(self,val)
        % Sets the current state of the machine, s_i (StateMachine.si) to
        % val and generates the appropriate output symbol.
        
        % output.
        
        function Initialize(self,val)
            self.BeginTransition();
            if ~self.HasDefinedOutputFor(val)
                self.EndTransition();
                error('Output for %d not defined.',val);
            end
            
            self.SetCurrentState(val);
            self.SetInitialState(val);
            self.isInitialized = true;
            
            self.EndTransition();
        end
        
        %% Reset(self)
        % Re-initializes the state machine to its default initial state.
        
        function Reset(self)
            self.Initialize(self.GetInitialState());
        end
        
        %% SendInput(self)
        function SendInput(self,inpt)
            if (~self.IsInTransition())
                % Checks to see if the state machine is in transition. If
                % not, nothing is done.
                if (...
                        (~self.IgnoresRepeatedInputs) ...
                        || (~self.WasLastInput(inpt)))
                    % Pays attention to the value of the signal if the
                    % signal is different than the last signal, or if the
                    % state machine is not ignoring repeated inputs.
                    self.BeginTransition();
                    % Sets self into transition mode.
                    
                    idx_nst = self.FindIdxOfNSTFor(...
                        self.GetCurrentState(), inpt);
                    idx_anst = self.FindIdxOfANSTFor(inpt);
                    idx_e = self.FindIdxOfErrorFcnFor(inpt);
                    
                    % Error transitions are checked first to ensure quick
                    % stops.
                    
                    if idx_e ~= -1
                        self.SetCurrentState(self.f_error(idx_e,2));
                        
                    elseif idx_nst ~= -1
                        self.SetCurrentState(self.fs(idx_nst,3));
                        
                    elseif idx_anst ~= -1
                        self.SetCurrentState(self.afs(idx_anst,2));
                    else
                        % Do nothing here because no input is not
                        % recognized.
                    end
                    
                    self.EndTransition();
                end
            end
            self.SetLastInput(inpt);
        end
        
        %% SendInputSequence(self, inputSequence)
        % Function allows you to see the output of a state machine starting
        % from the current state.
        %
        % NOTE: This function DOES alter the state of the machine. It may
        % be beneficial in the future to define a method which duplicates
        % the configuration of the state machine the state machine and run
        % the output sequence on that.
        function a = SendInputSequence(self, inputSequence)
            
            if isempty(self.si)
                error('Initial State is unset.');
            end
            a = -1*(ones(1,length(inputSequence)+1));
            a(1) = self.output;
            for k=1:length(inputSequence)
                self.SendInput(inputSequence(k));
                out = self.output;
                a(k+1) = out;
            end
        end
        
        %% *Setting Property Values*
        % The following values set property values to appropriate values.
        
        %%  SetCurrentState(self,val)
        % Sets the current state of the state machine to val.
        
        %TODO: Should currentState be checked against defined states?
        
        function SetCurrentState(self,val)
            self.si = val;
            self.GenOutput();
        end
        
        %% SetInitialState(self,val)
        % Sets the initial state to val
        
        %TODO: Add value check to determine whether initial state has a
        % defined output.
        
        function SetInitialState(self,val)
            
            self.s0 = val;
        end
        
        %% SetLastInput(self, inpt)
        % Sets the last input recieved.
        
        function SetLastInput(self, inpt)
            self.last_input = inpt;
        end
        
        %% *Information Display Methods:*
        % The following displays statistics on the state machine.
        
        %% disp(self) : Customized Display Function
        % This function outputs a readable representation of the contents
        % of the state machine.
        %
        
        %FIXME: Finish the customized display function to display relevant
        %data.
        function disp(self)
            fprintf('State Machine:\n');
            self.DispCurrentState();
            self.DispInitState();
            self.DispReachableStates();
            self.DispInputSymbols();
            self.DispOutputSymbols();
            self.DispUnreachableStates();
            self.DispUnusedInputs();
            self.DispUnusedOutputs();
            self.DispNSTs();
            self.DispANSTs();
            self.DispErrFcns();
        end
        
        function DispANSTs(self)
            if self.HasDefinedANSTs()
                fprintf('\tANSTs (%d): \n',length(self.afs));
                sz = size(self.afs);
                for k = 1:sz(1);
                    fprintf('\t\t(%d) = %d\n',...
                        self.afs(k,1),self.afs(k,2));
                end
            end
        end
        
        function DispNSTs(self)
            if self.HasDefinedNSTs()
                fprintf('\tNSTs (%d): \n',length(self.fs));
                sz = size(self.fs);
                for k = 1:sz(1);
                    fprintf('\t\t%dX(%d) = %d\n',...
                        self.fs(k,1),self.fs(k,2),self.fs(k,3));
                end
            end
        end
        
        function DispErrFcns(self)
            if self.HasDefinedErrorFcns()
                fprintf('\tError Fcns (%d): \n',length(self.f_error));
                sz = size(self.f_error);
                for k = 1:sz(1);
                    fprintf('\t\t(%d) = %d\n',...
                        self.f_error(k,1),self.f_error(k,2));
                end
            end
        end
        
        function DispCurrentState(self)
            fprintf('\tCurrent State (si):\t');
            if (~self.IsInitialized())
                fprintf('Uninitialized\n');
            else
                fprintf('%d\n',self.GetCurrentState());
            end
        end
        
        function DispInitState(self)
            fprintf('\tInit State (s0):\t');
            if (~self.IsInitialized)
                fprintf('None\n');
            else
                fprintf('%d\n',self.GetInitialState());
            end
        end
        
        function DispReachableStates(self)
            fprintf('\tReachable States (S):\t');
            if ~self.HasDefinedStates()
                fprintf('None');
            else
                states = self.GetReachableStates();
                for k=1:length(states')
                    fprintf('%d, ',states(k));
                end
            end
            fprintf('\n');
        end
        function DispInputSymbols(self)
            fprintf('\tInput Symbols (I):\t');
            if ~self.HasDefinedInputs()
                fprintf('None');
            else
                inpts = self.GetAllInputs();
                for k=1:length(inpts')
                    fprintf('%d, ',inpts(k));
                end
                
            end
            fprintf('\n');
        end
        
        function DispOutputSymbols(self)
            fprintf('\tOutput Symbols (O):\t');
            if ~self.HasDefinedOutputs()
                fprintf('None');
            else
                outpts = self.GetAllOutputs();
                for k=1:length(outpts')
                    fprintf('%d, ',outpts(k));
                end
            end
            fprintf('\n');
        end
        
        function DispUnreachableStates(self)
            fprintf('\tUnreachable States:\t');
            if ~self.HasDefinedStates()
                fprintf('None');
            else
                un_states = self.GetUnreachableStates();
                if ~isempty(un_states)
                    
                    for k = 1:length(un_states')
                        fprintf('%d, ',un_states(k));
                    end
                end
                
            end
            fprintf('\n');
        end
        
        function DispUnusedInputs(self)
            fprintf('\tUnused Inputs:\t');
            if ~self.HasDefinedInputs()
                fprintf('None');
            else
                un_inpts = self.GetUnusedInputs();
                if ~isempty(un_inpts)
                    for k = 1:length(un_inpts')
                        fprintf('%d, ',un_inpts(k));
                    end
                    
                end
            end
            fprintf('\n');
        end
        
        function DispUnusedOutputs(self)
            fprintf('\tUnused Outputs:\t');
            if (~self.HasDefinedOutputs())
                fprintf('None');
            else
                un_outpts = self.GetUnusedOutputs();
                if ~isempty(un_outpts)
                    for k = 1:length(un_outpts')
                        fprintf('%d, ',un_outpts(k));
                    end
                end
                
            end
            fprintf('\n');
            
        end
        
        %% *Information Retrieval Methods:*
        % The following methods retrieve useful information about the state
        % machine for internal and external use.
        
        %% FindIdxOfNSTFor(self, state, inpt)
        % Finds the index of an appropriate next-state transition. Returns
        % -1 if one is not present.
        
        function idx = FindIdxOfNSTFor(self, state, inpt)
            if self.HasDefinedNSTs()
                idx = find(ismember(...
                    self.fs(:,1:2), ...
                    [state, inpt],...
                    'rows'),...
                    1);
                if isempty(idx)
                    idx = -1;
                end
            else
                idx = -1;
            end
        end
        
        %% FindIdxOfANSTFor(self,inpt)
        % Finds the index of an appropriate next-state transition. Returns
        % -1 if one is not present.
        
        function idx = FindIdxOfANSTFor(self,inpt)
            if self.HasDefinedANSTs()
                idx = find(ismember(self.afs(:,1), inpt,'rows'),1);
                if isempty(idx)
                    idx = -1;
                end
            else
                idx = -1;
            end
        end
        
        %% FindIdxOfErrorFcnFor(self,inpt)
        % Finds the index of an appropriate next-state transition. Returns
        % -1 if one is not present.
        
        function idx = FindIdxOfErrorFcnFor(self,inpt)
            if self.HasDefinedErrorFcns()
                idx = find(ismember(self.f_error(:,1), inpt,'rows'),1);
                if isempty(idx)
                    idx = -1;
                end
            else
                idx = -1;
            end
        end
        
        %% GetCurrentState(self)
        % Get the current state of the state machine.
        function currentState = GetCurrentState(self)
            currentState = self.si;
        end
        
        %% GetInitialState(self)
        % Retrieves the initial state of the state machine.
        
        function initState = GetInitialState(self)
            initState = self.s0;
        end
        
        %% GetInitialStates(self)
        % Retrieves a list of initial states that have been defined for a
        % given state machine.
        
        function init_states = GetInitialStates(self)
            % Note: Only NSTs have initial states.
            if ~self.HasDefinedNSTs()
                init_states = [];
            else
                init_states = self.GetInitialNSTStates();
            end
            
        end
        
        
        function init_states = GetInitialNSTStates(self)
            if ~self.HasDefinedNSTs()
                init_states = [];
            else
                init_states = (unique(self.fs(:,1)))';
            end
        end
        
        %% GetAllInputs(self)
        % Gets a set of inputs defined for the state machine. This accounts
        % for both explicitly-defined and implicitly-defined inputs.
        
        function inpts = GetAllInputs(self)
            inpts = unique([...
                self.GetUsedInputs(), self.I_defined]);
        end
        %% GetUsedInputs(self)
        % This function retrieves a list of inputs that are not necessarily
        % explicitly defined, but are used within functions.
        
        function inpts = GetUsedInputs(self)
            if ~self.HasDefinedInputs()
                inpts = [];
            else
                inpts = unique([...
                    self.GetNSTInputs(),...
                    self.GetANSTInputs(),...
                    self.GetErrorInputs()]);
            end
        end
        
        %% GetNSTInputs(self)
        % This function retrieves a list of inputs from all NSTs.
        
        function inpts = GetNSTInputs(self)
            if ~self.HasDefinedNSTs()
                inpts = [];
            else
                inpts = self.fs(:,2)';
            end
        end
        
        %% GetANSTInputs(self)
        % This function retrieves a list of inputs from all ANSTs.
        
        function inpts = GetANSTInputs(self)
            if ~self.HasDefinedANSTs()
                inpts = [];
            else
                inpts = self.afs(:,1)';
            end
        end
        
        %% GetErrorInputs(self)
        % This function retrieves a list of inputs from all error
        % functions.
        
        function inpts = GetErrorInputs(self)
            if ~self.HasDefinedErrorFcns()
                inpts = [];
            else
                inpts = self.f_error(:,1)';
            end
        end
        
        %% GetNextStates(self)
        % Gets all next states defined for the state machine. Used to
        % determine states that cannot be reached.
        
        function next_states = GetNextStates(self)
            next_states = unique(...
                [self.GetNextNSTStates(),...
                self.GetNextANSTStates(),...
                self.GetNextErrorStates()]);
        end
        
        %% GetNextNSTStates(self)
        % Retrieves the next states deefined for regular NSTs.
        function next_states = GetNextNSTStates(self)
            if ~self.HasDefinedNSTs()
                next_states = [];
            else
                next_states = (unique(self.fs(:,3)))';
            end
        end
        %% GetNextANSTStates(self)
        % Retrieves the next states deefined for ANSTs.
        function next_states = GetNextANSTStates(self)
            if ~self.HasDefinedANSTs()
                next_states = [];
            else
                next_states = (unique(self.afs(:,2)))';
            end
        end
        
        %% GetNextErrorStates(self)
        % Retrieves the next states deefined for error transitions.
        function next_states = GetNextErrorStates(self)
            if ~self.HasDefinedErrorFcns()
                next_states = [];
            else
                next_states = (unique(self.f_error(:,2)))';
            end
        end
        
        %% GetAllOutputs(self)
        % Gets all outputs that have been defined
        
        function outputs = GetAllOutputs(self)
            if ~self.HasDefinedOutputFcns()
                outputs = [];
            else
                outputs = unique(...
                    [self.GetUsedOutputs(),...
                    self.O_defined]);
            end
        end
        
        %% GetUsedOutputs(self)
        %Gets a list of outputs that are being used.
        
        function outputs = GetUsedOutputs(self)
            if ~self.HasDefinedOutputFcns()
                outputs = [];
            else
                outputs = (unique(self.fo(:,2)))';
            end
        end
        
        %% GetReachableStates(self)
        % Returns a list of states that are either initial states or next
        % states.
        
        function states = GetReachableStates(self)
            init_states = self.GetInitialStates();
            next_states = self.GetNextStates();
            states = union(init_states, next_states);
        end
        
        %% GetUnreachableStates(self)
        % Returns a list of explicitly defined states that are not initial
        % states or next states.
        function states = GetUnreachableStates(self)
            if ~self.HasDefinedStates
                states = [];
            else
                states = setdiff(self.s_defined, self.GetReachableStates);
            end
        end
        
        
        %% GetUnusedInputs(self)
        % Returns a list of unused inputs.
        function states = GetUnusedInputs(self)
            if self.hasDefinedStates()
                states = setdiff(self.I_defined, self.GetUsedInputs());
            end
        end
        
        %% GetUnusedOutputs(self)
        % Returns a list of unused outputs.
        function outputs = GetUnusedOutputs(self)
            if ~self.HasDefinedOutputs()
                outputs = [];
            else
                outputs = setdiff(self.O_defined, self.GetUsedOutputs());
            end
        end
        
        %%
    end
    
end

