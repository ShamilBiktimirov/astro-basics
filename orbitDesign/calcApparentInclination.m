function inclinationApparent = calcApparentInclination(oeMean)

    % Reference: Capderou M. Satellites: Orbits and missions springer. – 2005., Section 5.2.4

    [periodSatNodal, periodEarthNodal] = calcPeriodNodal(oeMean);

    repeatFactor = periodEarthNodal ./ periodSatNodal;

    inclinationApparent = atan2(sin(oeMean(3)), (cos(oeMean(3)) -  1 ./ repeatFactor));

end
