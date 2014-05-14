% Bad Cast 1: Stopped short, tangled on self
% Bad Cast 2: ditto
% Good Cast:  Made it over bar, suspended at end.
clearvars -except Ts tg
close all
% 1 Arm pos (rad)
% 2 Arm target pos (rad)
% 3 Arm Cmd (amps)
% 4 Spool pos (rad)
% 5 Spool Cmd (amps)
% 6 String Angle (rad)

GC  = load('GoodCastDataLog.mat');

% Time Frames
plot_from = [21, 26];
% i2 = find(plot_from(1) < GC.fsTime, 1, 'first');
% j2 = find(plot_from(2) > GC.fsTime, 1, 'last');

i = find(-5 > GC.fsData(:,3), 1, 'first');
j = find(-5 > GC.fsData(:,3), 1, 'last');

% Motor constants
Kt_old = 13.5;              % oz-in/amp, torque constant
Kt     = Kt_old * .007062;  % N-m/amp, torque constant
Gr     = 13.72;             % Gear Ratio

t  = GC.fsTime(i:j);
th_raw = GC.fsData(i:j,1);
dth_raw = diff(th_raw)./diff(t);
ddth_raw = diff(dth_raw)./diff(t(1:end-1));

tfunc4 = @(x)([x.^4,x.^3,x.^2,x,ones(length(x),1)]);
tfunc3 = @(x)([x.^3,x.^2,x,ones(length(x),1)]);
tfunc2 = @(x)([x.^2,x,ones(length(x),1)]);
tfunc1 = @(x)([x,ones(length(x),1)]);

A_pos = tfunc3(t)\th_raw;

th_smo = tfunc3(t)*A_pos;
dth_smo = diff(th_smo)./diff(t);
ddth_smo = diff(dth_smo)./diff(t(1:end-1));

figure
subplot(3,1,1)
plot(t,th_raw)
hold on
plot(t,th_smo,'r')
subplot(3,1,2)
plot(t(1:end-1),dth_raw)
hold on
plot(t(1:end-1),dth_smo,'r')
subplot(3,1,3)
plot(t(1:end-2),ddth_raw)
hold on
plot(t(1:end-2),ddth_smo,'r')

% Now calculate J (inertia) and B (damping) for the system
motor_cons = [ddth_smo(1:end-20), dth_smo(1:end-21)]\[ones(length(ddth_smo(1:end-20)),1)*-6*Kt*Gr];
J_arm = motor_cons(1);
B_arm = motor_cons(2);

figure
plot([ddth_smo(1:end-20), dth_smo(1:end-21)]*motor_cons)



figure
plot(GC.fsTime(i:j), GC.fsData(i:j,1:3))
title('Arm')
xlabel('sec')
ylabel('rad or amps')
legend('Arm pos','Target', 'Cmd amps', 'Location', 'SouthEast')

%%%%%%%%%%% Now Find Spool Constants %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i = find(0 < GC.fsData(:,5), 1, 'first');
j = find(0 < GC.fsData(:,5), 1, 'last');

% Motor constants
Kt_old = 13.5;              % oz-in/amp, torque constant
Kt     = Kt_old * .007062;  % N-m/amp, torque constant

t  = GC.fsTime(i:j);
th_raw = GC.fsData(i:j,4);
% Remove artifacts (spikes) in data
for n = 2:length(th_raw)-1
    if th_raw(n+1) - th_raw(n) > 5.9
        th_raw(n) = (th_raw(n+1) + th_raw(n-1))/2;
    end
end
% Done removing artifacts
dth_raw = diff(th_raw)./diff(t);
ddth_raw = diff(dth_raw)./diff(t(1:end-1));

A_pos = tfunc3(t)\th_raw;

th_smo = tfunc3(t)*A_pos;
dth_smo = diff(th_smo)./diff(t);
ddth_smo = diff(dth_smo)./diff(t(1:end-1));

figure
subplot(3,1,1)
plot(t,th_raw)
hold on
plot(t,th_smo,'r')
subplot(3,1,2)
plot(t(1:end-1),dth_raw)
hold on
plot(t(1:end-1),dth_smo,'r')
subplot(3,1,3)
plot(t(1:end-2),ddth_raw)
hold on
plot(t(1:end-2),ddth_smo,'r')

% Now calculate J (inertia) and B (damping) for the system
motor_cons = [ddth_smo(1:end-20), dth_smo(1:end-21)]\[ones(length(ddth_smo(1:end-20)),1)*.25*Kt];
J_spool = motor_cons(1);
B_spool = motor_cons(2);

figure
plot([ddth_smo(1:end-20), dth_smo(1:end-21)]*motor_cons)
