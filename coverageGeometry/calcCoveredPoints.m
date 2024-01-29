function coveredPoints = calcCoveredPoints(rEcef, earthGrid, betaAngle)

    % Function finds a set of nodes on Earth located within area bounded by betaAngles
    % ToDo: provide a description document in overleaf

    % Input:
    % rEcef [3, n]
    % earthGrid [3, m]

    % Output:
    % coveredPoints [m, 1] - logical vectoral of covered points

    ePoiArray  = earthGrid;

    eSat = rEcef ./ repmat(vecnorm(rEcef, 2, 1), [3, 1]);
    eSat = reshape(eSat, [size(eSat, 1), 1, size(eSat, 2)]);

    ePoiArray3D = repmat(ePoiArray, [1, 1, size(eSat, 3)]);
    eSatArray3D = repmat(eSat, [1, size(earthGrid, 2), 1]);

    coveredPointsMatrix = squeeze(dot(ePoiArray3D, eSatArray3D, 1)) >= cos(betaAngle);

    if min(size(coveredPointsMatrix)) ~= 1

        coveredPoints       = any(coveredPointsMatrix, 2);

        if ~iscolumn(coveredPoints)
            coveredPoints = coveredPoints';
        end

    else
        coveredPoints = coveredPointsMatrix;

        if ~iscolumn(coveredPointsMatrix)
            coveredPointsMatrix = coveredPointsMatrix';
        end

    end

end
