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
% plot_from = [51, 56];
i = find(plot_from(1) < GC.fsTime, 1, 'first');
j = find(plot_from(2) > GC.fsTime, 1, 'last');

% Events
% Constants
stop_ArmPos = 2.9916;   % rad, Position arm triggers cast
stop_String = 3.75;     % rad, Position String Angle triggers cast
far_Enough  = 65;       % rad, How far before string is jerked back
goal_dist_x = 2.184;    % meter, x position
goal_dist_y = -.8255;   % meter, y position

% Release time index
i_re = find(and(stop_ArmPos >= GC.fsData(:,1), stop_String >= GC.fsData(:,6)), 1, 'first');
% Free Flight time index
mask = [zeros(1,i_re-1),ones(1,length(GC.fsTime)-i_re)];
% i_ff = find(and(mask', diff(GC.fsData(:,6))./diff(GC.fsTime) >= 0), 1, 'first');
i_ff = i_re+6;

plot(GC.fsTime(i:j), GC.fsData(i:j,1:3))
legend('Arm pos', 'Target Pos', 'Cmd')

l = .4572;      % Arm length, meters
r = .03835;     % Spool radius, meters
e = pi - 3.514; % error of
% Note: arm oriented such that pi is straight down and angle increases with
% clockwise motion.  But frame of references is Y is up and X is to the
% right (at th = 0, the direction arm moves in when moving clockwise)
% Arm angle
dth = (GC.fsData(i_ff + 1, 1) - GC.fsData(i_ff - 1, 1))/...
      (GC.fsTime(i_ff + 1) - GC.fsTime(i_ff - 1));
th = GC.fsData(i_ff, 1);
% String angle
dpsi = (GC.fsData(i_ff + 1, 6) - GC.fsData(i_ff - 1, 6))/...
      (GC.fsTime(i_ff + 1) - GC.fsTime(i_ff - 1));
psi = GC.fsData(i_ff, 6);
% String length and speed
dL = r*(GC.fsData(i_ff + 1, 4) - GC.fsData(i_ff - 1, 4))/...
      (GC.fsTime(i_ff + 1) - GC.fsTime(i_ff - 1));
L = r*GC.fsData(i_ff,4);

% dpsi should be zero at this point
% v_x = cos(th)*l*dth - dL*sin(psi+e-th) - L*(dpsi - dth)*cos(psi+e-th);
% v_y = -sin(th)*l*dth- dL*cos(psi+e-th) + L*(dpsi - dth)*sin(psi+e-th);
v_x = cos(th)*l*dth  + dL*sin(psi+e-th) + L*(-dth)*cos(psi+e-th);
v_y = -sin(th)*l*dth - dL*cos(psi+e-th) + L*(-dth)*sin(psi+e-th);

%******* NOTE ************************************************************%
% Examine this!
%v_x_minus_arm = dL*sin(psi+e-th) + L*(-dth)*cos(psi+e-th);
%v_y_minus_arm = -sin(th)*l*dth - dL*cos(psi+e-th) + L*(-dth)*sin(psi+e-th);

% Arm Position
arm_x = l*sin(th);
arm_y = -.838 + l*cos(th);
% Projectile Position
proj_x = l*sin(th) + L*sin(psi+e-th);
proj_y = -.838 + l*cos(th) - L*cos(psi+e-th);

t = GC.fsTime(i:j) - GC.fsTime(i);
figure
traj = [v_x*t + proj_x,...
        v_y*t - 4.9*t.^2 + proj_y];
trajectory = TrajectoryFunc(i_ff,GC);
plot(traj(:,1),traj(:,2))
hold on
plot(trajectory(:,1),trajectory(:,2),'k')
% Arm
line([0,arm_x], [-.838,arm_y] , 'Color','r', 'Linewidth', 2)
% Line Position
line([arm_x,proj_x],[arm_y,proj_y], 'Color','k', 'Linewidth', 2)
hold on
plot(goal_dist_x, goal_dist_y, 'k.', 'Linewidth', 4, 'MarkerSize', 15)
xlabel('x pos(m)')
ylabel('y pos(m)')
title('Hypothetical Projectile Path')
axis([-.25,3.25, -1.5,.25])

% title('Arm')
% xlabel('sec')
% ylabel('rad or amps')
% legend('Arm pos','Target', 'Cmd amps', 'Location', 'SouthEast')
% 
% figure
% plot(GC.fsTime(i:j), GC.fsData(i:j,4:5))
% title('Spool')
% xlabel('sec')
% ylabel('rad or amps')
% legend('Spool pos','Cmd amps', 'Location', 'SouthEast')
% 
% figure
% [hA, h_b1, h_b2] = plotyy(GC.fsTime(i:j), GC.fsData(i:j,6),...
%                           GC.fsTime(i+1:j), diff(GC.fsData(i:j,6))./diff(GC.fsTime(i:j)));
% grid on
% title('String Angle')
% xlabel('sec')
% ylabel(hA(1), 'rad')
% ylabel(hA(2), 'rad/sec')
% legend('position', 'velocity', 'Location', 'SouthEast')
% 
figure
[hAx, h_l1, h_l2] = plotyy(GC.fsTime(i:j), GC.fsData(i:j,[1,2,6]),...
                           GC.fsTime(i:j), GC.fsData(i:j,[4]));
line([GC.fsTime(i_re),GC.fsTime(i_re)],[0,10],'Color',[.4,.4,.4])
xlabel('sec')
ylabel(hAx(1), 'rad')
ylabel(hAx(2), 'Spool (rad)')
legend('Arm Pos', 'Arm Target', 'String Angle', 'Spool',...
       'Location', 'NorthWest')