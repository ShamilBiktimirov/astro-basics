clear all;

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
q0 = [1; 0; 0; 0]; % unit quaternion q represents body orientation in inertial reference frame, rad
omega0_I = [0.3; 0.001; 0]; % Initial angular velocity of the satellite given in inertial frame, rad/s
omega0_B = rotateI2B(omega0_I, q0); % Initial angular velocity of the satellite given in body-fixed frame, rad/s

% initial conditions for angular motion

X_init = [q0; omega0_B]; % state vector for rotational motion dynamics

dt = [0:1:500]; % s
options_precision = odeset('RelTol',1e-5,'AbsTol',1e-5);
[t_vec, X_vec] = ode45(@(t, X) rhsAngularMotionDynamics(t, X, J, []), dt, X_init, options_precision);
X_vec = X_vec';

q_vec = X_vec(1:4,:);

% visualization
rotation_animation([l, w, h], q_vec);
