function rvPrime = rhsFormationInertial(t, rv, controlVector, spacecraft)

    % rhs for N satellites orbital motion dynamics in ECI frame

    % input:
    % rv            [nSats * 6, 1], [m, m/s]
    % controlVector [nSats * 3, 1], [N] in ECI frame
    % spacecraft    a structure with spacecraft parameters

    % Orbital motion dynamics models:
    % 'point mass'                  - motion in central gravity field
    % 'atmosphericDragAndLift'      - central gravity + atmo drag and lift force
    % 'atmosphericDrag'             - central gravity + atmo drag
    % 'J2'                          - central gravity + J2 effect
    % 'J2 + atmosphericDragAndLift' - central gravity + J2 effect + atmo drag and lift force

    global environment

    nSats  = length(rv) / 6;
    rv     = reshape(rv, [6, nSats]);

    rPrime = [rv(4:6, :); zeros(3, nSats)];
    rNorm  = vecnorm(rv(1:3, :));

    % Central gravity field
    accelerationCg = [zeros(3, nSats); -Consts.muEarth ./ (rNorm.^3) .* rv(1:3, :)];

    % rhs for two-body problem
    rvPrime = rPrime + accelerationCg;

    switch environment
        case 'point mass'

            perturbations = zeros(6, nSats);

        case 'J2'

            accelerationJ2  = [zeros(3, nSats); ...
                               j2PerturbationAcceleration(rv)];

            perturbations = accelerationJ2;

         case 'atmosphericDrag'
            % проверить векторизацию
            vRelativeECI = rv(4:6,:) - cross(ones(1, nSats) .* Consts.wEarth, rv(1:3,:));
            rhoAtmo = CIRA72(vecnorm(rv(1:3,:)) - Consts.rEarth);
            accelerationAtmosphericDrag = - 0.5 * spacecraft.Cdrag * spacecraft.dragArea / ...
                                            spacecraft.mass * rhoAtmo .* vRelativeECI .* vecnorm(vRelativeECI);

            accelerationAtmosphericDrag = [zeros(3, nSats); accelerationAtmosphericDrag];

            perturbations = accelerationAtmosphericDrag;

       case 'atmosphericDragAndLift'

            accelerationAdl = [zeros(3, nSats); ...
                               atmosphericDragAndLiftAcceleration(rv, spacecraft.anglesRequired, spacecraft)];

            perturbations = accelerationAdl;


        case 'J2 + atmosphericDragAndLift'

            accelerationJ2  = [zeros(3, nSats); ...
                               j2PerturbationAcceleration(rv)];

            accelerationAdl = [zeros(3, nSats); ...
                               atmosphericDragAndLiftAcceleration(rv, spacecraft.anglesRequired, spacecraft)];

            perturbations = accelerationJ2 + accelerationAdl;

    end

    if ~isempty(controlVector)
        % Add controlInput if it is passed to the rhs
        controlVector = [zeros(3, nSats); reshape(controlVector, [3, nSats])];

        rvPrime = reshape(rvPrime + perturbations + controlVector, [6 * nSats, 1]);
    else
        rvPrime = reshape(rvPrime + perturbations, [6 * nSats, 1]);
    end

end
