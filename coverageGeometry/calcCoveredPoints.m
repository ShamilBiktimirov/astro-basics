function coveredPoints = calcCoveredPoints(rSat, rPOI, betaAngle)

    % Function finds a set of nodes on Earth located within area bounded by betaAngles
    % ToDo: provide a description document in overleaf

    % Input:
    % - rSat [3, n], an array of satellite position vectors
    % - rPOI [3, m], an array of position vectors for points of interest (POI)
    % - betaAngle, rad, included angle for circular FOV coverage check

    % Output:
    % coveredPoints [m, 1] - logical vector of covered points

    ePoiArray  = rPOI;

    eSat = rSat ./ repmat(vecnorm(rSat, 2, 1), [3, 1]);
    eSat = reshape(eSat, [size(eSat, 1), 1, size(eSat, 2)]);

    ePoiArray3D = repmat(ePoiArray, [1, 1, size(eSat, 3)]);
    eSatArray3D = repmat(eSat, [1, size(rPOI, 2), 1]);

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
