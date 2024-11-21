function transfers = calculate_transfer_list(dV_map, input)

    raw_transfer_list = mins(dV_map, input.dV_max); % finds local minima

    LD_vec = (1:input.LD_dt:input.Modeling_time) + input.Modeling_Start;
    LD_vec = LD_vec(:) - Consts.delta_mjd;
    TOF_vec = input.min_TOF:input.TOF_dt:input.max_TOF;

    len = size(raw_transfer_list, 1);
    transfers = zeros(len, 3);

        for k = 1:len
            i = raw_transfer_list(k, 1);
            j = raw_transfer_list(k, 2);
            transfers(k, 1) = LD_vec(i);
            transfers(k, 2) = TOF_vec(j);
            transfers(k, 3) = dV_map(i,j);
        end

end
