function c1 = calcDriftConstant(rvOrb, meanMotion)

    c1 = -2 * rvOrb(3, :) - rvOrb(4, :) ./ meanMotion;

end
