clear variables;

% dV map calculation example

planet_ephemerides = importdata('Earth_Mars_ephemerides.txt');
% brigning data to a certain shape
planet_ephemerides = reshape(planet_ephemerides, [7, 2]);
planet_ephemerides = planet_ephemerides';

input.Modeling_Start = juliandate(datetime(2024, 1, 1, 0, 0, 0));    % Modeling start JD 
input.Modeling_time  = 10 * Consts.year2day;                         % Modeling time (days)
input.LD_dt   = 7;                                                   % start date search step (days)
input.min_TOF = 100;                                                 % minimum time of flight (days)
input.max_TOF = 1000;                                                % maximum time of flight (days)
input.TOF_dt  = 7;                                                   % time of flight search step (days)
input.dV_max  = 100;                                                 % Maximum dV capability of the spacecraft
input.LEO     = 500;                                                 % LEO orbit
input.LMO     = 500;                                                 % LMO orbit
input.MaximumRevolutionsNumber = 0;                                  % number of complete revolutions for 

% oe_table format [sma [km], ecc [-], inc[deg], RAAN [deg], AOP[deg], MA[deg], Epoch[JD], muPlanet[km3/s2], rPlanet [km], LowPlanetOrbitRadius[km]]
oe_table_additional = [Consts.muEarth / 1e9, Consts.rEarth / 1e3, input.LEO; ...
                       Consts.muMars / 1e9, Consts.rMars / 1e3, input.LMO];

oe_table = [planet_ephemerides, oe_table_additional];

oe_table = oe_update(oe_table, input.Modeling_Start);    % Update orbital elements


%% Calculating dV maps

% Earth-Mars dV map
[dVtotalEarthMars, ~, ~] = calculate_dV_excess_map_patched_conic(oe_table(1, :), oe_table(2, :), input);
LwEarthMars = calculate_transfer_list(dVtotalEarthMars, input);


%% Visualization

% Earth Mars, hyperbolic excess velocity
plot_dV_map(dVtotalEarthMars, input, 50);
hold on;
plot(LwEarthMars(:, 1), LwEarthMars(:, 2), 'or', 'MarkerFaceColor', 'r');
legend('dV map Earth-Mars', 'Launch windows');
title('Spacecraft dV map for Earth Mars transfer');
