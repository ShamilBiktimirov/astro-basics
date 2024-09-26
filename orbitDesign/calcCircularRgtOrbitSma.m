function [a, periodEarthNodal] = calcCircularRgtOrbitSma(i, kDay2Rep, kRev2Rep)

    % Function finds semi-major for a user specified repeat ground track orbit

    % Input:
    % i [rad], orbit inclination
    % kDay2Rep [-], positive integer value defining number of days for orbit's ground track to repeat
    % kRev2Rep [-], positive integer value defining number of periods for orbit's ground track to repeat

    % Output:
    % a [m], orbit semi-major axis

    assert(mod(kDay2Rep, 1) < 1e-16 && mod(kRev2Rep, 1) < 1e-16, "kDay2Rep or kRev2Rep is not integer");

    options = optimoptions('fsolve', 'Display', 'none', 'FunctionTolerance', 1e-15);

    c = 3 / 2 * Consts.rEarthEquatorial^2 * Consts.earthJ2;

    r0 = (Consts.muEarth / (kRev2Rep / kDay2Rep * Consts.omegaEarth) ^ 2) ^ (1/3); % initial guess

    f = @(r) kDay2Rep * 2 * pi / (Consts.omegaEarth + c * sqrt(Consts.muEarth) * cos(i) * r ^ (-7 / 2)) ...
             - kRev2Rep * 2 * pi / sqrt(Consts.muEarth) * r ^ (3 / 2) * (1 - c * r ^ (-2) * (3 - 4 * sin(i) ^ 2));

    a = fsolve(f, r0, options);

    [raanDot, ~, ~] = calcSecularPrecessionRates(a, 0, i);

    periodEarthNodal = 2 * pi / (Consts.omegaEarth - raanDot);

    if a < Consts.rEarth
        warning("RGT orbit sma is lower than mean Earth radius");
        a = [];
    end

end
