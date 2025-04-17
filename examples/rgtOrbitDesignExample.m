% The script demonstrates the way to design circular inclined RGT orbit and
% verify it graphically

clear all;

kDay2Rep = 2;
kRev2Rep = 29;

inclination = deg2rad(40);
[smaRGT, periodEarthNodal] = calcCircularRgtOrbitSma(inclination, kDay2Rep, kRev2Rep);

oeMean = [smaRGT; 0; inclination; 0; 0; 0];

epochGD = datetime('today');
epochJD = juliandate(epochGD);

% Let's propagate for kDay2Rep nodal Earth revolution periods
tSpan = linspace(0, periodEarthNodal * kDay2Rep / Consts.day2sec, 5e3);
tSpanGt = linspace(0, periodEarthNodal * kDay2Rep / Consts.day2sec, 1e5);

% Propagate it analytically for a repition time
rvEcefArray = propJ2AnalyticalCircECEF(oeMean, epochJD, epochJD + tSpan);
rvEcefArrayGt = propJ2AnalyticalCircECEF(oeMean, epochJD, epochJD + tSpanGt);

%% Plot RGT orbit groundtrack
plotGroundTrack(rvEcefArray(1:3, :));

spacecraft.instrumentFov = deg2rad(20);
spacecraft.elevationMin  = deg2rad(0);

[~, spacecraft.betaBeam] = calcBetaAngles(smaRGT, spacecraft);

% coverageAnimation(rvEcefArray(1:3, :), rvEcefArrayGt(1:3, :), tSpan, spacecraft, "swath");
