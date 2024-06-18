clear variables;

% dV map calculation example

planet_ephemerides = importdata('Earth_Mars_Jupiter_Saturn_ephemerides.txt');
% brigning data to a certain shape
planet_ephemerides = reshape(planet_ephemerides, [7, 4]);
planet_ephemerides = planet_ephemerides';

% specifying initial conditions
% look at dates for horizon mission - two dV maps, plot escape vel
% Earth   - Jupiter
% Jupiter - Saturn

t0_datetime = datetime(1977, 09, 08, 09, 08, 17);
t1_datetime = datetime(1979, 03, 05, 12, 05, 26);
t2_datetime = datetime(1980, 11, 12, 23, 46, 30);

t0Jd = juliandate(t0_datetime);
t1Jd = juliandate(t1_datetime);
t2Jd = juliandate(t2_datetime);

tofEarthJupiter  = days(t1_datetime - t0_datetime);
tofJupiterSaturn = days(t2_datetime - t1_datetime);

input.Modeling_Start = juliandate(datetime(1977, 1, 1, 0, 0, 0));   % Modeling start JD 
input.Modeling_time  = 3 * Consts.year2day;                         % Modeling time (days)
input.LD_dt   = 7;                                                % start date search step (days)
input.min_TOF = 500;                                                % minimum time of flight (days)
input.max_TOF = 700;                                                % maximum time of flight (days)
input.TOF_dt  = 7;                                                  % time of flight search step (days)
input.dV_max  = 100;                                                % Maximum dV capability of the spacecraft
input.LEO     = 500;                                                % LEO orbit
input.LMO     = 500;                                                % LMO orbit
input.MaximumRevolutionsNumber = 0;                                 % number of complete revolutions for 

% find departure arrival velocities at infinity
% see what happens with voyager trip

% oe_table format [sma [km], ecc [-], inc[deg], RAAN [deg], AOP[deg], MA[deg], Epoch[JD], muPlanet[km3/s2], rPlanet [km], LowPlanetOrbitRadius[km]]
oe_table_additional = [Consts.muEarth / 1e9, Consts.rEarth / 1e3, input.LEO; ...
                       Consts.muMars / 1e9, Consts.rMars / 1e3, input.LMO; ...
                       Consts.muJupiter / 1e9, Consts.rJupiter / 1e3, input.LMO; ...
                       Consts.muSaturn / 1e9, Consts.rSaturn / 1e3, input.LMO];

oe_table = [planet_ephemerides, oe_table_additional];

oe_table = oe_update(oe_table, input.Modeling_Start);    % Update orbital elements


%% Calculating dV maps

% Earth-Jupiter dV map
[~, ~, dVmapArrivalJupiter] = calculate_dV_excess_map_patched_conic(oe_table(1, :), oe_table(3, :), input);

% Finding dV local minima for Jupiter arrival
LwJupiterArrival = calculate_transfer_list(dVmapArrivalJupiter, input);

% Jupiter-Saturn dV map
[~, dVmapDepartureJupiter, ~] = calculate_dV_excess_map_patched_conic(oe_table(3, :), oe_table(4, :), input);

% Finding dV local minima for Jupiter departure
LwJupiterDeparture = calculate_transfer_list(dVmapDepartureJupiter, input);

%% Proccessing

LD_vec = (1:input.LD_dt:input.Modeling_time) + input.Modeling_Start;
LD_vec = LD_vec(:) - Consts.delta_mjd;
TOF_vec = input.min_TOF:input.TOF_dt:input.max_TOF;

[~, LDEarthIdx] = min(abs(LD_vec - (t0Jd - Consts.delta_mjd)));
[~, TOFEarthJupiterIdx] = min(abs(TOF_vec - tofEarthJupiter));

[~, LDJupiterIdx] = min(abs(LD_vec - (t1Jd - Consts.delta_mjd)));
[~, TOFJupiterSaturnIdx] = min(abs(TOF_vec - tofJupiterSaturn));

dVJupiterInfIn  = dVmapArrivalJupiter(LDEarthIdx,   TOFEarthJupiterIdx);
dVJupiterInfOut = dVmapDepartureJupiter(LDJupiterIdx, TOFJupiterSaturnIdx);


%% Visualization

% Jupiter arrival, hyperbolic excess velocity
plot_dV_map(dVmapArrivalJupiter, input, inf);
hold on;
plot(LwJupiterArrival(:, 1), LwJupiterArrival(:, 2), 'or', 'MarkerFaceColor', 'r');
plot(t0Jd - Consts.delta_mjd, tofEarthJupiter,  'og', 'MarkerFaceColor', 'g');
legend('dV map', 'Launch windows', 'Voyager arrival to Jupiter');
title('Spacecraft Jupiter arrival dV map, v_{inf}^{in}');

% Jupiter departure, hyperbolic excess velocity
plot_dV_map(dVmapDepartureJupiter, input, inf);
hold on;
plot(LwJupiterDeparture(:, 1), LwJupiterDeparture(:, 2), 'or', 'MarkerFaceColor', 'r');
plot(t1Jd - Consts.delta_mjd, tofJupiterSaturn,  'og', 'MarkerFaceColor', 'g');
legend('dV map', 'Launch windows', 'Voyager departure from Jupiter');
title('Spacecraft Jupiter departure dV map, v_{inf}^{out}');
