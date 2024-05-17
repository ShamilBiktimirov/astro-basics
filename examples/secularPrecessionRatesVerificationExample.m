
% Script compares Earth oblateness-induced orbital secular change rates calculated using
% analytical expression and numerical analysis of orbital elements evolution

clear all;

global environment

environment = 'J2';

epochGD = datetime(2023, 4, 5, 0, 0, 0);
epochJD = juliandate(epochGD);

% defines mean orbital elements
oeMean             = zeros(6, 1);
oeMean(1)          = Consts.rEarth + 1000e3; % orbit sma, m
oeMean(2)          = 0.001;                     % ecc
oeMean(3)          = deg2rad(40); % sso orbit inclination, rad
epochGD = datetime(epochJD, 'convertfrom','juliandate');
oeMean(4)          = deg2rad(40); % RAAN for terminator oriented orbit
oeMean(5)          = deg2rad(100); % AOP, deg
oeMean(6)          = deg2rad(100); % M, deg - actually argument of latitude

orbitPeriod = calcPeriodKeplerian(oeMean(1));
meanMotion  = 2 * pi / orbitPeriod;
[raanRateAnalytical, aopRateAnalytical, ma0RateAnalytical] = calcSecularPrecessionRates(oeMean(1), oeMean(2), oeMean(3));
argOfLatRateAnalytical = aopRateAnalytical + ma0RateAnalytical;

% Finding osculating orbital elements to define initial conditions for numerical simulations
oeOsc0 = meanOscMapping(oeMean, 'mean2osc');


rvECIBaseOrbit = oe2rv(oeOsc0);

spacecraft = [];

%% numerical ODE intergration
tspan = 1 : 10 * orbitPeriod;

options = odeset('RelTol',1e-8,'AbsTol',1e-8);
[tArray, rvECI] = ode45(@(t, rv) rhsFormationInertial(t, rv, [], spacecraft), tspan, rvECIBaseOrbit, options);
rvECI = rvECI';

for timeIdx = 1:length(tArray)

    oeOsc = rv2oe(rvECI(:, timeIdx));
    oeOscArray(:, timeIdx) = [oeOsc(1:5); oeOsc(7)];
    oeMeanArray(:, timeIdx) = meanOscMapping(oeOscArray(:, timeIdx), 'osc2mean');

end

% Calculating precession rates numerically
raanRateNumerical= wrapToPiCustom(oeMeanArray(4, end) - oeMeanArray(4, 1)) / tArray(end);

aopRateNumerical  = wrapToPiCustom(oeMeanArray(5, end) - oeMeanArray(5, 1)) / tArray(end);

dMaMeanJ2 = wrapToPiCustom(oeMeanArray(6, end) - oeMeanArray(6, 1));
dMaKepl = wrapToPiCustom(mod(meanMotion * tArray(end), 2 * pi));
ma0RateNumerical = (dMaMeanJ2 - dMaKepl) / tArray(end);

argOfLatPrecessionNumerical = aopRateNumerical + ma0RateNumerical;

% Calculating absolute differences between analytical and numerical estimatations
raanPrecessionError = abs(raanRateNumerical - raanRateAnalytical);
aopPrecessionError  = abs(aopRateNumerical - aopRateAnalytical);
ma0PrecessionError   = abs(ma0RateNumerical - ma0RateAnalytical);

%%
fig1 = figure;

subplot(2, 4, 1);
hold on;
plot(tArray/60, (oeOscArray(1, :) - Consts.rEarth) / 1e3, 'k', LineWidth=2);
plot(tArray/60, (oeMeanArray(1, :) - Consts.rEarth) / 1e3, '--k', LineWidth=2);
xlabel('time, hour');
ylabel('Orbit altitude, km')
legend('osculating', 'mean');
grid on;

subplot(2, 4, 2);
hold on;
plot(tArray/60, oeOscArray(2, :), 'k', LineWidth=2);
plot(tArray/60, oeMeanArray(2, :), '--k', LineWidth=2);
xlabel('time, hour');
ylabel('eccentricity')
legend('osculating', 'mean');
grid on;

subplot(2, 4, 3);
hold on;
plot(tArray/60, oeOscArray(3, :) * 180 / pi, 'k', LineWidth=2);
plot(tArray/60, oeMeanArray(3, :) * 180 / pi, '--k', LineWidth=2);
xlabel('time, hour');
ylabel('Orbit inclination, deg')
legend('osculating', 'mean');
grid on;

subplot(2, 4, 4);
hold on;
plot(tArray/60, oeOscArray(4, :) * 180 / pi, 'k', LineWidth=2);
plot(tArray/60, oeMeanArray(4, :) * 180 / pi, '--k', LineWidth=2);
xlabel('time, hour');
ylabel('Right ascension longitude, deg')
legend('osculating', 'mean');
grid on;

subplot(2, 4, 5);
hold on;
plot(tArray/60, mod(oeOscArray(5, :) * 180 / pi, 360), 'k', LineWidth=2);
plot(tArray/60, mod(oeMeanArray(5, :) * 180 / pi, 360), '--k', LineWidth=2);
xlabel('time, hour');
ylabel('Argument of Perigee, deg')
legend('osculating', 'mean');
grid on;

subplot(2, 4, 6);
hold on;
plot(tArray/60, mod(oeOscArray(6, :) * 180 / pi, 360), 'k', LineWidth=2);
plot(tArray/60, mod(oeMeanArray(6, :) * 180 / pi, 360), '--k', LineWidth=2);
xlabel('time, hour');
ylabel('Mean anomaly, deg')
legend('osculating', 'mean');
grid on;

subplot(2, 4, 7);
hold on;
plot(tArray/60, mod((oeOscArray(6, :) + oeOscArray(5, :)) * 180 / pi, 360), 'k', LineWidth=2);
plot(tArray/60, mod((oeMeanArray(6, :) + oeMeanArray(5, :)) * 180 / pi, 360), '--k', LineWidth=2);
xlabel('time, hour');
ylabel('Argument of latitude, deg')
legend('osculating', 'mean');
grid on;

fontsize(fig1, 20, "points");
