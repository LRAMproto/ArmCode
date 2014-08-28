function testsuite()
% Persistant States
shared.states.stop = 0;
shared.states.go = 1;
shared.states.slow = 2;

shared.outputs.stop = 7;
shared.outputs.go = 8;
shared.outputs.slow = 9;

% Persistant inpts;
shared.inputs.change = 1234;
shared.inputs.err = 5678;
% Persistent Outputs
%shared.outputs.change = 0;
%shared.outputs.err = 0;

test1(shared);
test2(shared);
test3(shared);
test4(shared);

end
%% Test 1: Stoplight
% The following test is a simple implementation of a stoplight. 
function test1(shared)
disp('TEST 1: A STOPLIGHT');

stoplight = FSM2.StateMachine();
disp('Initial value of stoplight: an uninitialized State machine.');
disp(stoplight);
stoplight.AddState(...
    [shared.states.stop,...
    shared.states.go,...
    shared.states.go,...
    999]... % this state is unreachable on purpose.
    );

assert(stoplight.HasDefinedStates());

stoplight.AddInput([shared.inputs.change, shared.inputs.err]);
assert(stoplight.HasDefinedInputs());

stoplight.AddOutput([shared.outputs.stop, shared.outputs.go, shared.outputs.slow]);
assert(stoplight.HasDefinedOutputs());

stoplight.AddOutputFcn([shared.states.stop, shared.outputs.stop]);
assert(stoplight.HasDefinedOutputFcns());

stoplight.AddOutputFcn([shared.states.go, shared.outputs.go]);
stoplight.AddOutputFcn([shared.states.slow, shared.outputs.slow]);

stoplight.AddNST(...
    [shared.states.stop,...
    shared.inputs.change,...
    shared.states.go...
    ]...
    );
stoplight.AddNST(...
    [shared.states.go,...
    shared.inputs.change,...
    shared.states.slow...
    ]...
    );
stoplight.AddNST(...
    [shared.states.slow,...
    shared.inputs.change,...
    shared.states.stop...
    ]...
    );
assert(stoplight.HasDefinedNSTs());

% Initializes the stoplight at the stopped state.
stoplight.Initialize(shared.states.stop);

disp(stoplight);

stoplight.SendInput(shared.inputs.change);
assert(stoplight.GetCurrentState == shared.states.go)

disp(stoplight);
stoplight.SendInput(shared.inputs.change);
assert(stoplight.GetCurrentState == shared.states.slow)

disp(stoplight);
stoplight.SendInput(shared.inputs.err);
assert(stoplight.GetCurrentState == shared.states.slow)

stoplight.AddErrorNST([shared.inputs.err,shared.states.stop]);
assert(stoplight.HasDefinedErrorFcns());

stoplight.SendInput(shared.inputs.err);
assert(stoplight.GetCurrentState == shared.states.stop)


disp(stoplight);

disp('*****');
end

function test2(shared)
    disp('TEST 2: EXAMPLE 16');
    S = [0,1,2];
    I = [0,1];
    O = [0,1];
    
    M = FSM2.StateMachine();
    disp(M);
    
    M.AddState(S);
    assert(M.HasDefinedStates);
    disp(M);

    M.AddInput(I);
    assert(M.HasDefinedInputs);
    disp(M);
    
    M.AddOutput(O);
    assert(M.HasDefinedOutputs);
    disp(M);
    
    stPresentInpt = [0 1];
    stateTable = [...
        [0 1 0 0];...
        [1 2 1 1];...
        [2 2 0 1];...        
        ];
    M.AddStateTable(stPresentInpt, stateTable);
    assert(M.HasDefinedOutputFcns());
    assert(M.HasDefinedNSTs());
    
    disp(M);
    
    disp(M);
    
    disp('** PART 1');
    M.Initialize(0);
    outputSequence = M.SendInputSequence([0 1 1 0 1]);    
    disp(outputSequence);
    disp(M);
    disp('** PART 2');    
    M.Reset();
    assert(M.GetInitialState == 0);
    assert(M.GetInitialState == M.GetInitialState);
    
    outputSequence = M.SendInputSequence([1 0 1 0]);    
    disp(outputSequence);
    disp(M);
    
%     M.Initialize(0);
%     outputSequence = M.SendInputSequence([1 1 0 0 1]);    
%     disp(outputSequence);
%     disp(M);
disp('*****');    
end

function test3(shared)
    disp('TEST 3:');
    M = FSM2.StateMachine();    
    stPresentInpt = [0 1 2];
    stateTable = [...
        [0 0 1 1 0];...
        [1 1 0 0 1];...
        ];
    M.AddStateTable(stPresentInpt, stateTable);
    disp(M);
    disp('*****');
    
end

function test4(shared)
    disp('TEST 4:');
    M = FSM2.StateMachine();
    stPresentInpt = [0 1 2];
    stateTable = [...
        [0 0 1 1 0];...
        [1 1 0 0 1];...
        ];
    
    M.AddStateTable(stPresentInpt,stateTable);
    M.Initialize(0);
    
    disp(M);
    disp('*****');
    
    outputSequence = M.SendInputSequence([2 1 1 0]);    
    disp(outputSequence);
    
    disp(M);        

end

function change()
    fprintf('Changing...\n');
end

function err()
    fprintf('What have you done?\n');
end
