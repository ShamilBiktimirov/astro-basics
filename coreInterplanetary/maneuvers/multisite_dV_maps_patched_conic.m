function dV_maps = multisite_dV_maps_patched_conic(oe_table, input)

    oe_colony = oe_table(1,:); % the first body in 
    h = waitbar(0, 'Calculating transfer list...');
    for i = 1:input.n_mining_sites

        % forward transfers
        oe_mining_site = oe_table(i+1,:);
        dV_map = calculate_dV_map_patched_conic(oe_colony, oe_mining_site, input);
        dV_maps{i} = dV_map;

        waitbar((2*i-1)/(2*input.n_mining_sites));

        % backward transfers
        dV_map = calculate_dV_map_patched_conic(oe_mining_site, oe_colony, input);
        dV_maps{input.n_mining_sites + i} = dV_map;
        waitbar((2*i)/(2*input.n_mining_sites));

    end
    close(h);
end
