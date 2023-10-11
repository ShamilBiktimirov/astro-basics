function transformationMatrix = orb2EciMatrix(rv)

    % The function calculates a transormation matrix between ECI and orbital frame 
    % such that rECI = transformationMatrix * rOrb

    % Input
    % orbital motion state vector rv [6, nSats]

    % Output
    % transformaitonMatrix [3, 3, nSats]

    nSats = size(rv, 2);

    eZOrbRf = rv(1:3, :) ./ repmat(vecnorm(rv(1:3, :)), [3, 1]);
    eYOrbRf = cross(rv(1:3, :), rv(4:6, :)) ./ repmat(vecnorm(cross(rv(1:3, :), rv(4:6, :))), [3, 1]);
    eXOrbRf = cross(eYOrbRf, eZOrbRf) ./ repmat(vecnorm(cross(eYOrbRf, eZOrbRf)), [3, 1]);

    transformationMatrix(:, 1, :) = eXOrbRf;
    transformationMatrix(:, 2, :) = eYOrbRf;
    transformationMatrix(:, 3, :) = eZOrbRf;

end
