function iSuperPolar = calcSuperPolarOrbitInclination(sma)

    global sma

    % Function calculates inclination of super polar orbit* - the orbit with apparent inclination of 90
    % circular orbit case is considered

    % Input:
    % sma, m

    % Output:
    % iSuperPolar, rad

    iLeft = deg2rad(70);
    iRight = deg2rad(110);

    f = @fSuperPolarOrbit;

    iSuperPolar = bisection_method(f, iLeft, iRight);

    assert(abs(calcApparentInclination([sma; 0; iSuperPolar; 0; 0; 0]) - pi/2) < 1e-10, "Super Polar orbit is not calculated correctly");

    function error = fSuperPolarOrbit(i)

       iApparent =  calcApparentInclination([sma; 0; i; 0; 0; 0]);
       error = iApparent - pi/2;

    end

end
