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
oe(3)        = calcSsoOrbitInclination(oe(1), oe(2)); % inclination, rad
oe(4)        = 0; % RAAN for terminator oriented orbit
oe(5)        = 0; % AOP, deg
oe(6)        = 0; % M, deg - actually argument of latitude

rvInertial        = oe2rv(oe, 'planetGp', Consts.muEarth);

orbitPeriod = 2 * pi * sqrt(oe(1)^3 / Consts.muEarth);

angularState = [1; 0; 0; 0; 0.001; 0.1; 0.002]; % [q; w]

stateVectorInitial = [rvInertial; angularState];

%% Simulation parameters
T_simulation = orbitPeriod;

t = 0;
tArray = [];
timeCounter = 1;

controlVector = [];
angles = [];
stateVectorArray = stateVectorInitial;
chargingPower = [];
controlTorqueArray = [];

options = odeset('RelTol',1e-7,'AbsTol',1e-7);
tic;
[tArrayLocal, stateVectorArrayLocal] = ode45(@(t, stateVector) ...
             rhsOrbitalAngular(t, stateVector, [0;0;0], spacecraft, Consts.muEarth, Consts.rEarth), [0:T_simulation], stateVectorArray(:, end), options);
toc;
stateVectorArrayLocal = stateVectorArrayLocal';

fig1 = figure;
hold on

subplot(2, 4, [2 3])
plot3(stateVectorArrayLocal(1, :), stateVectorArrayLocal(2, :), stateVectorArrayLocal(3, :));
xlabel("X, m")
ylabel("Y, m")
zlabel("Z, m")
fontsize(20,"points")
grid on

subplot(2, 4, [5 6])
hold on
plot(tArrayLocal, stateVectorArrayLocal(4, :));
plot(tArrayLocal, stateVectorArrayLocal(5, :));
plot(tArrayLocal, stateVectorArrayLocal(6, :));
plot(tArrayLocal, stateVectorArrayLocal(7, :));
xlabel("t, s")
ylabel("q")
legend('q0', 'q1', 'q2', 'q3')
fontsize(20,"points")
grid on 

subplot(2, 4, [7 8])
hold on
plot(tArrayLocal, stateVectorArrayLocal(8, :));
plot(tArrayLocal, stateVectorArrayLocal(9, :));
plot(tArrayLocal, stateVectorArrayLocal(10, :));
xlabel("t, s")
ylabel("w, rad/s")
legend('wx', 'wy', 'wz')
fontsize(20,"points")
grid on 