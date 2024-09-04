function inclinationApparent = calcApparentInclination(oeMean)

    [periodSatNodal, periodEarthNodal] = calcPeriodNodal(oeMean);

    repeatFactor = periodEarthNodal ./ periodSatNodal;

    inclinationApparent = atan2(sin(oeMean(3)), (cos(oeMean(3)) -  1 ./ repeatFactor));

end
