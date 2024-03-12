clear all;

global environment

environment = 'point mass';

epochGD = datetime(2023, 4, 5, 0, 0, 0);
epochJD = juliandate(epochGD);

oe             = zeros(6, 1);
oe(1)          = Consts.rEarth + 350e3; % orbit sma, m
oe(2)          = 0;                     % ecc
oe(3)          = get_SSO_inclination(oe(1), oe(2)); % sso orbit inclination, rad
epochGD = datetime(epochJD, 'convertfrom','juliandate');
oe(4)          = get_RAAN_for_terminator_orbit(epochGD); % RAAN for terminator oriented orbit
oe(5)          = 0; % AOP, deg
oe(6)          = 0; % M, deg - actually argument of latitude

rvECIBaseOrbit = oe2rv(oe);

spacecraft = [];

%% numerical ODE intergration
tspan = 1 : 2 * pi * sqrt(oe(1)^3 / Consts.muEarth);

options = odeset('RelTol',1e-8,'AbsTol',1e-8);
[t_vec, rvECI] = ode45(@(t, rv) rhsFormationInertial(t, rv, [], spacecraft), tspan, rvECIBaseOrbit, options);
rvECI = rvECI';
