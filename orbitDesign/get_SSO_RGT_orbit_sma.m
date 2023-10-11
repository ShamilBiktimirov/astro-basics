function [sma, i_SSO, T_sat_nodal] = get_SSO_RGT_orbit_sma(k_rev2rep, k_day2rep, consts)
    % Adopted from Vallado, Fundamentals of Astrodynamics and Applications,
    % Section 11.4.2
    % Circular orbits are considered
    % Author: Shamil Biktimirov
    sma = [];
    T_greenwich_nodal = 2*pi / (consts.omegaEarth - consts.EarthMeanMotion);
    k_revpday = k_rev2rep / k_day2rep;
    n_assumption = k_revpday * consts.omegaEarth;
    a_assumption = (consts.muEarth*(1/n_assumption)^2)^(1/3);
    
    a_step = 0.1;  % m
    delta_a = [-50e3:a_step:50e3];
    error_internal = 99999;
    eps = 1e-3;

    for i = 1:length(delta_a)    
    
        a_local = a_assumption + delta_a(i);
        incl_SSO = acos(-2*a_local^(7/2)*consts.EarthMeanMotion/(3*consts.rEarth_equatorial^2*consts.J2*sqrt(consts.muEarth)));
        T_kep = 2*pi*sqrt(a_local^3/consts.muEarth);
        T_sat_nodal_local = T_kep*(1 - 3/2*consts.J2*(consts.rEarth_equatorial/a_local)^2*(3 - 4*sin(incl_SSO)^2));
        error = abs((T_sat_nodal_local*k_rev2rep - T_greenwich_nodal*k_day2rep));
        if error < eps
            if error < error_internal
                sma = a_local;
                i_SSO = incl_SSO;
                error_internal = error;
                T_sat_nodal = T_sat_nodal_local;
            end
        end
    
    end
    if sma < (consts.rEarth + 100e3)
        sma = NaN;
        i_SSO = NaN;
        T_sat_nodal = NaN;

    end
    if isempty(sma)
        sma = NaN;
        i_SSO = NaN;
        T_sat_nodal = NaN;
        disp("No SSO RGT orbits for such parameters");
    end
end