function stateVectorPrime = rhsOrbitalAngular(t, stateVector, controlTorque, spacecraft, planetGp)

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

    rPrime = [rv(4:6); 0;0;0];
    rNorm  = vecnorm(rv(1:3));

    % Central gravity field
    accelerationCg = [zeros(3, 1); -planetGp ./ (rNorm.^3) .* rv(1:3)];

    % rhs for two-body problem
    rvPrime = rPrime + accelerationCg;

    stateVectorPrime = [rvPrime; qwPrime];

end
