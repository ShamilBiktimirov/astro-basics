function beta = calcBetaAngleGivenElevation(orbitRadius, elevation)

    % Reference: 
    % Biktimirov S., Satellite Formation Flying for Space Advertising:
    % From Technically Feasible to Economically Viable, Eq. 12

    gamma = asin(Consts.rEarth ./ orbitRadius .* cos(elevation));

    beta = pi / 2 - gamma - elevation;

end
