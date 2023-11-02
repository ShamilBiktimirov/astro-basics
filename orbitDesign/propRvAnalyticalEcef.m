function rFunction = propRvAnalyticalEcef(oe0, tJd0)

    % TODO: add arg of lat instead of MA
    syms t real

    theta0 = JD2GAST(tJd0);

    a0    = oe0(1);
    e0    = oe0(2);
    i0    = oe0(3);
    RAAN0 = oe0(4);
    AOP0  = oe0(5);
    MA0   = oe0(6);

    c = 3 / 2 * sqrt(Consts.muEarth) * Consts.rEarthEquatorial ^ 2 * Consts.earthJ2;

    RAANprecessionRate = - c / ((1 - e0^2)^2 * a0^(7/2)) * cos(i0);
    AOPprecessionRate  = - c / ((1 - e0^2)^2 * a0^(7/2)) * (5/2 * sin(i0)^2 - 2);
    MApressionRate     = - c / ((1 - e0^2)^2 * a0^(7/2)) * sqrt(1 - e0^2) * (3/2 * sin(i0)^2 - 1);

    n = sqrt(Consts.muEarth/oe0(1)^3);

    argOfLat = AOP0 + AOPprecessionRate*t + MA0 + MApressionRate*t + n*t;
    RAAN0 = RAAN0 + RAANprecessionRate*t;

    theta = theta0 + Consts.omegaEarth * t;

    M1 = [cos(argOfLat), sin(argOfLat), 0
          -sin(argOfLat), cos(argOfLat), 0
          0, 0, 1];

    M2 = [1, 0, 0
          0, cos(i0), sin(i0)
          0, -sin(i0), cos(i0)];

    M3 = [cos(RAAN0), sin(RAAN0),0
          -sin(RAAN0), cos(RAAN0), 0
          0, 0, 1];

    M4 = [cos(theta), sin(theta),0
          -sin(theta), cos(theta), 0
          0, 0, 1];

    Rotation_matrix = M1 * M2 * M3 * M4;

    Rotation_matrix = Rotation_matrix';

    rFunction = Rotation_matrix * [oe0(1); 0; 0];
