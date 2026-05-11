function rvPrime = rhsFormationHCW(t, rvOrb, controlVector, meanMotion)

    % right hand side for ordinary differential equations for
    % linearized relative motion dynamics (HCW equations)

    % ex - transverse
    % ey - out-of-plane
    % ez - local vertical

    rvPrime = [rvOrb(4); rvOrb(5); rvOrb(6);
               -2 * meanMotion * rvOrb(6);
               -meanMotion^2 * rvOrb(2);
               2 * meanMotion * rvOrb(4) + 3 * meanMotion^2 * rvOrb(3)];

    if ~isempty(controlVector)
        rvPrime(4:6, 1) = rvPrime(4:6) + controlVector;
    end

end
