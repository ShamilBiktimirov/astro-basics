function [dVmapTotal, dVmapDeparture, dVmapArrival] = calculate_dV_excess_map_patched_conic(oe1, oe2, input)

    LD_vec = 1:input.LD_dt:input.Modeling_time;

    TOF_vec = input.min_TOF:input.TOF_dt:input.max_TOF;
    length_LD_vec = length(LD_vec);
    length_TOF_vec = length(TOF_vec);
    dVmapTotal = zeros(length_LD_vec, length_TOF_vec);
    dVmapDeparture = zeros(length_LD_vec, length_TOF_vec);
    dVmapArrival = zeros(length_LD_vec, length_TOF_vec);

    for i = 1:length_LD_vec

        % departure state
        tw = LD_vec(i);
        [r1, v1] = oe2xyz(oe1, Consts.muSun / 1e9, tw);

        for j = 1:length_TOF_vec

            % arrival state
            tt = TOF_vec(j);
            [r2, v2] = oe2xyz(oe2, Consts.muSun / 1e9, tw + tt);
            % transfer calculation

            % satellite orbit revolutions number during transfer
            if input.MaximumRevolutionsNumber == 0
                m = 0;
            elseif input.MaximumRevolutionsNumber > 0
                m = 0:input.MaximumRevolutionsNumber;
            else
                error('Improper number of revolutions for Lamberts problem');
            end

            for q = 1:length(m)

                [v1_tr, v2_tr, ~]           = lambert(r1, r2, tt, m(q), Consts.muSun / 1e9);
                [v1_tr_retr, v2_tr_retr, ~] = lambert(r1, r2, -tt, m(q),  Consts.muSun / 1e9);

                dv_departure = vecnorm(v1_tr - v1);
                dv_arrival   = vecnorm(v2_tr - v2);

                dv_departure_retr = vecnorm(v1_tr_retr - v1);
                dv_arrival_retr   = vecnorm(v2_tr_retr - v2);

                if dv_departure + dv_arrival < dv_departure_retr + dv_arrival_retr
                    dv1(q) = dv_departure;
                    dv2(q) = dv_arrival;
                else
                    dv1(q) = dv_departure_retr;
                    dv2(q) = dv_arrival_retr;
                end
            end

            % InjectionDV = sqrt(dv1.^2 + 2*oe1(8)/(oe1(9)+oe1(10))) - sqrt(oe1(8)/(oe1(9)+oe1(10)));
            % InsertionDV = sqrt(dv2.^2 + 2*oe2(8)/(oe2(9)+oe2(10))) - sqrt(oe2(8)/(oe2(9)+oe2(10)));
            % finding the least propellant consumsing transfer trajectory
            [~, bestSolutionIdx] = min(dv1 + dv2);

            dVmapTotal(i, j)     = dv1(bestSolutionIdx) + dv2(bestSolutionIdx);
            dVmapDeparture(i, j) = dv1(bestSolutionIdx);
            dVmapArrival(i, j)   = dv2(bestSolutionIdx);

        end
    end
end
