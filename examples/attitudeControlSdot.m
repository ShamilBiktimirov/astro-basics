clear all;

% A prototype of sDot control
% what if it goes opposite to r direction? add repulsive potential to that direction?

%% satellite parameters
% A parallelepiped shape satellite with uniform mass distribution is considered
% Aka 12U Cubesat
m = 10; % satellite mass, kg
l1 = 0.2; % satellite length, m
l2 = 0.2; % satellite width, m
l3 = 0.34; % satellite height, m

A = m * l3^2 / 12 + m * l2^2 / 12; % Jxx, kg*m^2
B = m * l3^2 / 12 + m * l1^2 / 12; % Jyy, kg*m^2
C = 1 / 12 * m * l1^2 + 1 / 12 * m * l2^2; % Jzz, kg*m^2
J = diag([A, B, C]); % satellite inertia tensor

% initial conditions for angular motion
q0_I = [1/sqrt(2); 0; 0; 1/sqrt(2)]; % unit quaternion q represents body orientation in inertial reference frame, rad
omega0_I = [0; 0.1; 0.1]; % Initial angular velocity of the satellite given in inertial frame, rad/s
omega0_B = rotateI2B(omega0_I, q0_I); % Initial angular velocity of the satellite given in body-fixed frame, rad/s

% initial conditions for angular motion

X0 = [q0_I; omega0_B]; % state vector for rotational motion dynamics

simulation.controlLoop = 0.1; % s
simulation.timeStep   = 0.1; % 2
simulation.simulationTime = 100; % s

tCounter = 0;
optionsPrecision = odeset('RelTol',1e-5,'AbsTol',1e-5);
XArray = [];
tArray = [];
M_B = [0; 0; 0];

[verticesPositionsArray, linksArray] = calcParallelepidedVecticesPositions([l1; l2; l3]);
xVertices = verticesPositionsArray(1, :);
yVertices = verticesPositionsArray(2, :);
zVertices = verticesPositionsArray(3, :);

figure;
axis equal;
axis off;
hold on;
axisLength = (l1 + l2 + l3) / 3;
x = [[0;0;0],[1; 0; 0]] * axisLength;
y = [[0;0;0],[0; 1; 0]] * axisLength;
z = [[0;0;0],[0; 0; 1]] * axisLength;
plot3(x(1,:), x(2,:), x(3,:), 'r', LineWidth=2);
plot3(y(1,:), y(2,:), y(3,:), 'g', LineWidth=2);
plot3(z(1,:), z(2,:), z(3,:), 'b', LineWidth=2);
axis([-axisLength*1.5 axisLength*1.5 -axisLength*1.5 axisLength*1.5 -axisLength*1.5 axisLength*1.5]);

view(135, 30);

% simulation loop with control input calculation
while tCounter < simulation.simulationTime

    tSpan = tCounter + [0 : simulation.timeStep : simulation.controlLoop]; % s
    [tArrayLocal, XArrayLocal] = ode45(@(t, X) rhsAngularMotionDynamics(t, X, J, M_B), tSpan, X0, optionsPrecision);

    tArray = [tArray; tArrayLocal];
    XArrayLocal = XArrayLocal';
    XArray = [XArray, XArrayLocal];

    tCounter = tArray(end);
    X0 = XArray(:, end);

    M_B = calcControlTorqueSDot([1; 0; 0], [1; 0; 0], XArray(:, end));


    eXTransformed = rotateB2I(x(:, 2), XArray(1:4, end));
    eYTransformed = rotateB2I(y(:, 2), XArray(1:4, end));
    eZTransformed = rotateB2I(z(:, 2), XArray(1:4, end));

    for vertixIdx = 1:size(verticesPositionsArray, 2)

       verticesPositionsTransformedArray(:,vertixIdx) = rotateB2I(verticesPositionsArray(:, vertixIdx), XArray(1:4, end));

    end

    bodyFrameX = plot3([0, eXTransformed(1)], [0, eXTransformed(2)], [0, eXTransformed(3)], 'r', LineWidth=2);
    bodyFrameY = plot3([0, eYTransformed(1)], [0, eYTransformed(2)], [0, eYTransformed(3)], 'g', LineWidth=2);
    bodyFrameZ = plot3([0, eZTransformed(1)], [0, eZTransformed(2)], [0, eZTransformed(3)], 'b', LineWidth=2);

    xVertices = verticesPositionsTransformedArray(1, :);
    yVertices = verticesPositionsTransformedArray(2, :);
    zVertices = verticesPositionsTransformedArray(3, :);
    satLocal = patch(xVertices(linksArray), yVertices(linksArray), zVertices(linksArray), 'k', 'facealpha', 0.1);

    drawnow;
    if tCounter < simulation.simulationTime
        delete(bodyFrameX);
        delete(bodyFrameY);
        delete(bodyFrameZ);
        delete(satLocal);
    end

end

% visualization 
rotationAnimationGif([l1; l2; l3], XArray(1:4, 1:30:end), repmat([1;0;0], 1, size(XArray, 2)));


%% Functions
function M = calcControlTorqueSDot(eTarget, rSat_B, AngularStateVector)

    % eTarget - unit direction vector for a satellite axis pointing

    Mmax = 0.001; % ? depends on RW torque

    cAngle = 0.025;
    cAngularVelocity = 0.1;

    q = AngularStateVector(1:4);
    angularVelocity_B = AngularStateVector(5:7);

    eTarget_B = rotateI2B(eTarget, q);

    % difference in angle
    torqueDirection = cross(rSat_B, eTarget_B) / vecnorm(cross(rSat_B, eTarget_B));
    alpha = acos(dot(rSat_B, eTarget_B) / vecnorm(rSat_B) / vecnorm(eTarget_B));

    M = cAngle * torqueDirection * alpha - cAngularVelocity * angularVelocity_B;

    if vecnorm(M) > Mmax
        M = M / vecnorm(M) * Mmax;
    end

end
