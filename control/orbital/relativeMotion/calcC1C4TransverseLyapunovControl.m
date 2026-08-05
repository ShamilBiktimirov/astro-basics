function controlVectorOrb = calcC1C4TransverseLyapunovControl(rvOrb, meanMotion, spacecraft)

    c1 = calcDriftConstant(rvOrb, meanMotion);
    c4 = calcAlongTrackShiftConstant(rvOrb, meanMotion);
    k1 = 5e-6;

    if abs(c1) > 0

        ux = k1 * c1 + 3 * meanMotion^2 * c4;

        if abs(ux) > spacecraft.maxThrust
            ux = 1e-5 * sign(ux);
        end

    else
        ux = 0;
    end

    controlVectorOrb = [ux; 0; 0];

end