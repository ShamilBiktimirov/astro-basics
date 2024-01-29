function [latAarray, lonArray] = calcUniformGridLatLon(gridResolution)

    % Algorithm generates lat, lon for spherical Fibonnaci grid/lattice
    % The more details available at https://www.overleaf.com/read/hsjtzhnncmfw#71ff51

    % Input: grid resolution
    % - gridResolution, m

    % Output: points spherical coordinates
    % - latArray, rad
    % - lonArray, rad

    epsilon = 0.5; % grid building tuning parameter to avoid singularities at the poles

    nNodes  = round(16 * Consts.rEarth^2 / gridResolution^2);

    nodesIdxArray = 1 : nNodes;

    % square lattice coordinates
    xArray = mod((nodesIdxArray - 1) / Consts.goldenRatio, 1);
    yArray = (nodesIdxArray - 1 + epsilon) ./ (nNodes + 2 * epsilon);

    latAarray = pi / 2 - acos(1 - 2 * xArray);
    lonArray = 2 * pi * yArray;

end
