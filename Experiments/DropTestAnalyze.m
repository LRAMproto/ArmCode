% Bad Cast 1: Stopped short, tangled on self
% Bad Cast 2: ditto
% Good Cast:  Made it over bar, suspjed at j.
clearvars -except Ts tg
% close all
% 1 Arm pos (rad)
% 2 Spool pos (rad)
% 3 String pos (rad)
% 4 Arm velo (rad/sec)
% 5 Spool velo (rad/sec)
% 6 String velo (rad/sec)

% GC = load('ByHandCastAlmost.mat');
GC = load('DropTest.mat');

% Time Frames
plot_from = [23.5,26];
% event = find(GC.fsData(:,3) < -7, 1, 'first');
% i = event - 25;
% j = event+100;
i = find(plot_from(1) < GC.fsTime, 1, 'first');
j = find(plot_from(2) > GC.fsTime, 1, 'last');

% Find smooth interpolation of points and fit a curve
% a = [GC.fsTime(event:j).^2,GC.fsTime(event:j),ones(101,1)] \ GC.fsData(event:j,1);

figure
plot(GC.fsTime(i:j), GC.fsData(i:j,1:3))

figure
% subplot(2,1,1)
[hAx1, h_l1, h_l2] = plotyy(GC.fsTime(i:j), GC.fsData(i:j,3),...
                            GC.fsTime(i:j), GC.fsData(i:j,6));
ylabel(hAx1(1), 'Position (rad)')
grid on
ylabel(hAx1(2), 'Velo (rad/sec)')
title('String Pos')
% subplot(2,1,2)
% t = GC.fsTime(i:j);
% plot(t(1:end-1), diff(GC.fsData(i:j,1))./diff(GC.fsTime(i:j)))
% hold on
% plot(t(1:end-1), diff(a(1)*t.^2 + a(2)*t + a(3))./diff(t),'r')
% grid on
% ylabel('rad/sec')
% xlabel('seconds')
% 
% dx = [0; diff(GC.fsData(:,3))./diff(GC.fsTime(:))];
% figure
% plot(GC.fsTime(i:j), GC.fsData(i:j,6))
% hold on
% plot(GC.fsTime(i:j), dx(i:j),'r')
% 
% figure
% plot(GC.fsTime(:),(GC.fsData(:,6)-dx))