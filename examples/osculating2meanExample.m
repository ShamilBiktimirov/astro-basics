clear all;

global environment;

environment = 'J2';
options = odeset('RelTol',1e-12,'AbsTol',1e-12);
spacecraft = [];
% spacecraft parameters

oeOsc0 = [Consts.rEarth + 500e3; 0; 40 * pi / 180;  pi/2; 0; pi/4]; % define mean orbital elements set

% oeOsc0 = mean2osc(oeMean0); % finds corresponding set of osculating orbital elements;

rv0 = oe2rv(oeOsc0); % finds corresponding initial cartesian state vector

orbitPeriod = 2 * pi * sqrt(oeOsc0(1)^3 / Consts.muEarth); % orbit period

[tArray, rvEciArray] = ode45(@(t, rv) rhsFormationInertial(t, rv, [], spacecraft), [0:orbitPeriod], rv0, options);
rvEciArray = rvEciArray';

for timeIdx = 1:length(tArray)

    oeOscArray(:, timeIdx) = rv2oe(rvEciArray(:, timeIdx));
    oeMeanArray(:, timeIdx) = osc2mean(oeOscArray(1:6, timeIdx));

end

fig1 = figure;
subplot(2, 3, 1);
hold on;
plot(tArray/60, (oeOscArray(1, :) - Consts.rEarth) / 1e3, 'k', LineWidth=2);
plot(tArray/60, (oeMeanArray(1, :) - Consts.rEarth) / 1e3, '--k', LineWidth=2);
xlabel('time, hour');
ylabel('Orbit altitude, km')
legend('osculating', 'mean');

subplot(2, 3, 2);
hold on;
plot(tArray/60, oeOscArray(2, :), 'k', LineWidth=2);
plot(tArray/60, oeMeanArray(2, :), '--k', LineWidth=2);
xlabel('time, hour');
ylabel('eccentricity')
legend('osculating', 'mean');

subplot(2, 3, 3);
hold on;
plot(tArray/60, oeOscArray(3, :) * 180 / pi, 'k', LineWidth=2);
plot(tArray/60, oeMeanArray(3, :) * 180 / pi, '--k', LineWidth=2);
xlabel('time, hour');
ylabel('Orbit inclination, deg')
legend('osculating', 'mean');

subplot(2, 3, 4);
hold on;
plot(tArray/60, oeOscArray(4, :) * 180 / pi, 'k', LineWidth=2);
plot(tArray/60, oeMeanArray(4, :) * 180 / pi, '--k', LineWidth=2);
xlabel('time, hour');
ylabel('Right ascension longitude, deg')
legend('osculating', 'mean');

subplot(2, 3, 5);
hold on;
plot(tArray/60, mod((oeOscArray(5, :) + oeOscArray(6, :)) * 180 / pi, 360), 'k', LineWidth=2);
plot(tArray/60, mod((oeMeanArray(5, :) + oeMeanArray(6, :)) * 180 / pi, 360), '--k', LineWidth=2);
xlabel('time, hour');
ylabel('Argument of latitude, deg')
legend('osculating', 'mean');

fontsize(fig1, 24, "points");
