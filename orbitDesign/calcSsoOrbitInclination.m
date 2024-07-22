function inclination = calcSsoOrbitInclination(a, ecc)

    % The formula for the RAAN drift is taken from D.A. Vallado Fundamentals of
    % Astrodynamics, page 649, eq 9-37

    % Inputs: constants, a - semi-major axis [m] and inclination
    % Outputs: SSO orbit inclination [rad]

    p = a .* (1 - ecc .^ 2);
    n = sqrt(Consts.muEarth ./ a .^3);

    inclination = acos( -(Consts.earthMeanMotion * 2 * p .^ 2) ./ ...
                        (3 * n * Consts.rEarth^2 * Consts.earthJ2)); 

end
