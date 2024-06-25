function dV_map = calculate_dV_map_lambert_single_revolution(oe1, oe2, input)

    global muSun
    
    LD_vec = 1:input.LD_dt:input.Modeling_time;

    TOF_vec = input.min_TOF:input.TOF_dt:input.max_TOF;
    length_LD_vec = length(LD_vec);
    length_TOF_vec = length(TOF_vec);
    dV_map = zeros(length_LD_vec, length_TOF_vec);
    for i = 1:length_LD_vec
        % departure state
        tw = LD_vec(i);
        [r1, v1] = oe2xyz(oe1, muSun, tw);
        for j = 1:length_TOF_vec
            % arrival state
            tt = TOF_vec(j);
            [r2, v2] = oe2xyz(oe2, muSun, tw + tt);
            % transfer calculation
            
            m = 0;
            [v1_tr, v2_tr, ~] = lambert(r1, r2, tt, m, muSun);
                
            
            in_orbit_norm = cross(r1,v1);
            transfer_normal = cross(r1,v1_tr);
            angle_between_normal = abs(dot(in_orbit_norm, transfer_normal)/vecnorm(in_orbit_norm)/vecnorm(transfer_normal));
 
            if angle_between_normal > pi/2
                 [v1_tr, v2_tr, ~] = lambert(r1, r2, -tt, m,  muSun);
            end
         
            dv_departure = vecnorm(v1_tr - v1);
            dv_arrival = vecnorm(v2_tr - v2);
                         
            dV_total = dv_departure + dv_arrival;
%              dV_total = dv_arrival;
            
            dV_map(i,j) = dV_total;
        end
    end    
end