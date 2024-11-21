function oe = oe_update(oes_ep, Modeling_Start)

    % The function updates mean anomaly according to specific date

	oe = oes_ep(:, 1:10);

    for i = 1:size(oe, 1)

        n = sqrt(Consts.muSun / 1e9 / oe(i, 1) ^ 3);
        M_new = oe(i,6) + n * 86400 * (Modeling_Start - oes_ep(i, 7)) / Consts.deg2rad;
        oe(i, 6) = mod(M_new, 360);

    end

end
