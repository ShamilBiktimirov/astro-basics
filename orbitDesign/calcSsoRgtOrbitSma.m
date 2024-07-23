function [sma, i_SSO, T_sat_nodal] = calcSsoRgtOrbitSma(k_rev2rep, k_day2rep)

    % Adopted from Vallado, Fundamentals of Astrodynamics and Applications,
    % Section 11.4.2
    % Circular orbits are considered
    % Author: Shamil Biktimirov

    sma = [];
    period_greenwich_nodal = 2 * pi / (Consts.omegaEarth - Consts.earthMeanMotion);
    k_revpday = k_rev2rep / k_day2rep;
    n_assumption = k_revpday * Consts.omegaEarth;
    a_assumption = (Consts.muEarth * (1 / n_assumption) ^ 2) ^ (1 / 3);

    a_step = 0.01;  % m
    delta_a = [-50e3 : a_step : 50e3];
    error_internal = 99999;
    eps = 1e-3;

    for i = 1:length(delta_a)

        a_local = a_assumption + delta_a(i);
        % replase with function with checked formulas
        incl_SSO = acos(-2 * a_local ^ (7 / 2) * Consts.earthMeanMotion ...
                   / (3 * Consts.rEarthEquatorial ^ 2 * Consts.earthJ2 * sqrt(Consts.muEarth)));

        period_kep = 2 * pi * sqrt(a_local ^ 3 / Consts.muEarth);
        period_sat_nodal_local = period_kep * (1 - 3 / 2 * Consts.earthJ2 * (Consts.rEarthEquatorial / a_local) ^ 2 * (3 - 4 * sin(incl_SSO) ^ 2));
        error = abs((period_sat_nodal_local * k_rev2rep - period_greenwich_nodal * k_day2rep));

        if error < eps

            if error < error_internal
                sma         = a_local;
                i_SSO       = incl_SSO;
                error_internal = error;
                T_sat_nodal = period_sat_nodal_local;
            end

        end

    end

    if sma < (Consts.rEarth + 100e3)
        sma         = NaN;
        i_SSO       = NaN;
        T_sat_nodal = NaN;

    end

    if isempty(sma)
        sma         = NaN;
        i_SSO       = NaN;
        T_sat_nodal = NaN;
        disp("No SSO RGT orbits for such parameters");
    end

end
