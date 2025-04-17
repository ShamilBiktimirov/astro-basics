function sma = calcRgtOrbitSma(k_rev2rep, k_day2rep, inclination)

    % This function is used to find RGT orbits for a given inclination
    % Adopted from Vallado, Fundamentals of Astrodynamics and Applications,
    % Section 11.4.2
    % Circular orbits are considered

    sma = [];
    k_revpday = k_rev2rep / k_day2rep;
    n_assumption = k_revpday * Consts.omegaEarth;
    a_assumption = (Consts.muEarth * (1 / n_assumption) ^ 2) ^ (1 / 3);

    a_step = 0.01;  % m
    delta_a = [-1000e3:a_step:1000e3];
    error_internal = 99999;
    eps = 1e-2;

    for i = 1:length(delta_a)
        a_local = a_assumption + delta_a(i);
        T_kep = 2 * pi * sqrt(a_local ^ 3 / Consts.muEarth);
        Raan_dot = - 3 / 2 * Consts.rEarthEquatorial ^ 2 * Consts.earthJ2 * cos(inclination) * 2 * pi / T_kep * 1 / a_local ^ 2;
        T_greenwich_nodal = 2 * pi / (Consts.omegaEarth - Raan_dot);
        T_sat_nodal_local = T_kep * (1 - 3 / 2 * Consts.earthJ2 * (Consts.rEarthEquatorial / a_local) ^ 2 * (3 - 4 * sin(inclination) ^ 2));
        error = abs((T_sat_nodal_local*k_rev2rep - T_greenwich_nodal*k_day2rep));

        if error < eps
            if error < error_internal
                sma = a_local;
                error_internal = error;
            end
        end

    end

    if sma < (Consts.rEarth + 100e3)
        sma = NaN;

    end
    if isempty(sma)
        sma = NaN;
        disp("No RGT orbits for such parameters");
    end

end
