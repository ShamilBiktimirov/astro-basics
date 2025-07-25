function qwPrime = rhsAngularMotionDynamics(t, X, J, M)

    % X = [q; omega] - angular dynamics state
    % J - inertia tensor
    % M - external torque

    qw = X;

    intertiaTensorInverse =  inv(J);

    unitQuaternion = qw(1:4) / norm(qw(1:4)); % normalize quaternion

    if isempty(M)
        M = [0; 0; 0]; % no external torques are applied
    end 

    quaternionDot  = 1 / 2 * quatmultiply(unitQuaternion', [0; qw(5:7)]'); % Poisson equation

    angularVelocityDot = -intertiaTensorInverse * cross(qw(5:7), J * qw(5:7)) + ...
                         intertiaTensorInverse * M; % Euler equation

    qwPrime = [quaternionDot'; angularVelocityDot];


end
