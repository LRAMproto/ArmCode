function trajectory = TrajectoryFunc(freeflight_index, data)
%TRAJECTORYFUNC Rebuild trajectory based on release times
%   Detailed explanation goes here

i = freeflight_index;

% Constants
l = .4572;      % Arm length, meters
r = .03835;     % Spool radius, meters
e = pi - 3.514; % error of

% Arm angle
dth = (data.fsData(i + 1, 1) - data.fsData(i - 1, 1))./...
      (data.fsTime(i + 1) - data.fsTime(i - 1));
th = data.fsData(i, 1);
% String angle
dpsi = (data.fsData(i + 1, 6) - data.fsData(i - 1, 6))./...
      (data.fsTime(i + 1) - data.fsTime(i - 1));
psi = data.fsData(i, 6);
% String length and speed
% First remove spikes
Ls = data.fsData((i-2):(i+2),4);
for n = 2:4
    if Ls(n+1) - Ls(n) > 5.9
        Ls(n) = (Ls(n+1) + Ls(n-1))/2;
        break
    end
end

dL = r*(Ls(4) - Ls(2))/(data.fsTime(i + 1) - data.fsTime(i - 1));
L = r*Ls(3);

% dpsi should be zero at this point
v_x = cos(th)*l*dth  + dL*sin(psi+e-th) + L*(-dth)*cos(psi+e-th);
v_y = -sin(th)*l*dth - dL*cos(psi+e-th) + L*(-dth)*sin(psi+e-th);

% Projectile Position
proj_x = l*sin(th) + L*sin(psi+e-th);
proj_y = -.838 + l*cos(th) - L*cos(psi+e-th);

end_t = (2.75 - proj_x)/v_x;
mask = [zeros(1,i-1),ones(1,length(data.fsTime)-(i-1))];
i_end = find(and(mask', (data.fsTime - data.fsTime(i)) >= end_t), 1, 'first');

t = data.fsTime(i:i_end) - data.fsTime(i);

trajectory = [v_x*t + proj_x, v_y*t - 4.9*t.^2 + proj_y];
end

