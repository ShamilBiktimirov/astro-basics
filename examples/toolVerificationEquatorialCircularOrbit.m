
% This script shows the Tool validation example for an equatorial-circular orbit

clear all
clc
close all


a = Consts.rEarth + 550e3; % orbit sma, m
inc = 1e-6 * pi / 180; 
oeArray = [a, 0, inc, 0, 0, 0]; % [a, e, incl, Raan, AOP, MeanAnomaly]

rvEciInitial = oe2rv(oeArray);

% Spacecraft parameters
spacecraft.instrumentFov = 20 * pi / 180; % [rad], halg beam angle
spacecraft.elevationMin = 10 * pi / 180;  % [rad], critical minimum elevation


[spacecraft.betaAa, spacecraft.betaBeam] = calcBetaAngles(a, spacecraft);

oeMeaniInit = meanOscMapping(oeArray, 'osc2mean');

% Initial epoch
epochGD = datetime(2023, 9, 5, 0, 0, 0);
epochJD = juliandate(epochGD);
epochGMST = JD2GMST(epochJD);

% finds JD that will make ECEF frame coincide with ECI frame at t0
deltaTheta = 360 - epochGMST;
deltaTime = deg2rad(deltaTheta) / Consts.omegaEarth;

newEpoch = epochJD + deltaTime / Consts.day2sec;
% thetaCheck = JD2GMST(newEpoch);

T = 2*pi*sqrt(a^3/ Consts.muEarth); % orbit period
tArray = 0 : 0.01 : T;

tArrayJd = newEpoch + tArray / Consts.day2sec; % array of julian dates

rvEcefArray = propJ2AnalyticalCircECEF(oeMeaniInit, newEpoch, tArrayJd);

point = [1; -2; 0];
pointN = point/ norm(point);
coveredPoints = calcCoveredPoints(rvEcefArray(1:3, :), point, spacecraft.betaBeam);

[timeRow, ~] = find(coveredPoints);
responseTime = tArray(timeRow(1));
responseTimeHours = responseTime / 60 / 60;

theta0 = acos(dot(pointN, rvEcefArray(1:3, 1)/ norm(rvEcefArray(1:3, 1))));
rSatCrossRPoi = cross(rvEcefArray(1:3, 1)/ norm(rvEcefArray(1:3, 1)), pointN);

signrSatCrossRPoi = sign(rSatCrossRPoi(3));

if signrSatCrossRPoi < 0
    theta0 = 2 * pi - theta0;
end

analyticalResponseTime = (theta0 - spacecraft.betaBeam) * (1/((2 * pi/ T) - Consts.omegaEarth));
