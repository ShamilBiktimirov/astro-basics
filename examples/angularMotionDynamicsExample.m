clear all;

% The script examples translational and rotational motion dynamics

%% Spacecrarft parameters
% general parameters
spacecraft.mass            = 10;   % [kg]
% cylindrical shape is considered of height h and radius r - axisymmetric body
spacecraft.height          = 300e-3; % [m]
spacecraft.radius          = 150e-3; % [m]
spacecraft.inertiaTensor   = diag([1 / 12 * spacecraft.mass * spacecraft.height^2 + 1 / 4 * spacecraft.mass * spacecraft.radius ^ 2; ...
                                   1 / 12 * spacecraft.mass * spacecraft.height^2 + 1 / 4 * spacecraft.mass * spacecraft.radius ^ 2; ...
                                   1 / 2 * spacecraft.mass * spacecraft.radius ^ 2]); % given in central principal axes

%% Spacecrarft orbit

oe           = zeros(6, 1);
oe(1)        = Consts.rEarth + 600e3; % orbit sma, m
oe(2)        = 0; % ecc
oe(3)        = pi/2; % inclination, rad
oe(4)        = pi/2; % RAAN for terminator oriented orbit
oe(5)        = 0; % AOP, deg
oe(6)        = 0; % M, deg - actually argument of latitude

rvInertial        = oe2rv(oe, 'planetGp', Consts.muEarth);

orbitPeriod = 2 * pi * sqrt(oe(1)^3 / Consts.muEarth);

qIB = [cos(pi/4); 0; 0; sin(pi/4)]; % rotation along z-axis of inertial frame
omegaI = [deg2rad(1); 0; 0]; % angular velocity along x axis of intertial frame
omegaB = rotateI2B(omegaI, qIB);

angularState = [qIB; omegaB]; % [q; w]
stateVectorInitial = [rvInertial; angularState];

%% Simulation parameters
T_simulation = orbitPeriod;

t = 0;
tArray = [];

controlVector = [];
angles = [];
stateVectorArray = stateVectorInitial;
chargingPower = [];
controlTorqueArray = [];

options = odeset('RelTol',1e-10,'AbsTol',1e-10);
tic;
[tArrayLocal, stateVectorArrayLocal] = ode45(@(t, stateVector) ...
             rhsOrbitalAngularLander(t, stateVector, [0;0;0], spacecraft, Consts.muEarth), [0:T_simulation], stateVectorArray(:, end), options);
toc;
stateVectorArrayLocal = stateVectorArrayLocal';

% visualization
[verticesPositionsBArray, linksArray] = calcParallelepidedVecticesPositions([150e-3, 150e-3, 300e-3]);

% patch('Vertices', verticesPositionsBArray', ...
%         'Faces', linksArray, ...
%         'FaceColor', [0.5 0.5 0.5], ...
%         'EdgeColor', [0.2 0.2 0.2], ...
%         'EdgeAlpha', 0.15);
% axis equal;

bodyFixedAxesB = eye(3) / 2;

for timeIdx = 1:length(tArrayLocal)

    omegaI(:, timeIdx) = rotateB2I(stateVectorArrayLocal(11:13, timeIdx), stateVectorArrayLocal(7:10, timeIdx));

end

figure;
hold on;
plot(tArrayLocal, omegaI(1, :), 'r');
plot(tArrayLocal, omegaI(2, :), 'g');
plot(tArrayLocal, omegaI(3, :), 'b');



fig1 = figure;
hold on;

for timeIdx = 1:length(tArrayLocal)

    subplot(2, 2, [1 3]);
    plotEarth();
    plot3(stateVectorArrayLocal(1, timeIdx), stateVectorArrayLocal(2, timeIdx), stateVectorArrayLocal(3, timeIdx), 'or', 'MarkerSize', 5);
    xlabel("X, m")
    ylabel("Y, m")
    zlabel("Z, m")
    fontsize(14,"points");
    grid on;

    subplot(2, 2, [2 4]);
    view([1, 1, 1]);
    axis off;
    hold on;
    pltX = plot3([0, 1/2], [0, 0], [0, 0], 'r', 'LineWidth', 2);
    pltY = plot3([0, 0], [0, 1/2], [0, 0], 'g', 'LineWidth', 2);
    pltZ = plot3([0, 0], [0, 0], [0, 1/2], 'b', 'LineWidth', 2);

    dcm = quat2dcm(stateVectorArrayLocal(7:10, timeIdx)');
    dcm = dcm';
    verticesPositionsIArray = dcm * verticesPositionsBArray;
    bodyFixedAxesI = dcm * bodyFixedAxesB;

    pltX = plot3([0, bodyFixedAxesI(1, 1)], [0, bodyFixedAxesI(2, 1)], [0, bodyFixedAxesI(3, 1)], '--r', 'LineWidth', 2);
    pltY = plot3([0, bodyFixedAxesI(1, 2)], [0, bodyFixedAxesI(2, 2)], [0, bodyFixedAxesI(3, 2)], '--g', 'LineWidth', 2);
    pltZ = plot3([0, bodyFixedAxesI(1, 3)], [0, bodyFixedAxesI(2, 3)], [0, bodyFixedAxesI(3, 3)], '--b', 'LineWidth', 2);

    pltSat = patch('Vertices', verticesPositionsIArray', ...
        'Faces', linksArray, ...
        'FaceColor', [0.5 0.5 0.5], ...
        'EdgeColor', [0.2 0.2 0.2], ...
        'EdgeAlpha', 0.15);
    axis equal;

    pause(0.1);

    delete(pltSat);
    delete(pltX);
    delete(pltY);
    delete(pltZ);

end
