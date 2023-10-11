function sv = oe2rv(oe)
    % Converts orbital elements to ECI state
    %
    % Input:
    %   * orbital elements [m, rad]
    %   * consts

    % Output:
    %   * rv [m, m/s], column vector

    sma  = oe(1); % m
    ecc  = oe(2); %  -
    inc  = oe(3); % rad
    RAAN = oe(4); % rad
    AOP  = oe(5); % rad
    MA   = oe(6); % rad

    E = mean2ecc(MA, ecc);
    v = 2 * atan(sqrt((1 + ecc) / (1 - ecc)) * tan(E / 2));
    r = sma * (1 - ecc ^ 2) / (1 + ecc * cos(v));

    r_pqw = r * [cos(v); sin(v); 0];
    v_pqw = sqrt(Consts.muEarth / (sma * (1 - ecc ^ 2))) * ...
            [-sin(v); ecc + cos(v); 0];

    Rz_O = [cos(RAAN), -sin(RAAN), 0;...
            sin(RAAN), cos(RAAN), 0; ...
            0, 0, 1];

    Rx_i = [1, 0, 0; ...
            0, cos(inc), -sin(inc); ...
            0, sin(inc), cos(inc)];

    Rz_w = [cos(AOP), -sin(AOP), 0; ...
            sin(AOP), cos(AOP), 0;  ...
            0, 0, 1];

    R = Rz_O * Rx_i * Rz_w;

    r_ijk = (R * r_pqw)';
    v_ijk = (R * v_pqw)';

    sv = [r_ijk'; v_ijk'];

end