function dOE = rvorb2dOE(rv, OEc)

    
    % this function converts relative state vector from chief to deputy satelite to difference in orbital elements:
    % this works with any chief eccentricity
    % [a, theta, inc, q1, q2, RAAN]


    % inputs: 
    % rv: relative state vector, [m] orbVHR
    % OEc: chief orbital elements: [a, e, inc, RAAN, w, f] [m, rad]
    % f is true anomaly

    % output:
    % dOE = [da, dtheta, dinc, dq1, dq2, dRAAN]
    % theta = w + f, q1 = e cos(w), q2 = e sin(w)

    % reference:
    % ANALYTICAL MECHANICs of AEROSPACE SYSTEMS by Hanspeter Schaub SPACECRAFT FORMATION FLYING chapter

    
    rvRVH = orbVHR2RVH(rv);
    a = OEc(1);
    theta = OEc(5) + OEc(6);
    inc = OEc(3);
    q1 = OEc(2) * cos(OEc(5));
    q2 = OEc(2) * sin(OEc(5));
    RAAN = OEc(4);

    r = calc_r([a, theta, inc, q1, q2, RAAN]);
    [vr, vt, p, h] = calc_vr_vt([a, theta, inc, q1, q2, RAAN]);
    
    
    [alpha, nu, rho, k1, k2, h] = find_mapping_coeff([a, theta, inc, q1, q2, RAAN]);
    
    
    A_I_11 = 2 * alpha * (2 + 3*k1 + 2*k2);
    A_I_12 = -2 * alpha * nu * (1 + 2*k1 + k2);
    A_I_14 = 2 * alpha^2 * nu * p / vt;
    A_I_15 = 2 * a / vt * (1 + 2*k1 + k2);
    
    A_I_r1 = [A_I_11, A_I_12, 0, A_I_14, A_I_15, 0];
    
    
    A_I_22 = 1 / r;
    A_I_23 = cot(inc) / r * (cos(theta) + nu * sin(theta));
    A_I_26 = - sin(theta) * cot(inc) / vt;
    
    A_I_r2 = [0, A_I_22, A_I_23, 0, 0, A_I_26];
    
    
    A_I_33 = (sin(theta) - nu * cos(theta)) / r;
    A_I_36 = cos(theta) / vt;
    
    A_I_r3 = [0, 0, A_I_33, 0, 0, A_I_36];
    
    
    A_I_41 = 1/rho/r * (3*cos(theta) + 2 * nu * sin(theta));
    A_I_42 = -1/r *(nu^2 / rho * sin(theta) + q1 * sin(2*theta) - q2 * cos(2*theta));
    A_I_43 = -q2*cot(inc)/r * (cos(theta) + nu * sin(theta));
    A_I_44 = sin(theta) / rho / vt;
    A_I_45 = 1/rho/vt * (2*cos(theta) + nu * sin(theta));
    A_I_46 = q2 * cot(inc) * sin(theta) /vt;
    
    A_I_r4 = [A_I_41, A_I_42, A_I_43, A_I_44, A_I_45, A_I_46];
    
    
    A_I_51 = 1/rho /r * (3*sin(theta) - 2 * nu * cos(theta));
    A_I_52 = 1/r * (nu^2 / rho * cos(theta) + q2 * sin(2*theta) + q1 * cos(2*theta));
    A_I_53 = q1 * cot(inc) / r * (cos(theta) + nu * sin(theta));
    A_I_54 = - cos(theta) / rho / vt;
    A_I_55 = 1 / rho / vt * (2 * sin(theta) - nu * cos(theta));
    A_I_56 = -q1 * cot(inc) * sin(theta) / vt;
    
    A_I_r5 = [A_I_51, A_I_52, A_I_53, A_I_54, A_I_55, A_I_56];
    
    
    A_I_63 = -(cos(theta) + nu*sin(theta)) / r / sin(inc);
    A_I_66 = sin(theta) / vt / sin(inc);
    
    A_I_r6 = [0, 0, A_I_63, 0, 0, A_I_66];
    
    
    A_I = [A_I_r1; A_I_r2; A_I_r3; A_I_r4; A_I_r5; A_I_r6];
    
    
    % calculate orbital elements difference 
    dOE = A_I * rvRVH;

    function [vr, vt, p, h] = calc_vr_vt(oe)

        p = oe(1) * (1 - (oe(4)^2 + oe(5)^2));
        h = sqrt(p * Consts.muEarth);
    
        vr = h / p * (oe(4) * sin(oe(2)) - oe(5) * cos(oe(2)));
    
        vt = h / p * (1 + oe(4) * cos(oe(2)) + oe(5) * sin(oe(2)));

    end


    function r = calc_r(oe)
    
        r = oe(1) * (1 - (oe(4)^2 + oe(5)^2)) / ...
            (1 + oe(4) * cos(oe(2)) + oe(5) * sin(oe(2)));
    
    end


    function [alpha, nu, rho, k1, k2, h] = find_mapping_coeff(oe)
    
        r = calc_r(oe);
    
        [vr, vt, p, h] = calc_vr_vt(oe);
    
        alpha = oe(1) / r;
    
        nu = vr / vt;
    
        rho = r / p;
    
        k1 = alpha * (1 / rho - 1);
        k2 = alpha * nu^2 / rho;
    
    end

end