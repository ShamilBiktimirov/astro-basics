function aPerturbationArray = calc3dBodyPerturbation(rSat, r3dBody, mu3dBody)

    % Vectorized third-body perturbation

    % Input:
    % rSat - satellite position wrt to central body
    % r3dBody - third body object position wrt to central body
    % mu - third body gravitational parameter

    % Output:
    % aPerturbationArray - array of pertubations from third body

    % Note: make sure inputs have the same reference frame and units

    % r_sc, r_p are 3xN in km. mu in km^3/s^2. Output 3xN in km/s^2.

    rho = r3dBody - rSat;                     % 3xN
    rho_norm = vecnorm(rho, 2, 1);            % 1xN
    r3dBody_norm  = vecnorm(r3dBody,  2, 1);       % 1xN

    aPerturbationArray = mu3dBody * (rho./(rho_norm.^3) - r3dBody./(r3dBody_norm.^3));

end
