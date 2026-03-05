function aPerturbationArray = calc3dBodyPerturbation(rSat, r3rdBody, mu3rdBody)

    % Vectorized third-body perturbation

    % Input:
    % rSat - satellite position wrt to central body
    % r3dBody - third body object position wrt to central body
    % mu3rdBody - third body gravitational parameter

    % Output:
    % aPerturbationArray - array of pertubations from third body

    % Note: make sure inputs have the same reference frame and units

    % rSat, r3rdBody are 3xN in km. mu in km^3/s^2. Output 3xN in km/s^2.

    rho = r3rdBody - rSat;                     % 3xN
    rho_norm = vecnorm(rho, 2, 1);            % 1xN
    r3dBody_norm  = vecnorm(r3rdBody,  2, 1);       % 1xN

    aPerturbationArray = mu3rdBody * (rho./(rho_norm.^3) - r3rdBody./(r3dBody_norm.^3));

end
