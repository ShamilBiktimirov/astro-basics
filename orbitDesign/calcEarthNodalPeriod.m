function pEarthNodal = calcEarthNodalPeriod(a, e, i)

    [raanDot, ~, ~] = calcSecularPrecessionRates(a, e, i);
    pEarthNodal = 2 * pi / (Consts.omegaEarth - raanDot);

end
