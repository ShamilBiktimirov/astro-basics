function plot_dV_map(dV_matrix, input, dV_threshold)

    % The function plot a dV map for transfer

    LD = 1:input.LD_dt:input.Modeling_time;
    LD = LD(:) + input.Modeling_Start - Consts.delta_mjd;

    TOF = input.min_TOF:input.TOF_dt:input.max_TOF;

    if ~isnan(dV_threshold)
        for i = 1:length(LD)
            for j = 1:length(TOF)
                if dV_matrix(i,j) > dV_threshold
                    dV_matrix(i,j) = NaN;
                end
            end
        end
    end

    fig1 = figure;
    contour(LD, TOF, dV_matrix', 'fill', 'on');
    c = colorbar;
    c.Label.String = ('dV, km/s');
    grid on;
    title('Delta-V map');
    xlabel('Launch date');
    ylabel('Time of Flight, days');

    xtickNew = LD(round(linspace(1, length(LD), 10)));
    xticklabels(string(datetime(xtickNew + Consts.delta_mjd, 'ConvertFrom', 'juliandate')));
    fontsize(fig1, 24, "points");

end
