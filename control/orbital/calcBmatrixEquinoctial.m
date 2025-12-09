function B = calcBmatrixEquinoctial(oe)

    % Function calculates control influence matrix B for a set of classical
    % orbital elements based on Gauss variational equations

    % Input:
    % oe = [a; q1; q2; i; RAAN; lambda]

    % Output:
    % B matrix 6x3, for u = [u_{\theta}, u_h, u_{\rho}]
    % relates influence of thrust acceleration on set of orbital elements:
    % [a; q1; q2; i; RAAN, lambda]

    % Notes:
    % 1. Matrix has been normalized for semi-major axis
    % 2. The matrix doesn't mind to calc B for either osc or mean orbital elements
    % 3. The matrix has slightly different representation depending on LVLH frame notations

    a = oe(1);
    i = oe(3);
    theta = oe(6); % because lambda and theta are pretty close, though it's to be considered

    gamma = sqrt(a / Consts.muEarth);
    n = sqrt(Consts.muEarth / a^3);

    % u = [u_theta; u_h; u_rho]

    B(1, :) = [2 / n, 0, 0]; % da 

    B(2, :) = [2 * gamma * cos(theta); 0; gamma * sin(theta)]; % dq1

    B(3, :) = [2 * gamma * sin(theta); 0; -gamma * cos(theta)]; % dq2

    B(4, :) = [0; gamma * cos(theta); 0]; % di

    B(5, :) = [0; gamma * sin(theta) / sin(i) ;0]; % dRAAN

    B(6, :) = [0; -gamma * cot(i) * sin(theta); -2 * gamma]; % dlambda

end
