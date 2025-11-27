function [angDiameter fluxDensity] = sunAngularFlux(distance)

    % this function is to get sun angular resoultion and flux density at
    % the spacified distance

    % inputs:
    % distance: distance from the sun, m

    % outputs:
    % angDiameter: Sun angular diameter, rad 
    % fluxDensity: solar flux (irradiance) in W/m^2

    % Angular diameter, rad
    angDiameter = asin(Consts.rSun / distance) * 2;


    % curtis 12.9 Solar radiation pressure
    SoSun = 63.15e6; % radiated power intensity
    fluxDensity = SoSun * (Consts.rSun / distance)^2;

end
