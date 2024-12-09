function period = calcPeriodKeplerian(a)

    % Function calculates Keplerian orbital period for a given semi-major axis
    % Note: The orbital parameter should be mean if working with J2 perturbed dynamics for proper period estimate

    % Reference:
    % The formulas for the drifts are taken from D.A. Vallado Fundamentals of Astrodynamics
    % page 869, eq. 11-22

    % Input:
    % a [m], semi-major axis

    % Output:
    % period [s], Keplerian orbit period

    period = 2 * pi * sqrt(a^3 / Consts.muMoon);

end