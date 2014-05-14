function [taunt_path,slack_path] = SlackChecker(freeflight_index,data,trajectory)
%TRAJECTORYFUNC Rebuild trajectory based on release times
%   Detailed explanation goes here

i = freeflight_index;
n = length(trajectory(:,1));
temp_indices = i:(i+n-1);

% Constants
l = .4572;      % Arm length, meters
r = .03835;     % Spool radius, meters
e = pi - 3.514; % error of

% Arm angle
dth = (data.fsData(temp_indices + 1, 1) - data.fsData(temp_indices - 1, 1))./...
      (data.fsTime(temp_indices + 1) - data.fsTime(temp_indices - 1));
th = data.fsData(i:(i+n-1), 1);

% Arm Position
arm_x = l*sin(th);
arm_y = -.838 + l*cos(th);

% Distance between ball and end of arm
d = sqrt((trajectory(:,1)-arm_x).^2 + (trajectory(:,2)-arm_y).^2);

% String length and speed
% First remove spikes
L = data.fsData(i:(i+n-1),4);
for m = 2:(length(L) - 1)
    if L(m+1) - L(m) > 5.9
        L(m) = (L(m+1) + L(m-1))/2;
    end
end
L = r*L;

gap = 0.005;
i_taunt = find( (d-L) >= gap );
i_slack = find( (d-L) < gap );

taunt_path = [trajectory(i_slack(end):end,1),trajectory(i_slack(end):end,2)];
slack_path = [trajectory(i_slack,1),trajectory(i_slack,2)];
end

