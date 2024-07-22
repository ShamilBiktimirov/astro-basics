function RAAN = calcRaanDuskDawn(orbitEpoch)

    % ref Biktimirov et.al., A satellite formation to display pixel images from the sky: mission design and control algorithms
    % Input - Julian date of the orbit epoch
    % Output - RAAN [0 2pi], [deg]

    orbitEpochJd = juliandate(orbitEpoch);

    eSun = sun(orbitEpochJd)' / vecnorm(sun(orbitEpochJd));
    eZ = [0; 0; 1];

    nodeVector = cross(eZ, eSun)./ vecnorm(cross(eZ, eSun));
    RAAN = atan2(nodeVector(2), nodeVector(1));

    if RAAN < 0
        RAAN = 2 * pi + RAAN;
    end

end
