function [lat, lon] = calcUniformGridLatLon(gridResolution)

    epsilon = 0.5; % grid building tuning parameter to avoid singularities at the poles

    nNodes  = 16 * Consts.rEarth^2 / gridResolution^2;

    nodesIdxArray = 1 : nNodes;

    yArray = (nodesIdxArray + epsilon) ./ (nNodes - 1 + 2 * epsilon);
    xArray = mod(nodesIdxArray / Consts.goldenRatio, 1);

    lat = acos(1 - 2 * xArray);
    lon = 2 * pi * yArray;

end
