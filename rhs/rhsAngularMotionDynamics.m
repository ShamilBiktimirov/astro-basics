function qwPrime = rhsAngularMotionDynamics(t, X, J, M_B)

    % X = [q; omega] - angular dynamics state, omega is projected to rotating body-fixed frame
    % J - inertia tensor
    % M_B - external torque, body-fixed frame

    qw = X;

    intertiaTensorInverse =  inv(J);

    % normalizing quaternion to avoid numerical errors, i.e. input quaternion is already supposed to be unit
    unitQuaternion = qw(1:4) / norm(qw(1:4));
    omegaB = qw(5:7);

    % Poisson equation for rigid body kinematics in case if angular velocity project to body-fixed frame
    quaternionDot  = 1 / 2 * quatmultiply(unitQuaternion', [0; omegaB]');

    if isempty(M_B)
        M_B = [0; 0; 0]; % no external torques are applied
    end

    angularVelocityDot = -intertiaTensorInverse * cross(omegaB, J * omegaB) + ...
                         intertiaTensorInverse * M_B; % Euler equation

    qwPrime = [quaternionDot'; angularVelocityDot];

end
