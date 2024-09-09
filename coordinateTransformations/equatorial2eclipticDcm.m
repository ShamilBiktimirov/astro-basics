function dcm = equatorial2eclipticDcm()

    % Function returns transformation matrix A_eq2ec defined as follows:
    % r_eq = A_eq2ec * r_ec

    % Refers to the Fig 3-7. from D. Vallado, Fundamentals of Astrodynamics and Application

    equatorInclination = deg2rad(23.5);

    dcm = [[1; 0; 0], ...
           [0; cos(equatorInclination); sin(equatorInclination)], ...
           [0; -sin(equatorInclination); cos(equatorInclination)]];

end
