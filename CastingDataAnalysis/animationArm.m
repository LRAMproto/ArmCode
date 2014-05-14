function animationMotorPogo(T, ArmData)
% 3D Visualization Template
% Input
%   T = [t0, t1]: Simulation time
%   ArmData: Simulation data
% Output
%   An animation
% By Luke Hill

% For SE3
addpath('groupTheory')
% For 
addpath('visualization')

ArmColors= [1 0 0;
              1 .3 0;
              1 .3 0;
              1 .3 0;
              1 .3 0;
              1 .3 0;
              1 0 0;
              1 .3 0];

EncColors = [0 0 1;
              0 .4 1;
              0 .4 1;
              0 .4 1;
              0 .4 1;
              0 .4 1;
              0 0 1;
              0 .4 1];
          
DotColors = [.4 .4 .4;
              .4 .4 .4;
              .4 .4 .4;
              .4 .4 .4;
              .4 .4 .4;
              .4 .4 .4;
              .4 .4 .4;
              .4 .4 .4];
         
% Global Rotation around z-axis
thetaz = 0;
gR     = [0, 0, thetaz];

% Create objects
l = .4572;      % Arm length, meters
r = .03835;     % Spool radius, meters
% e = pi - 3.514; % error of
e = pi - 3.4655; % error of

massSide= 0.1; % m
armObj = CubeClass([l, .1*massSide, .1*massSide]);
encObj = CylinderClass(.25*massSide, .1*massSide);
dotObj = CylinderClass(.1*massSide, .1*massSide);

armObj.colors = ArmColors;
% encObj.colors = EncColors;
% dotObj.colors = DotColors;

% Create a figure handle
h.figure = figure;

% Put the shapes into a plot
armObj.plot
encObj.plot
dotObj.plot


% Figure properties
view(2)
title('Simulation')
xlabel('x Position (m)')
ylabel('y Position (m)')
zlabel('z Position (m)')

% Speed up if watching in realtime
frameStep = 1;

i = find(T(1) < ArmData.fsTime, 1, 'first');
j = find(T(2) > ArmData.fsTime, 1, 'last');

% Iterate over state data
for it = 1:frameStep:length( ArmData.fsTime(i:j) )
    th = ArmData.fsData((i+it-1),1);     % Arm Angle
    psi = ArmData.fsData((i+it-1),6);    % String Angle
    L = r*ArmData.fsData((i+it-1),4);    % String Length

    % Set axis limits
    axis([-.5 .5 ... % x
          -.75 .25 ... % y
          -1.0 1.0]);  % z

    
    % Arm position
    armObj.resetFrame
    x = (l/2)*sin(th);
    y = (l/2)*cos(th);
    armObj.globalMove(SE3([x,y,0, gR+[0,0,pi/2-th]]));
    
    % enc position
    encObj.resetFrame
    x = l*sin(th);
    y = l*cos(th);
    encObj.globalMove(SE3([x,y,0, gR+[0,0,pi/2-th]]));
    
    % dot position
    dotObj.resetFrame
    x = l*sin(th) - .125*massSide*(cos(psi+e)*sin(th)+sin(psi+e)*cos(th));
    y = l*cos(th) - .125*massSide*(cos(psi+e)*cos(th)-sin(psi+e)*sin(th));
    dotObj.globalMove(SE3([x,y,0, gR+[0,0,pi/2-th]]));
 
    
%     %Actuator Mass
%     motorObj.resetFrame
%     motorObj.globalMove(SE3([0, motorX+massSide/2, 0, gR]));
%     
%     
%     %Rack Mass
%     rackObj.resetFrame
%     if(motorX > rackLen)
%         rackObj.globalMove(SE3([0,-rackLen/2+motorX+.1*massSide/2, 0, gR]));
%     else
%         rackObj.globalMove(SE3([0,rackLen/2+.1*massSide/2, 0, gR]));
%     end
    
    % Update data
    armObj.updatePlotData
    encObj.updatePlotData
    dotObj.updatePlotData


    % Draw figure
    drawnow
    
end % for it = ...

end % RobotAnimation
