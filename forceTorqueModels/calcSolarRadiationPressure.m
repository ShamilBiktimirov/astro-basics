function aSRP = calcSolarRadiationPressure(rSat, rSun, rCentralBody, areaSat, massSat, Cr)

    % Function calculates solar radiation pressure with the simplest model
    % It takes into account shadow from the central body

    % Input:
    % rSat 3x1
    % rSun 3x1
    % rCentralBody, scalar, radius of central body
    % areaSat, satellite area projected to the eSun direction
    % massSat, satellite mass
    % Cr, reflectivity coefficient

    % Output:
    % aSRP - acceleration caused by the solar radiation pressure

    % Note: aSRP is zero if the satellite is in umbra


    los = calcLosCondition(rSat, rSun, 'rCentralBody', rCentralBody);

    if los
        areaSat = 0.3 * 0.3; % ala lander area, m^2
        massSat = 10; % kg
        Cr = 1.5; % reflection coefficient for aluminum
        eSun = rSun / norm(rSun);
        aSRP = -eSun * Consts.solarRadiationPressure * areaSat * Cr / massSat;
    else
        aSRP = [0; 0; 0];
    end

end
