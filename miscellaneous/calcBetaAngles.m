function [betaAa, betaBeam] = calcBetaAngles(orbitRadius, spacecraft)

    % Function calculates included angles beta for satellite access area and footprint
    % ToDo: provide a description document in overleaf

    %% Finds access area considering minimum elevation constraint

    gammaAa   = asin(Consts.rEarth / orbitRadius * cos(spacecraft.elevationMin));
    betaAa     = pi/2 - gammaAa - spacecraft.elevationMin;

    %% Finds half beam angles considering limited satellite fov and nadir pointing

    syms x real positive
    % calculating critical angles

    rPoit2SatMin = orbitRadius - Consts.rEarth;
    rPoit2SatMax = sqrt(orbitRadius^2 - Consts.rEarth^2);

    rPoit2Sat    = double(solve(x^2 + orbitRadius^2 - 2 * orbitRadius * cos(spacecraft.instrumentFov) * x - Consts.rEarth^2, x));

    rPoit2Sat    = rPoit2Sat(find(rPoit2Sat >= rPoit2SatMin & rPoit2Sat <= rPoit2SatMax));

    betaBeam     = asin(double(rPoit2Sat) / Consts.rEarth * sin(spacecraft.instrumentFov));

    if betaBeam > betaAa
        error('footprint exceeding access area!');
    end

end
