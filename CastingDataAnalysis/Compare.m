% This script seeks to compare the difference between the "GoodCast" and
% the "AlmostFlat" cast.  The first one the ball is released passively
% while in the second it is "actively" released by spooling the motor
% foward a set amount.

close all
clear all

GC  = load('GoodCastDataLog.mat');
AC  = load('AlmostFlat.mat');
AC2  = load('AlmostFlatv2.mat');
BC.fsTime = AC2.fsTime(50000:end);
BC.fsData = AC2.fsData(50000:end,:);

% Events
% Constants
stop_ArmPos = 2.9916;   % rad, Position arm triggers cast
stop_String = 3.75;     % rad, Position String Angle triggers cast
far_Enough  = 65;       % rad, How far before string is jerked back

% Release time index
i_gc = find(and(stop_ArmPos >= GC.fsData(:,1), stop_String >= GC.fsData(:,6)), 1, 'first');
i_ac = find(and(stop_ArmPos >= AC.fsData(:,1), stop_String >= AC.fsData(:,6)), 1, 'first');
i_bc = find(and(stop_ArmPos >= BC.fsData(:,1), stop_String >= BC.fsData(:,6)), 1, 'first');
% Release time
t_gc = GC.fsTime(i_gc);
t_ac = AC.fsTime(i_ac);
t_bc = BC.fsTime(i_bc);

%Plot Graphs
plot(GC.fsTime((i_gc-10):(50+i_gc))-t_gc, GC.fsData((i_gc-10):(50+i_gc),4)-min(GC.fsData((i_gc-10),4)),'b')
hold on
plot(GC.fsTime((i_gc-10):(50+i_gc))-t_gc, GC.fsData((i_gc-10):(50+i_gc),5),'r')
plot(AC.fsTime((i_ac-10):(50+i_ac))-t_ac, AC.fsData((i_ac-10):(50+i_ac),4),'k')
plot(AC.fsTime((i_ac-10):(50+i_ac))-t_ac, AC.fsData((i_ac-10):(50+i_ac),5),'m')
plot(BC.fsTime((i_bc-10):(50+i_bc))-t_bc, BC.fsData((i_bc-10):(50+i_bc),4)-min(BC.fsData((i_bc-10):(50+i_bc),4)),'g')
plot(BC.fsTime((i_bc-10):(50+i_bc))-t_bc, BC.fsData((i_bc-10):(50+i_bc),5),'c')
legend('Free spool', 'Free Cmd', 'PID spool','PID Cmd','PID2 spool','PID2 Cmd', 'Location', 'Southeast')
line([GC.fsTime(i_gc)-t_gc,GC.fsTime(i_gc)-t_gc],[-6,25],'Color',[.4,.4,.4])
xlabel('Time since release event (sec)')
ylabel('rad/amps')
title('Spool release event comparison')