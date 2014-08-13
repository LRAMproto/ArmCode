function statemachinetest(tests)
%STATEMACHINETEST Summary of this function goes here
%   Detailed explanation goes here


testOpts = {@test1,@test2, @test3};
if nargin == 0
    tests = [1,2,3];
end

sm = [];
vars = [];

for k=1:length(tests)
    testToRun = testOpts{tests(k)};
    [sm,vars] = testToRun(sm,vars);
end

end

function [sm,vars] = test1(sm,vars)

fprintf('***** Test 1\n');
vars.RED = FSM.State(1,'Red');
vars.GREEN = FSM.State(2,'Green');
vars.YELLOW = FSM.State(3,'Yellow');
vars.YIELD = FSM.State(4,'Blinking Red (Yield)');
sm = FSM.StateMachine('Stop Light',vars.RED);
assert(isequal(sm.currentState,vars.RED));
disp(sm);
end

function [sm,vars] = test2(sm,vars)
fprintf('***** Test 2\n');


sm.AddTransition(FSM.Transition(vars.RED,'Change',vars.GREEN));
assert(isequal(sm.currentState,vars.RED));

sm.AddTransition(FSM.Transition(vars.GREEN,'Change',vars.YELLOW));
assert(isequal(sm.currentState,vars.RED));

sm.AddTransition(FSM.Transition(vars.YELLOW,'Change',vars.RED));
assert(isequal(sm.currentState,vars.RED));

sm.AddAbsTransition('Power Interrupt',vars.YIELD);

sm.SendSignal('Change');
assert(isequal(sm.currentState,vars.GREEN));

sm.SendSignal('Change');
assert(isequal(sm.currentState,vars.YELLOW));
disp(sm);


sm.SendSignal('Power Interrupt');
assert(isequal(sm.currentState,vars.YIELD));
disp(sm);

end

function [sm,vars] = test3(sm,vars)
fprintf('***** Test 3\n');


sm.SendSignal('WHARRBLGRBL');
assert(isequal(sm.currentState,vars.YIELD));
disp(sm);
end