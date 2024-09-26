function dV_map = calculate_dV_map_lambert_multiple_revolutions(oe1, oe2, input)

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
            
            m = 0:10;
            
            for q = 1:length(m)
                
                [v1_tr, v2_tr, ~] = lambert(r1, r2, tt, m(q), muSun);
                [v1_tr_retr, v2_tr_retr, ~] = lambert(r1, r2, -tt, m(q),  muSun);
                
                dv_departure = vecnorm(v1_tr - v1);
                dv_arrival = vecnorm(v2_tr - v2);

                dv_departure_retr = vecnorm(v1_tr_retr - v1);
                dv_arrival_retr = vecnorm(v2_tr_retr - v2);
                
                if dv_departure + dv_arrival < dv_departure_retr + dv_arrival_retr
                    dV_total(q) = dv_departure + dv_arrival; 
                else
                    dV_total(q) = dv_departure_retr + dv_arrival_retr;
                end
                
            end
            
                     
            dV_map(i,j) = min(dV_total);
        end
    end
end