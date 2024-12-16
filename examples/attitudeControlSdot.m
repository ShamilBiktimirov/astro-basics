clear all;

% A prototype of sDot control
% what if it goes opposite to r direction? add repulsive potential to that direction?

%% satellite parameters
% A parallelepiped shape satellite with uniform mass distribution is considered
% Aka 12U Cubesat
m = 10; % satellite mass, kg
h = 0.34; % satellite height, m
l = 0.2; % satellite length, m
w = 0.2; % satellite width, m

A = m * h^2 / 12 + m * w^2 / 12; % Jxx, kg*m^2
B = m * h^2 / 12 + m * l^2 / 12; % Jyy, kg*m^2
C = 1 / 12 * m * l^2 + 1 / 12 * m * w^2; % Jzz, kg*m^2
J = diag([A, B, C]); % satellite inertia tensor

% initial conditions for angular motion
q0_I = [1/sqrt(2); 0; 0; 1/sqrt(2)]; % unit quaternion q represents body orientation in inertial reference frame, rad
omega0_I = [0.5; 1; 0.2]; % Initial angular velocity of the satellite given in inertial frame, rad/s
omega0_B = rotateI2B(omega0_I, q0_I); % Initial angular velocity of the satellite given in body-fixed frame, rad/s

% initial conditions for angular motion

X0 = [q0_I; omega0_B]; % state vector for rotational motion dynamics

simulation.controlLoop = 1; % s
simulation.timeStep   = 0.2; % 2
simulation.simulationTime = 100; % s

tCounter = 0;
optionsPrecision = odeset('RelTol',1e-5,'AbsTol',1e-5);
XArray = [];
tArray = [];
M_B = [0; 0; 0];

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

    % rotation_animation([l; w; h], XArrayLocal(1:4, :));

end

% visualization
rotation_animation([l, w, h], XArray(1:4, :));


%% Functions
function M = calcControlTorqueSDot(eTarget, rSat_B, AngularStateVector)
    
    % eTarget - unit direction vector for a satellite axis pointing

    Mmax = 0.01; % ? depends on RW torque

    cAngle = 0.025;
    cAngularVelocity = 0.1;

    q = AngularStateVector(1:4);
    angularVelocity_B = AngularStateVector(5:7);

    eTarget_B = rotateI2B(eTarget, q);

    % difference in angle
    torqueDirection = cross(rSat_B, eTarget_B) / vecnorm(cross(rSat_B, eTarget_B));
    alpha = acos(dot(rSat_B, eTarget_B) / vecnorm(rSat_B) / vecnorm(eTarget_B));

    % add a component for angular velocity
    % anglularVelocity_perp = cAngularVelocity* (angularVelocity_B - dot(angularVelocity_B, eTarget_B) * eTarget_B; % componenent of angular velocity perpendicular to target directions
    % proper projections!!!!

    M = cAngle * torqueDirection * alpha - cAngularVelocity * angularVelocity_B; % check if perpendicular do they coincide with alpha dir proj?
    
    if vecnorm(M) > Mmax
        M = M / vecnorm(M) * Mmax;
    end

end
