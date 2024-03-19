function [c1, c4, rho1, rho2, alpha1, alpha2] = orbState2HcwConstants(rvOrb, meanMotion)

    % Vectorized function to calculated hcw equations solution constants
    % based on the relative motion state

    % Input:
    % rvOrb - [6, tArray] or [6, nSats]
    % meanMotion - scalar

    % Output:
    % hcwConstants - [6, tArray] or [6, nSats]
    % hcwConstant(:, 1) = [c1; c4; rho1; rho2; alpa1; alpha2]

    c1 = -2 * rvOrb(3, :) - 1 / meanMotion * rvOrb(4, :);
    c2 = rvOrb(6, :) / meanMotion;
    c3 = -3 * rvOrb(3, :) - 2 / meanMotion * rvOrb(4, :);
    c4 = rvOrb(1, :) - 2 / meanMotion * rvOrb(6, :);
    c5 = rvOrb(5, :) / meanMotion;
    c6 = rvOrb(2, :);

    rho1 = 2 * sqrt(c2.^2 + c3.^2);
    rho2 = sqrt(c5.^2 + c6.^2);
    alpha1 = atan2(c3, c2);
    alpha2 = atan2(c6, c5);
    
end
