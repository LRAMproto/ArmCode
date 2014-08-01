% Bad Cast 1: Stopped short, tangled on self
% Bad Cast 2: ditto
% Good Cast:  Made it over bar, suspjed at j.
clearvars -except Ts tg
close all
% 1 Spool pos (rad)
% 2 Spool Velo (rad/sec)
% 3 Spool Cmd (amps)

% GC = load('ByHandCastAlmost.mat');
GC = load('SpoolSpinUpTest.mat');

% Time Frames
% plot_from = [7,12];
event = find(GC.fsData(:,3) < -7, 1, 'first');
i = event - 25;
j = event+100;
% i = find(plot_from(1) < GC.fsTime, 1, 'first');
% j = find(plot_from(2) > GC.fsTime, 1, 'last');

% Find smooth interpolation of points and fit a curve
a = [GC.fsTime(event:j).^2,GC.fsTime(event:j),ones(101,1)] \ GC.fsData(event:j,1);

figure
subplot(2,1,1)
[hAx1, h_l1, h_l2] = plotyy(GC.fsTime(i:j), GC.fsData(i:j,1),...
                            GC.fsTime(i:j), -GC.fsData(i:j,3));
ylabel(hAx1(1), 'Position (rad)')
grid on
ylabel(hAx1(2), 'Cmd (rad)')
title('Spool')
subplot(2,1,2)
t = GC.fsTime(i:j);
plot(t(1:end-1), diff(GC.fsData(i:j,1))./diff(GC.fsTime(i:j)))
hold on
plot(t(1:end-1), diff(a(1)*t.^2 + a(2)*t + a(3))./diff(t),'r')
grid on
ylabel('rad/sec')
xlabel('seconds')
