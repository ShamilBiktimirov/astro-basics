function [raanSecularPrecessionRate, aopSecularPrecessionRate, ma0SecularPrecessionRate] = calcSecularPrecessionRates(aMean, eMean, iMean)

    % Function calculates precession rates for a given orbital parameters: a, e, i
    % Note: The orbital parameters should be mean

    % Reference:
    % The formulas for the drifts are taken from D.A. Vallado Fundamentals of Astrodynamics
    % RAAN drift: page 649, eq. 9-37
    % AOP drift: page 651, eq. 9-39
    % MA0 drift: page 9-41, eq. 9-41

    % Input:
    % a [m], mean semi-major axis
    % e [-], mean eccentricity
    % i [rad], mean inclination

    % Output:
    % raanSecularPrecessionRate [rad/s], Right Ascension of Ascending Node (RAAN) secular precession rate
    % aopSecularPrecessionRate [rad/s], Argument of Perigee (AOP) secular precession rate
    % ma0SecularPrecessionRate [rad/s], Mean Anomaly (MA) secular precession rate


    c = 3 / 2 * sqrt(Consts.muEarth) * Consts.rEarthEquatorial ^ 2 * Consts.earthJ2;

    raanSecularPrecessionRate = - c / ((1 - eMean^2) ^ 2 * aMean ^ (7 / 2)) * cos(iMean);
    aopSecularPrecessionRate  = - c / ((1 - eMean^2) ^ 2 * aMean ^ (7 / 2)) * (5 / 2 * sin(iMean) ^ 2 - 2);
    ma0SecularPrecessionRate  = - c / ((1 - eMean^2) ^ 2 * aMean ^ (7 / 2)) * sqrt(1 - eMean ^ 2) * (3 / 2 * sin(iMean) ^ 2 - 1);

end
