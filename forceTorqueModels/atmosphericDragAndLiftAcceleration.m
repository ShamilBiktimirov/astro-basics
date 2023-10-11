function atmosphericDragAndLiftAcceleration = atmosphericDragAndLiftAcceleration(rv, angles, spacecraft)

    % The function computes aerodynamic drag and lift force for a given
    % spacecraft attitude defined by unit quaternion 

    % The function is vectorized

    % Reference:
    % Ivanov, D., Kushniruk, M. and Ovchinnikov, M., 2018.
    % Study of satellite formation flying control using differential lift and drag.
    % Acta Astronautica, 152, pp.88-100.

    % input:

    % rv         - spacecraft state vector given in ECI frame, [6, nSats], [m, m/s]
    % spacecraft - structure containing various spacecraft parameters
    %                 - .epsilon, .eta are drag and lift dimensionless coefficients
    %                 - .angles = [theta, phi] defines sat's plane normal attitude, [rad],
    %                   theta = [0 : pi/2], phi = [0 : 2*pi]

    % output:

    % aDiffDrag [3, nSats]


    nSats = size(rv, 2);

    theta = angles(1, :);
    phi   = angles(2, :);
    
    rhoAtmo = CIRA72((vecnorm(rv(1:3, :)) - Consts.rEarth));
    relativeVelocityMagnitude = vecnorm(rv(4:6, :) - cross(repmat(Consts.wEarth, 1, nSats), rv(1:3, :))); % relative to the incoming airflow

    kDrag   = 0.5 / spacecraft.mass *  rhoAtmo .* relativeVelocityMagnitude.^2 * spacecraft.area; % assuming identical satellites

    p       = -2 * spacecraft.epsilon * sin(theta).^3 + ...
              spacecraft.eta * (spacecraft.epsilon - 1) .* sin(theta).^2 + ...
              (spacecraft.epsilon - 1) .* sin(theta);

    g       = -cos(theta) .* sin(theta) .* ...
              (spacecraft.eta * (1 - spacecraft.epsilon) + 2 * spacecraft.epsilon * sin(theta));

    atmosphericDragAndLiftAcceleration = kDrag .* [p; g .* cos(phi); g .* sin(phi)];

    % consider orbital reference frame of leader owing to the small ISD
    eZOrbRf = rv(1:3, 1) / norm(rv(1:3, 1));
    eYOrbRf = cross(rv(1:3, 1), rv(4:6, 1)) ./ norm(cross(rv(1:3, 1), rv(4:6, 1)));
    eXOrbRf = cross(eYOrbRf, eZOrbRf) ./ vecnorm(cross(eYOrbRf, eZOrbRf));

    rotationMatrix = [eXOrbRf, eYOrbRf, eZOrbRf];

   atmosphericDragAndLiftAcceleration =  rotationMatrix * atmosphericDragAndLiftAcceleration;

end
