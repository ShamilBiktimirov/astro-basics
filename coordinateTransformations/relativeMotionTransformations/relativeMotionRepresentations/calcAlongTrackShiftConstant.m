function c4 = calcAlongTrackShiftConstant(rvOrb, meanMotion)

    c4 = rvOrb(1, :) - 2 * rvOrb(6, :) ./ meanMotion;

end
