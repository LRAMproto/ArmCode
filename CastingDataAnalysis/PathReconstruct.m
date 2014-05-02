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

% Time Frame
plot_from = [21, 26];
i = find(plot_from(1) < GC.fsTime, 1, 'first');
j = find(plot_from(2) > GC.fsTime, 1, 'last');

% Events
% Constants
stop_ArmPos = 2.9916;   % rad, Position arm triggers cast
stop_String = 3.75;     % rad, Position String Angle triggers cast
far_Enough  = 65;       % rad, How far before string is jerked back

% Release time index
i_re = find(and(stop_ArmPos >= GC.fsData(:,1), stop_String >= GC.fsData(:,6)), 1, 'first');

plot(GC.fsTime(i:j), GC.fsData(i:j,1:3))

% Note: arm oriented such that pi is straight down and angle increases with
% clockwise motion.  But frame of references is Y is up and X is to the
% right (at th = 0, the direction arm moves in when moving clockwise)
dth = (GC.fsData(i_re + 1, 1) - GC.fsData(i_re - 1, 1))/...
      (GC.fsTime(i_re + 1) - GC.fsTime(i_re - 1));
th = GC.fsData(i_re, 1);

l = .4572;  % Arm length, meters
v_x = -cos(th)*l*-dth;
v_y = sin(th)*l*-dth;

t = GC.fsTime(i:j) - GC.fsTime(i);
figure
plot(v_x*t, v_y*t - 4.9*t.^2 - (.838 - l*cos(th)))
xlabel('x pos(m)')
ylabel('y pos(m)')
title('Hypothetical Projectile Path')

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
%                            GC.fsTime(i+1:j), diff(GC.fsData(i:j,6))./diff(GC.fsTime(i:j)));
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