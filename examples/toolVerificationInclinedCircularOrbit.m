
%%% This script shows the Tool validation example for an inclined-circular orbit

clear all
clc
% close all


a = Consts.rEarth + 550e3; % orbit sma, m
inc = 40 * pi / 180; 
oeArray = [a, 0, inc, 0, 0, 0]; % [a, e, incl, Raan, AOP, MeanAnomaly]

rvEciInitial = oe2rv(oeArray);

% Spacecraft parameters
spacecraft.instrumentFov = 20 * pi / 180; % [rad], halg beam angle
spacecraft.elevationMin = 10 * pi / 180;  % [rad], critical minimum elevation


[spacecraft.betaAa, spacecraft.betaBeam] = calcBetaAngles(a, spacecraft);

oeMeaniInit = meanOscMapping(oeArray, 'osc2mean');

% Initial epoch and required moments
epochGD = datetime(2023, 9, 5, 0, 0, 0);
epochJD = juliandate(epochGD);
epochGMST = JD2GMST(epochJD);

deltaTheta = 360 - epochGMST;
deltaTime = deg2rad(deltaTheta) / Consts.omegaEarth;

newEpoch = epochJD + deltaTime / Consts.day2sec;
% thetaCheck = JD2GMST(newEpoch)

T = 2 * pi * sqrt(a ^ 3 / Consts.muEarth);
tArray = 0:0.01:T;

tArrayJd = newEpoch + tArray / Consts.day2sec; % array of julian dates


rvEcefArray = propJ2AnalyticalCircECEF(oeMeaniInit, newEpoch, tArrayJd);

c = 3 / 2 * sqrt(Consts.muEarth) * Consts.rEarthEquatorial ^ 2 * Consts.earthJ2;
eMean = oeMeaniInit(2);
aMean = oeMeaniInit(1);
iMean = oeMeaniInit(3);
raanSecularPrecessionRate = - c / ((1 - eMean^2) ^ 2 * aMean ^ (7 / 2)) * cos(iMean);

theta = (Consts.omegaEarth + raanSecularPrecessionRate) * (pi - spacecraft.betaBeam) * T / (2 * pi);

point = [-0.8; 0; 0];
pointN = rotz(theta * 180/pi)' * point;
coveredPoints = calcCoveredPoints(rvEcefArray(1:3, :), pointN, spacecraft.betaBeam);

[timeRow, ~] = find(coveredPoints);
responseTime = tArray(timeRow(1));
responseTimeHours = responseTime / 60 / 60;



timeCheck = (pi - spacecraft.betaBeam) * (1/((2 * pi/ T) ));
