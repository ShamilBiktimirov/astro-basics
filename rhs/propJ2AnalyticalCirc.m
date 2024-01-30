function rv = propJ2AnalyticalCirc(oe, t)

    % Input
    % mean orbital elements, oe = [a; e; i; RAAN; AOP; MA]
    % time vector, t 

    % Output
    % rv(t)

    % so far for one satellite and for circular orbits

    a0    = oe(1);
    e0    = oe(2);
    i0    = oe(3);
    RAAN0 = oe(4);
    AOP0  = oe(5);
    MA0   = oe(6);

    c = 3 / 2 * sqrt(Consts.muEarth) * Consts.rEarthEquatorial ^ 2 * Consts.earthJ2;

    RAANprecessionRate = - c / ((1 - e0^2)^2 * a0^(7/2)) * cos(i0);
    AOPprecessionRate  = - c / ((1 - e0^2)^2 * a0^(7/2)) * (5/2 * sin(i0)^2 - 2);
    MApressionRate     = - c / ((1 - e0^2)^2 * a0^(7/2)) * sqrt(1 - e0^2) * (3/2 * sin(i0)^2 - 1);

    n = sqrt(Consts.muEarth/ a0^3);

    argOfLat = AOP0 + AOPprecessionRate * t + MA0 + MApressionRate*t + n * t;
    RAAN     = RAAN0 + RAANprecessionRate * t;


    M1 = zeros(3, 3, length(t));
    M3 = zeros(3, 3, length(t));

    % first rotation on RAAN angle
    M1(:, 1, :) = [cos(RAAN); ...
                   sin(RAAN); ...
                   zeros(1, length(t))];

    M1(:, 2, :) = [-sin(RAAN); ...
                   cos(RAAN); ...
                   zeros(1, length(t))];

    M1(:, 3, :) = [zeros(1, length(t)); ...
                   zeros(1, length(t)); ...
                   ones(1, length(t))];

    % second rotation along x axis on inclination angle
    M2 = [[1, 0, 0]; ...
          [0, cos(i0), -sin(i0)]; ...
          [0, sin(i0), cos(i0)]];

    M2 = repmat(M2, 1, 1, length(t));

    % third rotation around z axis on agr of lat angle
    M3(:, 1, :) = [cos(argOfLat); ...
                   sin(argOfLat); ...
                   zeros(1, length(t))];

    M3(:, 2, :) = [sin(argOfLat); ...
                   cos(argOfLat); ...
                   zeros(1, length(t))];

    M3(:, 3, :) = [zeros(1, length(t)); ...
                   zeros(1, length(t)); ...
                   ones(1, length(t))];


    M1M2 = pagemtimes(M1, M2);
    rotationMatrix = pagemtimes(M1M2, M3);

    r = squeeze(pagemtimes(rotationMatrix, repmat([a0; 0; 0], 1, 1, length(t))));
    v = squeeze(pagemtimes(rotationMatrix, repmat([0; sqrt(Consts.muEarth / a0); 0], 1, 1, length(t))));

    rv = [r; v];

end
