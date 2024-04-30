function rvorb = dOE2rvorb(dOE, OEc)

    % this function convert difference in orbital elements to relative state vector from chief to deputy satelite:
    % this works with any chief eccentricity
    
    % inputs:
    % dOE = [da, dtheta, dinc, dq1, dq2, dRAAN]
    % theta = w + f, q1 = e cos(w), q2 = e sin(w)

    % outputs: 
    % rv: relative state vector, [km]
    % OEc: chief orbital elements: [a, e, inc, RAAN, w, f] [km, rad]
    % f is true anomaly

    % reference:
    % ANALYTICAL MECHANICs of AEROSPACE SYSTEMS by Hanspeter Schaub SPACECRAFT FORMATION FLYING chapter

    a = OEc(1);
    theta = OEc(5) + OEc(6);
    inc = OEc(3);
    q1 = OEc(2) * cos(OEc(5));
    q2 = OEc(2) * sin(OEc(5));
    RAAN = OEc(4);

    r = calc_r([a, theta, inc, q1, q2, RAAN]);
    [vr, vt, p, h] = calc_vr_vt([a, theta, inc, q1, q2, RAAN]);


    A1r = [r/a, vr/vt * r, 0, -r/p * (2 * a * q1 + r * cos(theta)), -r/p * (2 * a * q2 + r*sin(theta)), 0];
    A2r = [0, r, 0, 0, 0, r * cos(inc)];
    A3r = [0, 0, r * sin(theta), 0, 0, -r * cos(theta) * sin(inc)];
    
    A4r = [-vr/2/a, (1/r - 1/p) * h, 0, (vr * a * q1 + h * sin(theta))/p , (vr*a*q2 - h*cos(theta))/p, 0];
    A5r = [-3*vt/2/a, -vr, 0, (3 * vt*a*q1 + 2 * h * cos(theta))/p, (3 * vt*a*q2 + 2*h*sin(theta))/p,  vr*cos(inc)];
    A6r = [0, 0, vt*cos(theta) + vr*sin(theta), 0, 0, (vt*sin(theta) -vr*cos(theta))*sin(inc)];
    
    A = [A1r; A2r; A3r; A4r; A5r; A6r];

    rvorb = A * dOE; 
    

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


end