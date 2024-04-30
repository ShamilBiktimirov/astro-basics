function rvorb = nearCircdOE2rvorb(dOE, OEc)
    
    % this function convert difference in orbital elements to relative state vector from chief to deputy satelite:
    % this works with Near-Circular Chief Orbit
    % used to map HCW constant to dOE

    % inputs:
    % dOE = [da, dtheta, dinc, dq1, dq2, dRAAN]
    % theta = w + f, q1 = e cos(w), q2 = e sin(w)

    % outputs: 
    % rv: relative state vector, [km]
    % OEc: chief orbital elements: [a, e, inc, RAAN, w, f] [km, rad]
    % f is true anomaly

    % reference:
    % ANALYTICAL MECHANICs of AEROSPACE SYSTEMS by Hanspeter Schaub SPACECRAFT FORMATION FLYING chapter


    f0 = 0; % initial true anomaly

    a = OEc(1);
    f = OEc(6);
    i = OEc(3);
    theta = f + OEc(5);



    da = dOE(1);
    de = dOE(2);
    di = dOE(3);
    dRAAN = dOE(4);
    dw = dOE(5);
    dM = dOE(6);

    thetaz = atan(di/(-sin(i) * dRAAN));


    rvorb(1, 1) = a * cos(f) * de + da;
    rvorb(2, 1) = (-2 * a * sin(f) * de) + (a * (dw + dM + cos(i) * dRAAN)) - (3/2 * (f - f0) * da);
    rvorb(3, 1) = a * sqrt(di^2 + (sin(i))^2 * dRAAN^2) * cos(theta - thetaz);

    if di == 0
    rvorb(3, 1) = 0;
    end


end