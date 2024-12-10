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

% Lander orbit

oe           = zeros(6, 1);
rA = 65e3;
rP = 33e3;
oe(1)        = (rA + rP) / 2; % orbit sma, m
oe(2)        = (rA - rP) / (rA + rP); % ecc
oe(3)        = 0; % inclination, rad
oe(4)        = 0; % RAAN for terminator oriented orbit
oe(5)        = 0; % AOP, deg
oe(6)        = 0; % M, deg - actually argument of latitude

rvInertial        = oe2rv(oe, 'planetGp', Consts.muJustitia);

orbitPeriod = 2 * pi * sqrt(oe(1)^3 / Consts.muJustitia);

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
             rhsOrbitalAngular(t, stateVector, [0;0;0], spacecraft, Consts.muJustitia), [0:T_simulation], stateVectorArray(:, end), options);
toc;
stateVectorArrayLocal = stateVectorArrayLocal';

plot3(stateVectorArrayLocal(1, :), stateVectorArrayLocal(2, :), stateVectorArrayLocal(3, :));