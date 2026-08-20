function plotAxes(origin, dcm, lineType)

    % The function builds a reference frame with origin and axes 
    % xyz axes have red greed blue

    % Input:
    % origin is a 3x1 vector given in arbitratry units
    % dcm is 3x3 matrix where each column is a reference axis projection to a main frame
    % lineType is a matlab linestyle set for reference frame axes

    hold on;
    pltOrigin = plot3(origin(1), origin(2), origin(3), 'ok');
    pltXaxis = quiver3(origin(1), origin(2), origin(3), dcm(1, 1), dcm(2, 1), dcm(3, 1), 'r', 'LineStyle', lineType, 'AutoScale','off', LineWidth=2);
    pltYaxis = quiver3(origin(1), origin(2), origin(3), dcm(1, 2), dcm(2, 2), dcm(3, 2), 'g', 'LineStyle', lineType, 'AutoScale','off', LineWidth=2);
    pltZaxis = quiver3(origin(1), origin(2), origin(3), dcm(1, 3), dcm(2, 3), dcm(3, 3), 'b', 'LineStyle', lineType, 'AutoScale','off', LineWidth=2);

end
