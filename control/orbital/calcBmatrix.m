function B = calcBmatrix(oe)

    % Function calculates control influence matrix B for a set of classical
    % orbital elements based on Gauss variational equations

    % Input:
    % oe = [a; e; i; RAAN; AOP; TA]

    % Output:
    % B matrix 6x3, for u = [u_{\theta}, u_h, u_{\rho}]
    % relates influence of thrust acceleration on set of orbital elements:
    % [a, i, e, RAAN, AOP, MA]

    % Notes:
    % 1. Matrix has been normalized for semi-major axis
    % 2. The matrix doesn't mind to calc B for either osc or mean orbital elements
    % 3. The matrix has slightly different representation depending on LVLH frame notations

    a = oe(1);
    e = oe(2);
    i = oe(3);

    f = oe(6);
    theta = oe(5) + oe(6);

    p = a * (1 - e^2);
    h = sqrt(p * Consts.muEarth);
    r = calcOrbitRadius(oe);
    eta = sqrt(1 - e^2);

    B(1, :) = [2 * a^2 * e * sin(f) / h / Consts.rEarth, 2 * a^2 * p / h / r / Consts.rEarth, 0];

    B(2, :) = [p * sin(f) / h, ((p + r) * cos(f) + r * e)  / h, 0];

    B(3, :) = [0, 0, r * cos(theta) / h];

    B(4, :) = [0, 0, r * sin(theta) / h / sin(i)];

    B(5, :) = [-p * cos(f) / h / e, (p + r) * sin(f) / h / e, - r * sin(theta) * cos(i) / h / sin(i)];

    B(6, :) = [eta * (p * cos(f) - 2 * r * e) / h / e, - eta * (p + r) * sin(f) / h / e, 0];

    B = [B(:, 2:3), B(:, 1)];

end
