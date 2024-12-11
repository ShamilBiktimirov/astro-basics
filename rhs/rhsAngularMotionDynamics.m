function Xdot = rhsAngularMotionDynamics(t, X, J, M)

    % X = [q; omega] - angular dynamics state
    % J - inertia tensor
    % External torque 

    q = X(1:4);
    omega = X(5:7);

    if isempty(M)
        M = [0; 0; 0]; % no external torques are applied
    end

    qDot = 1 / 2 * quaternionMultiply([0; omega], q); % Poisson's equation describing kinematics
    omegaDot = inv(J) * (M - cross(omega, J * omega));% Euler's equation describing dynamics

    Xdot = [qDot; omegaDot];

end
