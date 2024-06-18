clear all;

%% Script described Example 12-8. Solving a Gravity Assist.
% From Vallado D., Fundamentals of Astrodynamics and Applications

%% 1. Initial Conditions found using JPL SSD

% Cartesian States' dimensions [m, m/s]
% Epoch is given in UTC

% Earth's Cartesian State Vector for Epoch t0
rEarth_t0 = [1.465271799480787E+08; -3.732670724709265E+07; -1.030241210813448E+04] * 1e3; 
vEarth_t0 = [6.788440320801186E+00; 2.878676163172904E+01; 1.019132391082422E-03] * 1e3;

rvEarth_t0 = [rEarth_t0; vEarth_t0];
t0_datetime = datetime(1977, 09, 08, 09, 08, 17);

% Jupiter's Cartesian State Vector at Gravity Maneuver, t1
rJupiter = [-4.812150386574786E+08; 6.270737796430908E+08; 8.194289807929218E+06] * 1e3;
vJupiter = [-1.051200745038958E+01; -7.352085897800183E+00 ; 2.657827212046371E-01] * 1e3;

rvJupiter_t1 = [rJupiter; vJupiter];

t1_datetime = datetime(1979, 03, 05, 12, 05, 26);

% Saturn's Cartesian State Vector for epoch t2
rSaturn = [-1.420050239451003E+09; -5.430870938238035E+07; 5.738306221609765E+07] * 1e3;
vSaturn = [-1.472548021088546E-01; -9.670628326959832E+00; 1.753049587467692E-01] * 1e3;

rvSaturn_t2 = [rSaturn; vSaturn];

t2_datetime = datetime(1980, 11, 12, 23, 46, 30);

%% Solving Lambert's problem for Earth to Jupiter trajectory
dtDaysTrip1  = days(t1_datetime - t0_datetime);
dtYearsTrip1 = years(t1_datetime - t0_datetime);

[vDepartureEarth, vArrivalJupiter] = lambert(rEarth_t0' ./ 1e3,...
                                      rJupiter' ./ 1e3,...
                                      dtDaysTrip1,...
                                      0,...
                                      Consts.muSun / 1e9);

rvSc_t0 = [rEarth_t0; vDepartureEarth' * 1e3];

%% Solving Lambert's problem for Jupiter to Saturn trajectory
dtDaysTrip2 = days(t2_datetime - t1_datetime);
dtYearsTrip2 = years(t2_datetime - t1_datetime);

[vDepartureJupiter, vArriavalSaturn] = lambert(rJupiter' ./ 1e3,...
                                          rSaturn' ./ 1e3,...
                                          dtDaysTrip2,...
                                          0,...
                                          Consts.muSun / 1e9);

rvSc_t1 = [rJupiter; vDepartureJupiter' * 1e3];

%% Jupiter Gravity assist maneuver analysis

% Excess velocity is found in m/s

% hyperbolic excess velocity at Jupiter arrival given the Lambert's problem solution
v_inf_Jupiter_in     = vArrivalJupiter' * 1e3 - vJupiter;
v_inf_Jupiter_in_mag = norm(v_inf_Jupiter_in);

% hyperbolic excess velocity at Jupiter departure given the Lambert's problem solution
v_inf_Jupiter_out = vDepartureJupiter' * 1e3 - vJupiter;
v_inf_Jupiter_out_mag = norm(v_inf_Jupiter_out);

turnAngle = acos(dot(v_inf_Jupiter_in, v_inf_Jupiter_out) / v_inf_Jupiter_in_mag^2);
turningAngleDeg = rad2deg(turnAngle);

c3 = v_inf_Jupiter_in_mag ^ 2; % specific energy of satellite at hyperbolic orbit around Jupiter
rPer = Consts.muJupiter / c3 * (1 / cos((pi - turnAngle) / 2) - 1);
hPer = rPer - Consts.rJupiter;

dV_GA = norm(vDepartureJupiter) - norm(vArrivalJupiter);
turnAngleHeliocentric = acos(dot(vDepartureJupiter, vArrivalJupiter) / norm(vDepartureJupiter) / norm(vArrivalJupiter)) * 180 / pi;

%% Simulations

options = odeset('RelTol',1e-10,'AbsTol',1e-10);

% Earth
[t_vec, rvEciEarth] = ode45(@(t, rv) twoBodyDynamicsSunCenteredRhs(t, rv), [0:Consts.day2sec:Consts.day2sec*500], rvEarth_t0, options);
rvEciEarth = rvEciEarth';
rvEciEarthAu = rvEciEarth ./ Consts.astronomicUnit;

% Jupiter
[t_vec, rvEciJupiter] = ode45(@(t, rv) twoBodyDynamicsSunCenteredRhs(t, rv), [0:Consts.day2sec:Consts.day2sec*500*10], rvJupiter_t1, options);
rvEciJupiter = rvEciJupiter';
rvEciJupiterAu = rvEciJupiter ./ Consts.astronomicUnit;

% Saturn
[t_vec, rvEciSaturn] = ode45(@(t, rv) twoBodyDynamicsSunCenteredRhs(t, rv), [0:Consts.day2sec:Consts.day2sec*500*60], rvSaturn_t2, options);
rvEciSaturn = rvEciSaturn';
rvEciSaturnAu = rvEciSaturn ./ Consts.astronomicUnit;

% Earth-Saturn transfer
[t_vec, rvEciSatArc1] = ode45(@(t, rv) twoBodyDynamicsSunCenteredRhs(t, rv), [0:Consts.day2sec:Consts.day2sec * dtDaysTrip1], rvSc_t0, options);
rvEciSatArc1 = rvEciSatArc1';
rvEciSatArc1Au = rvEciSatArc1 ./ Consts.astronomicUnit;

% Saturn-Jupiter transfer
[t_vec, rvEciSatArc2] = ode45(@(t, rv) twoBodyDynamicsSunCenteredRhs(t, rv), [0:Consts.day2sec:Consts.day2sec * dtDaysTrip2], rvSc_t1, options);
rvEciSatArc2 = rvEciSatArc2';
rvEciSatArc2Au = rvEciSatArc2 ./ Consts.astronomicUnit;

% Hyperbolic trajectory around Jupiter
vP = sqrt(v_inf_Jupiter_out_mag ^ 2 + 2 * Consts.muJupiter / rPer);
rvScHyperb = [rPer; 0; 0; 0; vP; 0];
rvScHyperbMirrored = [rPer; 0; 0; 0; -vP; 0];

% Jupiter passage
[t_vec, rvEciSatHyperbolic] = ode45(@(t, rv) twoBodyDynamicsJupiterCenteredRhs(t, rv), [0 : 10 : Consts.day2sec * 0.8], rvScHyperb, options);
rvEciSatHyperbolic = rvEciSatHyperbolic';

% Jupiter passage backpropagation
[t_vec, rvEciSatHyperbolicMirrored] = ode45(@(t, rv) twoBodyDynamicsJupiterCenteredRhs(t, rv), [0 : 10 : Consts.day2sec * 0.8], rvScHyperbMirrored, options);
rvEciSatHyperbolicMirrored = rvEciSatHyperbolicMirrored';

%% Visualization

% Heliocentric trajector
fig1 = figure();
hold on;
plot3(rvEciEarthAu(1, :), rvEciEarthAu(2, :), rvEciEarthAu(3, :), 'LineWidth', 2);
plot3(rvEciJupiterAu(1, :), rvEciJupiterAu(2, :), rvEciJupiterAu(3, :), 'LineWidth', 2);
plot3(rvEciSaturnAu(1, :), rvEciSaturnAu(2, :), rvEciSaturnAu(3, :), 'LineWidth', 2);

plot3(rvEciSatArc1Au(1, :), rvEciSatArc1Au(2, :), rvEciSatArc1Au(3, :), '-.k', 'LineWidth', 2);

plot3(rvEciSatArc2Au(1, :), rvEciSatArc2Au(2, :), rvEciSatArc2Au(3, :), '--k', 'LineWidth', 2);

legend('Earth', 'Jupiter', 'Saturn', ...
       'Earth-Jupiter arc', 'Jupiter-Saturn arc');
axis equal;
xlabel('x, AU');
ylabel('y, AU');
fontsize(fig1, 24, "points");

% Jupiter-centered Voyager trajectory
fig2 = figure();
hold on;
image_file = 'jupiterMap.jpg';
[X, Y, Z] = sphere();
globe = surf(X * Consts.rJupiter / 1e9, Y * Consts.rJupiter / 1e9, -Z * Consts.rJupiter / 1e9, 'FaceColor', 'none', 'EdgeColor', 0.5 * [1 1 1]);
cdata = imread(image_file);
alpha = 1;
% Set image as color data (cdata) property, and set face color to indicate
% a texturemap, which Matlab expects to be in cdata. Turn off the mesh edges.
hold on;
set(globe, 'FaceColor', 'texturemap', 'CData', cdata, 'FaceAlpha', alpha, 'EdgeColor', 'none');
axis equal;

plot3(rvEciSatHyperbolic(1, :) / 1e9, rvEciSatHyperbolic(2, :) / 1e9, rvEciSatHyperbolic(3, :) / 1e9, 'k', 'LineWidth', 2);
plot3(rvEciSatHyperbolicMirrored(1, :) / 1e9, rvEciSatHyperbolicMirrored(2, :) / 1e9, rvEciSatHyperbolicMirrored(3, :) / 1e9, 'k', 'LineWidth', 2);
xlabel('x, mln km');
ylabel('y, mln km');
axis equal;
legend('Jupiter', 'Voyager 1 trajectory');

fontsize(fig2, 24, "points");


%% Functions

function rvPrime = twoBodyDynamicsSunCenteredRhs(t, rv)

    rPrime = [rv(4:6, 1); zeros(3, 1)];
    rNorm  = vecnorm(rv(1:3, 1));

    % Central gravity field
    accelerationCg = [zeros(3, 1); -Consts.muSun ./ (rNorm.^3) .* rv(1:3, 1)];

    % rhs for two-body problem
    rvPrime = rPrime + accelerationCg;

end

function rvPrime = twoBodyDynamicsJupiterCenteredRhs(t, rv)

    rPrime = [rv(4:6, 1); zeros(3, 1)];
    rNorm  = vecnorm(rv(1:3, 1));

    % Central gravity field
    accelerationCg = [zeros(3, 1); -Consts.muJupiter ./ (rNorm.^3) .* rv(1:3, 1)];

    % rhs for two-body problem
    rvPrime = rPrime + accelerationCg;

end
