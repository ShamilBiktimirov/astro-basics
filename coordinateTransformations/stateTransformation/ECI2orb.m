function rvChaserOrb = ECI2orb(rvTargetEci, rvChaserEci)

    % Function converts satellite state vector (translational motion)
    % between inertial ECI frame and non inertial orbital reference frame
    % x - along track; y - out-of-plane; z - radial

    % rotation matrix notation: rv^I = A^(I2O) * rv^O
    %                           rv^O = A^(O2I) * rv^I
    % Input:
    % rvTargetEci - [6, tArrayLength]
    % rvChaserEci - [6, tArrayLength]

    % Output:
    % rvChaserOrb - [6, tArrayLength]

    % h = [r, v] = r^2 * phi'
    angularMomentumSpecific = norm(cross(rvTargetEci(1:3), rvTargetEci(4:6)));
    tangentialVelocity = angularMomentumSpecific / norm(rvTargetEci(1:3))^2;

    rotationMatrixI2O = orb2EciMatrix(rvTargetEci);
    rotationMatrixO2I = permute(rotationMatrixI2O, [2, 1, 3]);

    for timeIdx = 1:size(rvTargetEci, 2)

        r_chaser_orb = rotationMatrixO2I(:, :, timeIdx) * (rvChaserEci(1:3, timeIdx) - rvTargetEci(1:3, timeIdx));
        v_chaser_orb = rotationMatrixO2I(:, :, timeIdx) * (rvChaserEci(4:6, timeIdx) - rvTargetEci(4:6, timeIdx)) -  cross([0; tangentialVelocity; 0], r_chaser_orb);

        rvChaserOrb(:, timeIdx) = [r_chaser_orb; v_chaser_orb];
    end

end
