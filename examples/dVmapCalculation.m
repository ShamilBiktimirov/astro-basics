clear variables;

% dV map calculation

Planet_ephemerides = importdata('Earth_Mars_ephemerides.txt');
Planet_ephemerides = reshape(Planet_ephemerides, [7, 2]);
Planet_ephemerides = Planet_ephemerides';

input.Modeling_Start = juliandate(datetime(1977, 1, 1, 0, 0, 0));    % Modeling start JD 
input.Modeling_time  = 10 * Consts.year2day;                          % Modeling time (days)
input.LD_dt   = 7;                                                   % start date search step (days)
input.min_TOF = 200;                                                 % minimum time of flight (days)
input.max_TOF = 1000;                                                 % maximum time of flight (days)
input.TOF_dt  = 7;                                                   % time of flight search step (days)
input.dV_max  = 6.4;                                                 % Maximum dV capability of the spacecraft
input.LEO     = 500;                                                 % LEO orbit
input.LMO     = 500;                                                 % LMO orbit

% add here jupiter, saturn
% find departure arrival velocities at infinity
% see what happens with voyager trip

% oe_table format [sma [km], ecc [-], inc[deg], RAAN [deg], AOP[deg], MA[deg], Epoch[JD], muPlanet[km3/s2], rPlanet [km], LowPlanetOrbitRadius[km]]
oe_Earth = [Planet_ephemerides(1,:), Consts.muEarth / 1e9, Consts.rEarth, input.LEO];
oe_Mars  = [Planet_ephemerides(2,:), Consts.muMars / 1e9, Consts.rMars, input.LMO];

oe_table = [oe_Earth; oe_Mars];

oe_table = oe_update(oe_table, input.Modeling_Start);    % Update orbital elements

% Calculating dV maps
dV_map = calculate_dV_map_patched_conic(oe_table(1, :), oe_table(2, :), input);

% Finding dV local minima
LW = calculate_transfer_list(dV_map, input);

% Visualization
plot_dV_map(dV_map, input, inf);
hold on;
plot(LW(:, 1), LW(:, 2), 'or', 'MarkerFaceColor', 'r');
legend('dV map', 'Launch windows');
title('Mars-Asteroid dV map');
