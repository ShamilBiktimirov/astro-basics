function rv_chaser_ECI = orb2ECI(rv_target_ECI, rv_chaser_orb)

    oe_target = rv2oe(rv_target_ECI);
    mean_motion = sqrt(Consts.muEarth/oe_target(1)^3);

    % x - along track; y - out-of-plane; z - radial
    rv  = rv_target_ECI;
    z_orb = rv(1:3) / norm(rv(1:3));
    y_orb = cross(rv(1:3), rv(4:6));
    y_orb = y_orb(1:3) / norm(y_orb(1:3));
    x_orb = cross(y_orb, z_orb);

    n_columns = size(rv_chaser_orb,2);

    % Conversion matrix (orb2ECI)
    orb2ECI_matrix = [x_orb y_orb z_orb];

    rv_chaser_ECI = [rv(1:3)*ones(1,n_columns) + orb2ECI_matrix*rv_chaser_orb(1:3,:);...
                     rv(4:6)*ones(1,n_columns) + orb2ECI_matrix*(rv_chaser_orb(4:6,:) + cross([0;mean_motion;0]*ones(1,n_columns),rv_chaser_orb(1:3,:)))];

end