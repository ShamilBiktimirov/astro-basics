function pDraconic = calcDraconicPeriod(oe)

    pKeplerian = 2 * pi * sqrt(oe(1)^3 / Consts.muEarth);
    pDraconic = pKeplerian * ...
        (1 - 3 / 2 * Consts.earthJ2 * (Consts.rEarthEquatorial / oe(1))^2 * (3 - 4 * sin(oe(3))^2));

end
