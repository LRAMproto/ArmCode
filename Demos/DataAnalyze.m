% Bad Cast 1: Stopped short, tangled on self
% Bad Cast 2: ditto
% Good Cast:  Made it over bar, suspended at end.
clearvars -except Ts tg
close all
% 1 Arm pos (rad)
% 2 Arm target pos (rad)
% 3 Arm Feed Forward Values (amps)
% 4 Arm Cmd (amps)
% 5 Spool pos (rad)
% 6 Spool Target pos (rad)
% 7 Spool Feed Forward Values (amps)
% 8 Spool Cmd (amps)
% 9 String Angle (rad)
%10 String Velo (rad/sec)


% GC = load('FirstTrajFollow.mat');
% GC = load('SecondTrajFollow.mat');
% plot_from = [93, 98];
GC = load('SlackAnalyze.mat');

% Time Frames
plot_from = [318, 324];
i = find(plot_from(1) < GC.fsTime, 1, 'first');
j = find(plot_from(2) > GC.fsTime, 1, 'last');



%%%%% Plot Arm Values %%%%%
figure
subplot(2,1,1)
title('Arm', 'Fontsize',16)
plot(GC.fsTime(i:j), GC.fsData(i:j,[1:2]))
grid on
legend('Arm Pos', 'Arm Target', 'Location', 'NorthWest')
ylabel('rad')
subplot(2,1,2)
plot(GC.fsTime(i:j), GC.fsData(i:j,[3:4]))
grid on
legend('Arm FF', 'Arm Cmd', 'Location', 'NorthWest')

ylabel('amps')
xlabel('sec')

%%%%% Plot Spool Values %%%%%
figure
subplot(2,1,1)
title('Arm', 'Fontsize',16)
plot(GC.fsTime(i:j), GC.fsData(i:j,[5:6]))
grid on
legend('Spool Pos', 'Spool Target', 'Location', 'NorthWest')
ylabel('rad')
subplot(2,1,2)
plot(GC.fsTime(i:j), GC.fsData(i:j,[7:8]))
grid on
legend('Spool FF', 'Spool Cmd', 'Location', 'NorthWest')

ylabel('amps')
xlabel('sec')

% [hAx, h_l1, h_l2] = plotyy(GC.fsTime(i:j), GC.fsData(i:j,[1:2]),...
%                            GC.fsTime(i:j), GC.fsData(i:j,[3:4]));
% ylabel(hAx(1), 'rad')
% ylabel(hAx(2), 'amps')
% legend(hAx(1),'Arm Pos', 'Arm Target','Arm FF', 'Arm Cmd')

% String Angle
figure
[hA, h_b1, h_b2] = plotyy(GC.fsTime(i:j), GC.fsData(i:j,9),...
                           GC.fsTime(i:j), GC.fsData(i:j,10));
grid on
title('String Angle')
xlabel('sec')
ylabel(hA(1), 'rad')
ylabel(hA(2), 'rad/sec')
legend('position', 'velocity', 'Location', 'SouthEast')
