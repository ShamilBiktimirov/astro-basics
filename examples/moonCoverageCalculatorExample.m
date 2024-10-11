clear all;

simulation.initialEpochGd = datetime('today');
simulation.initialEpochJd = juliandate(simulation.initialEpochGd);
simulation.runTime        = Consts.day2sec; % s
simulation.timeStep       = 60; % s


%% Constructing grid of points on the Moon surface
% The points are given wrt Moon body-fixed rotating frame (PA frame)
gridResolution = 100e3; % m
[latArray, lonArray] = calcUniformGridLatLon(gridResolution, 'rSphere', Consts.rMoonEquatorial);

moonGrid(1, :) = Consts.rMoonEquatorial * cos(latArray) .* cos(lonArray);
moonGrid(2, :) = Consts.rMoonEquatorial * cos(latArray) .* sin(lonArray);
moonGrid(3, :) = Consts.rMoonEquatorial * sin(latArray);

%% Defining Walker Constellation, T/P/f - total sat number, plane number, phasing parameter
T = 100; 
P = 10;
f = 1;

% sma, inclination
a = Consts.rMoonEquatorial + 1000e3;
inc = deg2rad(70);
walkerType = 'delta';

%% Defining mean orbital elements sets for all constellation satellites
oeArray = walkerConstellation(T, P, f, a, inc, walkerType);
oeArray = oeArray';
rvArray0 = [];

%% Transforming oe state to cartesian state
for satIdx = 1:size(oeArray, 2)
    rvArray0 = [rvArray0; oe2rv(oeArray(:, satIdx), 'planetGp', Consts.muMoon)];
end


%% integrating equations of motion for all constellation satellites simultaneously

options= odeset('RelTol',1e-8,'AbsTol',1e-8);
tSpan = [0 simulation.runTime]; % propagation time array
[tArray, rvArray] = ode45(@(t, rv) rhsMultipleSatsInertial(t, rv, 'point mass'), tSpan, rvArray0, options);
rvArray = rvArray';

%% Calcuting access conditions between constellation satellites and grid nodes
% limiting central angle for access condition based on min elevation requirement for observation
elevationMin = deg2rad(30);
centralAngle = calcBetaAngleGivenElevation(a, elevationMin);

numberOfVisibleSatsArray = [];

tic;
f = waitbar(0, 'Coverage Calculation in Progress');

for timeIdx = 1:length(tArray)

    rvArrayReshaped = reshape(rvArray(:, timeIdx), [6, T]);

    dcmPa2I = transformationMatrixPa2I(simulation.initialEpochJd + tArray(timeIdx) / Consts.day2sec);
    rArrayTransformed = dcmPa2I' * rvArrayReshaped(1:3, :); % transform position from Inertial to Body-fixed frame

    numberOfVisibleSatsArray = [numberOfVisibleSatsArray, calcAccessConditions(rArrayTransformed, moonGrid, centralAngle)];
    waitbar(timeIdx / length(tArray), f, 'Coverage Calculation in Progress');

end
toc;

statistics.nSatMin     = min(numberOfVisibleSatsArray, [],  2);
statistics.nSatAverage = mean(numberOfVisibleSatsArray, 2);
statistics.nSatMax     = max(numberOfVisibleSatsArray, [],  2);

%% Visualization

% Instant Coverage
figure();
plotMoonMeters();
plot3(moonGrid(1, :), moonGrid(2, :), moonGrid(3, :), 'ok');

rvSatCurrentIdx = 1:6;
for satIdx = 1:(T-1)

    plot3(rvArray(rvSatCurrentIdx(1), :), rvArray(rvSatCurrentIdx(2), :), rvArray(rvSatCurrentIdx(3), :), '-g');
    plot3(rvArray(rvSatCurrentIdx(1), 1), rvArray(rvSatCurrentIdx(2), 1), rvArray(rvSatCurrentIdx(3), 1), 'ob');

    rvSatCurrentIdx = rvSatCurrentIdx + 6;

end

timeIdx = 1;
% plotting zones having 4-fold coverage
plot3(moonGrid(1, numberOfVisibleSatsArray(:, timeIdx) >= 4), moonGrid(2, numberOfVisibleSatsArray(:, timeIdx) >= 4), moonGrid(3, numberOfVisibleSatsArray(:, timeIdx) >= 4), 'or');

% General statisitcs
figure;
hold on;
plot(latArray * 180 / pi, statistics.nSatMin, 'o', 'LineWidth', 2);
plot(latArray * 180 / pi, statistics.nSatAverage, 'o', 'LineWidth', 2);
plot(latArray * 180 / pi, statistics.nSatMax, 'o', 'LineWidth', 2);
xlabel('node latitude, deg');
ylabel('Number of visible satellites');
legend('minimum number of accessible satellites', ...
       'average number of accessible satellites', ...
       'maximum number of accessible satellites');
title('24 hours Moon Coverage Simulation');
xlim([-90, 90]);
xticks([-90:15:90])
fontsize(24, "points");
grid on;

%% Functions

function numberOfVisibleSatsArray = calcAccessConditions(rSat, rPOI, centralAngle)

    % Function finds a set of nodes on the Moon located within the area bounded by the centralAngle

    % Input:
    % - rSat [3, n], an array of satellite position vectors
    % - rPOI [3, m], an array of position vectors for points of interest (POI)
    % - centralAngle, rad, included angle for circular FOV coverage check

    % Output:
    % numberOfVisibleSatsArray [m, 1] - array of number of visible satellites for i-th moon grid nodes

    ePoiArray  = rPOI ./ vecnorm(rPOI);

    eSat = rSat ./ repmat(vecnorm(rSat, 2, 1), [3, 1]);
    eSat = reshape(eSat, [size(eSat, 1), 1, size(eSat, 2)]);

    ePoiArray3D = repmat(ePoiArray, [1, 1, size(eSat, 3)]);
    eSatArray3D = repmat(eSat, [1, size(rPOI, 2), 1]);

    % geometrical condition for coverage considering circular nadir pointing instrument cone
    Cmatrix = squeeze(dot(ePoiArray3D, eSatArray3D, 1)) >= cos(centralAngle);

    numberOfVisibleSatsArray = sum(Cmatrix, 2);

end

function rvPrime = rhsMultipleSatsInertial(t, rv, environment)

    % rhs for N satellites orbital motion dynamics in Moon-centered Inertial reference frame 

    % input:
    % rv            [nSats * 6, 1], [m, m/s]

    % Orbital motion dynamics models:
    % 'point mass'                  - motion in central gravity field of Luna

    nSats  = length(rv) / 6;
    rv     = reshape(rv, [6, nSats]);

    rPrime = [rv(4:6, :); zeros(3, nSats)];
    rNorm  = vecnorm(rv(1:3, :));

    % Central gravity field
    accelerationCg = [zeros(3, nSats); -Consts.muMoon ./ (rNorm.^3) .* rv(1:3, :)];

    % rhs for two-body problem
    rvPrime = rPrime + accelerationCg;

    switch environment
        case 'point mass'

            perturbations = zeros(6, nSats);

    end

    rvPrime = reshape(rvPrime + perturbations, [6 * nSats, 1]);

end

function dcmPa2I = transformationMatrixPa2I(julianDate)

    % Three Euler angles - precession, nutation, and self rotation
    % Solution approximated by polynom, better to move to DE430 ephemerides later
    [rasc_pole, decl_pole, rasc_pm] = moon_angles(julianDate);

    % 3-1-3 Euler Angles, intrinsic rotations
    dcmPa2I = rotationZ(rasc_pole) * rotationX(decl_pole) * rotationZ(rasc_pm);

    % Matrix notation: r_PA = dcmPa2I * r_I

end
