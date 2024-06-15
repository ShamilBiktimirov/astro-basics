function [transfers, dV_maps] = multisite_transfer_list_lambert_single_revolution(oe_table, input)
    oe_colony = oe_table(1,:); % the first body in the table 
    h = waitbar(0, 'Calculating transfer list...');
    for i = 1:input.n_mining_sites   
        
        oe_mining_site = oe_table(i+1,:);
        
        % forward transfers
        dV_map = calculate_dV_map_lambert_single_revolution(oe_colony, oe_mining_site, input);
        transfers{i} = calculate_transfer_list(dV_map,input);
        dV_maps{i} = dV_map;
        
        waitbar((2*i-1)/(2*input.n_mining_sites));

        % backward transfers        
        dV_map = calculate_dV_map_lambert_single_revolution(oe_mining_site, oe_colony, input);
        transfers{input.n_mining_sites + i} = calculate_transfer_list(dV_map,input);
        dV_maps{input.n_mining_sites + i} = dV_map;
        waitbar((2*i)/(2*input.n_mining_sites));
    
    end
    close(h);
end

