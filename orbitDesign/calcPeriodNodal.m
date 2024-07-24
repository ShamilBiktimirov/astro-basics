function [periodNodalSatellite, periodNodalEarth] = calcPeriodNodal(oe)

    pKeplerian = 2 * pi * sqrt(oe(1, :) .^ 3 / Consts.muEarth);

    raanDot = calcSecularPrecessionRates(oe(1, :), oe(2, :), oe(3, :));

    periodNodalSatellite = pKeplerian .* ...
        (1 - 3 / 2 * Consts.earthJ2 * (Consts.rEarthEquatorial ./ oe(1, :)) .^ 2 .* (3 - 4 * sin(oe(3, :)) .^ 2));

    periodNodalEarth = 2 * pi ./ (Consts.omegaEarth - raanDot);

end
