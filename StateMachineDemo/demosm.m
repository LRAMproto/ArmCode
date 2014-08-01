function caster = demosm()
caster = CasterStateMachine('STOP');
fprintf('**Initializing...\n\n');
set(caster,...
    'fireFcn',@fireFcn,...
    'releaseFcn',@releaseFcn,...
    'freeFlightCheckFcn',@freeFlightCheckFcn,...
    'atGoalFcn',@atGoalFcn,...
    'errorFcn',@errorFcn,...
    'resetFcn',@resetFcn,...
    'doneFcn',@doneFcn...
    );
caster.Initialize();
% Routine
% disp(caster);
% notify(caster,'Fire');
% disp(caster);
% notify(caster,'Release');
% disp(caster);
% notify(caster,'Fire');
% disp(caster);
% fprintf('\n');
% fprintf('** End Simulation\n');

end

function fireFcn(caster, eventdata)
fprintf('Fire!\n');
switch caster.state
    case 'READY'
        set(caster,'state','ACCEL');
    otherwise
end
end

function releaseFcn(caster, eventdata)
fprintf('Release!\n');
switch caster.state
    case 'ACCEL'
    set(caster,'state','RELEASE');
    case 'READY'
        fprintf('You just dropped the ball.\n');
        notify(caster,'Error');
    otherwise
end
end

function freeFlightCheckFcn(caster, eventdata)
fprintf('Free Flight Check!\n');
switch caster.state
    case 'RELEASE'
        set(caster,'state','SPOOL');
    otherwise
end
end

function atGoalFcn(caster, eventdata)
fprintf('At Goal!\n');
switch caster.state
    case 'SPOOL'
        set(caster,'state','WRAP');
    otherwise
end
end

function errorFcn(caster, eventdata)
fprintf('Error!\n');
switch caster.state
    otherwise
end
set(caster,'state','STOP');
end

function resetFcn(caster, eventdata)
fprintf('Reset!\n');
switch caster.state
    case 'STOP'
        set(caster,'state','REARM');
end
end

function doneFcn(caster, eventdata)
fprintf('Done!\n');
switch caster.state
    case 'REARM'
        set(caster,'state','READY');
    case 'WRAP'
        set(caster,'state','STOP');
    otherwise
end
end
