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
% 7 String Angle Velo (rad/sec)


% GC = load('ByHandCastAlmost.mat');
GC = load('ByHandCastHit.mat');

sigfunc = @(A, x)(A(1) ./ (1 + exp(-A(2).*(x+A(3))) ) );
% sigfunc = @(A, x)(A(1) ./ (A(2) + exp(-x)) );
A0 = [40,2,-35]; %// Initial values fed into the iterative algorithm
% A_fit = nlinfit(x, y, sigfunc, A0);

% Time Frames
plot_from = [33.5,37.5];
i = find(plot_from(1) < GC.fsTime, 1, 'first');
j = find(plot_from(2) > GC.fsTime, 1, 'last');

A_fit_org = nlinfit(GC.fsTime(i:j), GC.fsData(i:j,4), sigfunc, A0);
% A_fit = A_fit_org.*[1.33,.75,1.04]; % Just kinda thuds
% A_fit = A_fit_org.*[1.33,.6,1.049]; % Wraps self
% A_fit = A_fit_org.*[1.4,.4,1.055];
A_fit = A_fit_org.*[1,1,1.003];

figure
subplot(2,1,1)
plot(GC.fsTime(i:j), sigfunc(A_fit_org,GC.fsTime(i:j)))
hold on
plot(GC.fsTime(i:j), sigfunc(A_fit,GC.fsTime(i:j)),'r')
legend('Original','Modified','Location','Northwest')
ylabel('rad')
subplot(2,1,2)
plot(GC.fsTime(i:j-1), diff(sigfunc(A_fit_org,GC.fsTime(i:j)))./diff(GC.fsTime(i:j)))
hold on
plot(GC.fsTime(i:j-1), diff(sigfunc(A_fit,GC.fsTime(i:j)))./diff(GC.fsTime(i:j)),'r')
legend('Original','Modified','Location','Northwest')
ylabel('rad/sec')



%%%%%%%%%%%%%%%%% Back Calculate Commands sent to the Motors %%%%%%%%%%%%%%
% Motor constants
Kt_old = 13.5;              % oz-in/amp, torque constant
Kt     = Kt_old * .007062;  % N-m/amp, torque constant
Gr     = 13.72;             % Gear Ratio

%%% Spool %%%
psi = sigfunc(A_fit,GC.fsTime(i:j));
dpsi = diff(psi)./diff(GC.fsTime(i:j));
ddpsi = diff(dpsi)./diff(GC.fsTime(i:j-1));

% ud_spool = ((1.172*10^-6)*ddpsi + (2.844*10^-4)*dpsi(1:end-1))/Kt;
ud_spool = ((5*10^-5)*ddpsi + (9*10^-4)*dpsi(1:end-1))/Kt;

%%% Arm %%%
th = smooth(GC.fsData(i:j,1),51,'loess');
dth = diff(th)./diff(GC.fsTime(i:j));
ddth = diff(dth)./diff(GC.fsTime(i:j-1));

ud_arm = ((.0529)*ddth + (0.4328)*dth(1:end-1))/(Kt*Gr);

%%%%%%%%%%%%%%%%%%%% Graph Results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
subplot(2,1,1)
[hAx1, h_l1, h_l2] = plotyy(GC.fsTime(i:j), GC.fsData(i:j,1),...
                           GC.fsTime(i:j), sigfunc(A_fit,GC.fsTime(i:j)));
ylabel(hAx1(1), 'Arm (rad)')
ylabel(hAx1(2), 'Spool (rad)')
title('Trajectory')

subplot(2,1,2)
[hAx2, h_l3, h_l4] = plotyy(GC.fsTime(i:j-2),ud_arm,...
                           GC.fsTime(i:j-2),ud_spool);
xlabel('sec')
ylabel(hAx2(1), 'Arm (amps)')
ylabel(hAx2(2), 'Spool (amps)')
title('Command')
clear hAx1 hAx2 h_l1 h_l2 h_l3 h_l4

%%%%%%%%%%%%%%%%%%%% Graph Comparison %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A1 = A_fit_org.*[1.33,.75,1.04]; % Just kinda thuds
A2 = A_fit_org.*[1.4,.55,1.044];

figure
subplot(2,1,1)
title('Comparison')
plot(GC.fsTime(i:j), sigfunc(A_fit_org,GC.fsTime(i:j)))
hold on
plot(GC.fsTime(i:j), sigfunc(A_fit,GC.fsTime(i:j)),'r')
plot(GC.fsTime(i:j), sigfunc(A1,GC.fsTime(i:j)),'k')
plot(GC.fsTime(i:j), sigfunc(A2,GC.fsTime(i:j)),'g')
legend('Original','New','Highest','Low','Location','Northwest')
ylabel('rad')
subplot(2,1,2)
plot(GC.fsTime(i:j-1), diff(sigfunc(A_fit_org,GC.fsTime(i:j)))./diff(GC.fsTime(i:j)))
hold on
plot(GC.fsTime(i:j-1), diff(sigfunc(A_fit,GC.fsTime(i:j)))./diff(GC.fsTime(i:j)),'r')
plot(GC.fsTime(i:j-1), diff(sigfunc(A1,GC.fsTime(i:j)))./diff(GC.fsTime(i:j)),'k')
plot(GC.fsTime(i:j-1), diff(sigfunc(A2,GC.fsTime(i:j)))./diff(GC.fsTime(i:j)),'g')
legend('Original','New','Highest','Low','Location','Northwest')
ylabel('rad/sec')
%%%%%%%%%%%%%%%%%%%% Export Data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Time = GC.fsTime(i:j-2)-GC.fsTime(i);
xd_arm = GC.fsData(i:j-2,1);
xd_spool = sigfunc(A_fit,GC.fsTime(i:j-2));
save CastingTrajectory.mat Time xd_arm ud_arm xd_spool ud_spool;

