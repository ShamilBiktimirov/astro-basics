clear all

% this example is to simulate low thrust trajectory vs hohmann

global environment

environment = 'point mass';

%% initial and final orbit
rCirc300 = Consts.rEarth + 300e3;
vCric300 = sqrt(Consts.muEarth / rCirc300);


rCircH = Consts.rEarth + 700e3;
vCricH = sqrt(Consts.muEarth / rCircH);

rv0 = [rCircH; 0; 0; 0; vCricH; 0];

%% other simulation parameters
thrust = 0.055e-3; %N
thrust = 1e-3; %N

mass = 1000; % kg
simulation.simulationTime = 10 * 60 * 60; % sec
simulation.timeStep = 1;
simulation.controlLoop = 60;
spacecraft = [];
tArray = [];
XArray = [];

X0 = rv0;

currentMass = mass;
optionsPrecision = odeset('RelTol', 1e-8, 'AbsTol', 1e-10);
lowthustDV = [];

%% low trust loop
for tCounter = 1 : simulation.simulationTime

    controlVector = -(thrust / currentMass) * (X0(4:6) / norm(X0(4:6)));

    tSpan = tCounter + [0 : simulation.timeStep : simulation.controlLoop]; % s
    [tArrayLocal, XArrayLocal] = ode45(@(t, X) rhsFormationInertial(t, X, controlVector,spacecraft), tSpan, X0, optionsPrecision);
    
    tArray = [tArray; tArrayLocal];
    XArrayLocal = XArrayLocal';
    XArray = [XArray, XArrayLocal];

    % check sma
    oeArray(:, tCounter) = rv2oe(X0);

    if oeArray(:, tCounter) <  rCirc300
        lowthustDV = thrust / currentMass * tCounter;
        break
      
    end
    currentaltitude = oeArray(1, tCounter) -  Consts.rEarth

    tCounter = tArray(end);
    X0 = XArray(:, end);

end


%% use hohmann transfer to approx the required deltaV from h to 300 km
% transfer orbit sma
smaT = (rCircH + rCirc300)  / 2;

vApo = sqrt(Consts.muEarth *((2 / rCircH) - (1 / smaT)));
vperi = sqrt(Consts.muEarth *((2 / rCirc300) - (1 / smaT)));

dv1 = abs(vApo - vCricH);
dv2 = abs(vperi - vCric300);

totalDVHohmann = dv1 + dv2;
