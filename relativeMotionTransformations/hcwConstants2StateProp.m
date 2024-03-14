function rv = hcwConstants2StateProp(hcwConstants, n)

    % Vectorized
    % Notation for orbital reference frame: x - along track; y - out-of-plane; z - radial

    % x  = 3*c1*n*t + rho1 * cos(n*t + alpha1) + c4;
    % y  = rho2 * sin(n*t + alpha2);
    % z  = -2*c1 + rho1/2 * sin(n*t + alpha1);

    % vx = 3*c1*n - rho1 * n * sin(n*t + alpha1);
    % vy = rho2 * n * cos(n*t + alpha2);
    % vx = rho1/2 * n * cos(n*t + alpha1);

    % TODO: add constants via initial conditions
    % n - mean motion
    % assume t = 0

    % hcwConstants -[6, nSats]

    c1     = hcwConstants(1, :);
    rho1   = hcwConstants(2, :);
    rho2   = hcwConstants(3, :);
    c4     = hcwConstants(4, :);
    alpha1 = hcwConstants(5, :);
    alpha2 = hcwConstants(6, :);

    t = 0:0.1:6*pi/n;

    x  = 3 * c1 * n * t + ...
         rho1 .* cos(n*t + alpha1) + ...
         c4;

    y  = rho2 .* cos(n*t + alpha2);

    z  = -2 * c1 + ...
         rho1/2 .* sin(n*t + alpha1);


    vx = 3 * c1 * n - ...
         rho1 * n .* sin(n*t + alpha1);

    vy = rho2 * n .* sin(n*t + alpha2);

    vz = rho1/2 * n .* cos(n*t + alpha1);

    rv = [x; y; z; vx; vy; vz];

end