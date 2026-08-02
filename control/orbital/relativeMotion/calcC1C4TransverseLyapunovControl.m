function controlVector = calcC1C4TransverseLyapunovControl(rvOrb, meanMotion)

    c1 = calcDriftConstant(rvOrb, meanMotion);
    c4 = calcAlongTrackShiftConstant(rvOrb, meanMotion);
    k1 = 5e-6;
    % k1 = 1e-3;

    if abs(c1) > 0

        ux = k1 * c1 + 3 * meanMotion^2 * c4;

        % if abs(ux) > 1e-5
        %     ux = 1e-5 * sign(ux);
        % end

    else
        ux = 0;
    end


    controlVector = [ux; 0; 0];

end