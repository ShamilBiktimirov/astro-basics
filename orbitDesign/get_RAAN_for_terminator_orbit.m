function RAAN = get_RAAN_for_terminator_orbit(orbit_epoch)

    % ref Biktimirov et.al., A satellite formation to display pixel images from the sky: mission design and control algorithms
    % Input - Julian date of the orbit epoch
    % Output - RAAN [0 2pi], [deg]
    orbit_epoch_JD = juliandate(orbit_epoch);

    R_sun_unit_initial =  sun(orbit_epoch_JD)'/vecnorm(sun(orbit_epoch_JD));

    e_z = [0; 0; 1];
    node_vector = cross(e_z, R_sun_unit_initial)./ vecnorm(cross(e_z, R_sun_unit_initial));
    RAAN = atan2(node_vector(2), node_vector(1));

    if RAAN < 0
        RAAN = 2*pi + RAAN;
    end
    
end

