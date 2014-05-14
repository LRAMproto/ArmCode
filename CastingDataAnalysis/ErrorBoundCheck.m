% Script is designed to analyze the possible paths the projectile could
% take if it is assumed that the ball enters free flight some time after
% the "Release" command is given.

% Bad Cast 1: Stopped short, tangled on self
% Bad Cast 2: ditto
% Good Cast:  Made it over bar, suspended at end.
clear
close all
% 1 Arm pos (rad)
% 2 Arm target pos (rad)
% 3 Arm Cmd (amps)
% 4 Spool pos (rad)
% 5 Spool Cmd (amps)
% 6 String Angle (rad)

% GC = load('BadBasicCastDataLog.mat');
% GC = load('BadBasicCast2DataLog.mat');
GC  = load('GoodCastDataLog.mat');
% GC = load('AlmostFlat.mat');

% Time Frames
plot_from = [21, 26];
% plot_from = [69,75];
i = find(plot_from(1) < GC.fsTime, 1, 'first');
j = find(plot_from(2) > GC.fsTime, 1, 'last');

% Events
% Constants
stop_ArmPos = 2.9916;   % rad, Position arm triggers cast
stop_String = 3.75;     % rad, Position String Angle triggers cast
goal_dist_x = 2.184;    % meter, x position
goal_dist_y = -.8255;   % meter, y position

% Release time index
i_re = find(and(stop_ArmPos >= GC.fsData(:,1), stop_String >= GC.fsData(:,6)), 1, 'first');
% Free Flight time index
mask = [zeros(1,i_re-1),ones(1,length(GC.fsTime)-i_re)];
i_ff = find(and(mask', diff(GC.fsData(:,6))./diff(GC.fsTime) >= 0), 1, 'first');

% Error in ms
err = 10;
i_err = round(err/5);

figure
plot(goal_dist_x, goal_dist_y, 'm.', 'Linewidth', 4, 'MarkerSize', 15)
axis([-.25,3, -1.5,.25])
hold on
for i=(i_ff+2-i_err):(i_ff+2+i_err)
    trajectory = TrajectoryFunc(i,GC);
    [taunt,slack] = SlackChecker(i,GC,trajectory);
    plot(taunt(:,1),taunt(:,2),'b', 'Linewidth',2)
    plot(slack(:,1),slack(:,2),'r', 'Linewidth',2)
    transition_pts(i-i_re+1,:) = [slack(end,1),slack(end,2)];
end