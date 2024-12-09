clear all;

%% Defining Walker Constellation, T/P/f - total sat number, plane number, phasing parameter
T = 24; 
P = 6;
f = 1;

% sma, inclination
a = Consts.rMoonEquatorial + 1000e3;
inc = deg2rad(70);
walkerType = 'delta';

orbitPeriod = calcPeriodKeplerian(a);

%% Defining mean orbital elements sets for all constellation satellites
oeArray = walkerConstellation(T, P, f, a, inc, walkerType);
oeArray = oeArray';
rvArray0 = [];

%% Constructing grid of points on the Moon surface
% The points are given wrt Moon body-fixed rotating frame (PA frame)
gridResolution = 100e3; % m
[latArray, lonArray] = calcUniformGridLatLon(gridResolution, 'rSphere', Consts.rMoonEquatorial);

moonGrid(1, :) = Consts.rMoonEquatorial * cos(latArray) .* cos(lonArray);
moonGrid(2, :) = Consts.rMoonEquatorial * cos(latArray) .* sin(lonArray);
moonGrid(3, :) = Consts.rMoonEquatorial * sin(latArray);
nGridPoints = size(moonGrid, 2);

%% Simulation parameters
simulation.initialEpochGd = datetime('today');
simulation.initialEpochJd = juliandate(simulation.initialEpochGd);
simulation.runTime        = orbitPeriod; % s
simulation.timeStep       = 500; % s



%% Transforming oe state to cartesian state
for satIdx = 1:size(oeArray, 2)
    rvArray0 = [rvArray0; oe2rv(oeArray(:, satIdx), 'planetGp', Consts.muMoon)];
end

%% integrating equations of motion for all constellation satellites simultaneously

% can be replaces with mean oe dynamics
options= odeset('RelTol',1e-8,'AbsTol',1e-8);
tSpan = [0 simulation.runTime]; % propagation time array
[tArray, rvArray] = ode45(@(t, rv) rhsMultipleSatsInertial(t, rv, 'point mass'), tSpan, rvArray0, options);
rvArray = rvArray';

%% Calcuting access conditions between constellation satellites and grid nodes
% limiting central angle for access condition based on min elevation requirement for observation

elevationMin = deg2rad(10); % this is discussable, see refs
centralAngle = calcBetaAngleGivenElevation(a, elevationMin);

numberOfVisibleSatsArray = [];

tic;
f = waitbar(0, 'Coverage Calculation in Progress');

GDOParray = [];
% PDOParray = [];
% HDOParray = [];
% VDOParray = [];
% TDOParray = [];

% fully vectorized routine for each time step
tic;
for timeIdx = 1:length(tArray)

    rvArrayReshaped = reshape(rvArray(:, timeIdx), [6, T]);

    dcmPa2I = transformationMatrixPa2I(simulation.initialEpochJd + tArray(timeIdx) / Consts.day2sec);
    rArrayTransformed = dcmPa2I' * rvArrayReshaped(1:3, :); % transform position from Inertial to Body-fixed frame

    [numberOfVisibleSatsArrayLocal, ~, Hmatrix3d] = calcAccessConditionsUsingElevation(rArrayTransformed, moonGrid, elevationMin);
    numberOfVisibleSatsArray = [numberOfVisibleSatsArray, numberOfVisibleSatsArrayLocal];
    
    if all(numberOfVisibleSatsArray >= 4)
        Dmatrix = pageinv(pagemtimes(permute(Hmatrix3d, [1, 3, 2]), permute(Hmatrix3d, [3, 1, 2])));
        GDOParray = [GDOParray, squeeze(sqrt(Dmatrix(1, 1, :) + Dmatrix(2, 2, :) + Dmatrix(3, 3, :) + Dmatrix(4, 4, :)))];
    else
        GDOParray = [GDOParray, nan(nGridPoints, 1)];
    end
    waitbar(timeIdx / length(tArray), f, 'Coverage Calculation in Progress');

    numberOfVisibleSatsArrayLocal = [];
    Hmatrix3d = [];

end
close(f);
toc;

statistics.nSatMin     = min(numberOfVisibleSatsArray, [],  2);
statistics.nSatAverage = mean(numberOfVisibleSatsArray, 2);
statistics.nSatMax     = max(numberOfVisibleSatsArray, [],  2);

%% Visualization

% Instant Coverage
figure();
hold on;
plotMoonMeters();
plot3(moonGrid(1, :), moonGrid(2, :), moonGrid(3, :), 'ok', 'MarkerSize', 4, 'MarkerFaceColor', 'k');
axis equal;

rvSatCurrentIdx = 1:6;
for satIdx = 1:(T-1)

    plot3(rvArray(rvSatCurrentIdx(1), :), rvArray(rvSatCurrentIdx(2), :), rvArray(rvSatCurrentIdx(3), :), '-k');
    plot3(rvArray(rvSatCurrentIdx(1), 1), rvArray(rvSatCurrentIdx(2), 1), rvArray(rvSatCurrentIdx(3), 1), 'ok', 'MarkerSize', 10, 'MarkerFaceColor', 'k');

    rvSatCurrentIdx = rvSatCurrentIdx + 6;

end

timeIdx = 1;
% plotting zones having 4-fold coverage
% plot3(moonGrid(1, numberOfVisibleSatsArray(:, timeIdx) >= 4), moonGrid(2, numberOfVisibleSatsArray(:, timeIdx) >= 4), moonGrid(3, numberOfVisibleSatsArray(:, timeIdx) >= 4), 'og');

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

function [numberOfVisibleSatsArray, Cmatrix, Hmatrix3d] = calcAccessConditionsUsingElevation(rSat, rPOI, elevationMin)

    % Function finds a set of nodes on the Moon located within the area bounded by the minimum elevation

    % Input:
    % - rSat [3, n], an array of satellite position vectors
    % - rPOI [3, m], an array of position vectors for points of interest (POI)
    % - elevationMin, rad, minimum elevation for observations

    % Output:
    % numberOfVisibleSatsArray [m, 1] - array of number of visible satellites for i-th moon grid nodes
    % Cmatrix [m, n] - logical array of access conditions
    % Hmatrix3d - H matrix for nPoi, 4 x nPoi x nSat

    nSats = size(rSat, 2);
    nPois = size(rPOI, 2);

    rSat = reshape(rSat, [3, 1, nSats]);
    rSatArray3D = repmat(rSat, [1, nPois, 1]);

    rPoiArray3D = repmat(rPOI, [1, 1, nSats]);

    rPoi2Sat3D = rSatArray3D - rPoiArray3D;
    ePoi2Sat3D = normalize(rPoi2Sat3D, 1, "norm"); % 3d matrix for elevation and Hmatrix3d computation

    ePoiArray  = rPOI ./ vecnorm(rPOI);
    ePoiArray3D = repmat(ePoiArray, [1, 1, nSats]); % 3d matrix for elevation computation

    % geometrical condition for coverage considering circular nadir pointing instrument cone
    Cmatrix = squeeze(dot(ePoiArray3D, ePoi2Sat3D, 1)) >= cos(pi/2 - elevationMin); % logical matrix for sat 2 poi observation conditions
    numberOfVisibleSatsArray = sum(Cmatrix, 2); % array of number of satellite seen in i-th point of interest

    if all(numberOfVisibleSatsArray >= 4)

        % calculates H matrix 3D
        ePoi2Sat3dSparse = ePoi2Sat3D;
        ePoi2Sat3dSparse(:, ~Cmatrix) = repmat([0; 0; 0], [1, length(find(~Cmatrix))]); % nullyfying unit satellite direction for non-visible satellites

        Hmatrix3d = ePoi2Sat3dSparse;
        Hmatrix3d(4, :, :) = ones(1, nPois, nSats); % adding ones as a fourth element in each satellite unit direction vector
        Hmatrix3d(4, ~Cmatrix) = zeros(1, length(find(~Cmatrix))); % removing one for non-visible satellite

    else

        Hmatrix3d = []; % is a point is not visible by at least 4 satellites
 
    end

end

function [numberOfVisibleSatsArray, Cmatrix] = calcAccessConditionsCentralAngle(rSat, rPOI, centralAngle)

    % Function finds a set of nodes on the Moon located within the area bounded by the centralAngle

    % Input:
    % - rSat [3, n], an array of satellite position vectors
    % - rPOI [3, m], an array of position vectors for points of interest (POI)
    % - centralAngle, rad, included angle for circular FOV coverage check

    % Output:
    % numberOfVisibleSatsArray [m, 1] - array of number of visible satellites for i-th moon grid nodes
    % Cmatrix [m, n] - logical array of access conditions

    ePoiArray  = rPOI ./ vecnorm(rPOI);

    eSat = rSat ./ repmat(vecnorm(rSat, 2, 1), [3, 1]);
    eSat = reshape(eSat, [size(eSat, 1), 1, size(eSat, 2)]);

    ePoiArray3D = repmat(ePoiArray, [1, 1, size(eSat, 3)]);
    eSatArray3D = repmat(eSat, [1, size(rPOI, 2), 1]);

    % geometrical condition for coverage considering circular nadir pointing instrument cone
    Cmatrix = squeeze(dot(ePoiArray3D, eSatArray3D, 1)) >= cos(centralAngle);
    % switch to elevation based and return unit relative position vector directly without further calculations
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
