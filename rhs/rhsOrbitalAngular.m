function stateVectorPrime = rhsOrbitalAngular(t, stateVector, controlTorque, spacecraft, planetGp, planetR)

    % input:
    % stateVector   [nSats * 13, 1], [m, m/s]
    % stateVector = [r; v; q; omega]

    % controlTorqueVector [nSats * 3, 1], [N*m], Body frame 

    % spacecraft is a structure with spacecraft parameters

    rv = stateVector(1:6);
    qw = stateVector(7:end);

    intertiaTensorInverse =  inv(spacecraft.inertiaTensor);

    unitQuaternion = qw(1:4) / norm(qw(1:4)); % normalize quaternion

    quaternionDot  = 1 / 2 * quatmultiply(unitQuaternion', [0; qw(5:7)]'); % Poisson equation

    angularVelocityDot = -intertiaTensorInverse * cross(qw(5:7), spacecraft.inertiaTensor * qw(5:7)) + ...
                         intertiaTensorInverse * controlTorque; % Eulear equation

    qwPrime = [quaternionDot'; angularVelocityDot];

    % rhs for two-body problem
    rvPrime = rhsOrbitalMotionLander(t, rv, planetGp, planetR);

    stateVectorPrime = [rvPrime; qwPrime];

end