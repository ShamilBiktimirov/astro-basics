function qwhPrime =  rhsAngularMotionDynamicsWithRW(t, X, J, Jinv, Jrw, Arwa, rwAngAcc)

    % X = [q; omega; rwOmegaDot] - angular dynamics state, omega is projected to rotating body-fixed frame
    % J - inertia tensor
    % Jinv - inverse matrix of inertia tensor
    % rwAngAcc - angular accelerations of reaction wheels

    qw = X;
    rwOmegaArray = X(8:11);
    intertiaTensorInverse =  Jinv;

    % normalizing quaternion to avoid numerical errors, i.e. input quaternion is already supposed to be unit
    unitQuaternion = qw(1:4) / norm(qw(1:4));
    omegaB = qw(5:7);

    % Poisson equation for rigid body kinematics in case if angular velocity project to body-fixed frame
    quaternionDot  = 1 / 2 * quatmultiply(unitQuaternion', [0; omegaB]');

    if isempty(rwAngAcc)
        rwAngAcc = [0; 0; 0; 0]; % no rw control applied
    end

    hRwCurrent = Arwa * Jrw * rwOmegaArray;

    Mctrl = -Arwa * Jrw * rwAngAcc - cross(omegaB, hRwCurrent);

    angularVelocityDot = intertiaTensorInverse * (-cross(omegaB, J * omegaB) + Mctrl); % Euler equation

    % rwaAngVelDot = 1 / Lander.Jrw * Lander.ArwaInv * (-Mctrl - cross(omegaB, hRwCurrent));
    rwaAngVelDot = rwAngAcc;

    qwhPrime = [quaternionDot'; angularVelocityDot; rwaAngVelDot];

end
