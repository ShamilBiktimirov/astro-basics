function plotGroundTrack(rEcef)

    % Function plots satellite orbit ground track

    % Input:
    % rEcefArray 3xNpoint [m]

    % Output:
    % No ouput

    [azimuth, elevation, ~] = cart2sph(rEcef(1,:), rEcef(2,:), rEcef(3,:));

    fig = figure('NumberTitle', 'off', 'Name', 'Ground track plot');
    hold on;

    earth = imread('earthmap1k.jpg');
    image(earth, "XData", [-180 180], "YData", [90 -90]);

    plot(rad2deg(azimuth), rad2deg(elevation), 'ok', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'MarkerSize', 1);

    xticks([-180 -135 -90 -45 0 45 90 135 180]);
    xticklabels({'-180','-135','-90', '-45', '0', '45','90', '135', '180'});
    yticks([-90 -60 -30 0 30 60 90]);
    yticklabels(({'-90', '-60', '-30', '0', '30', 60', '90'}));

    ylim([-90 90]);
    xlim([-180 180]);

    yline(0, 'm', 'LineWidth', 1);

    xline([-180:15:180], 'color', [0.7, 0.7, 0.7], LineWidth=0.5);
    yline([-90:15:90], 'color', [0.7, 0.7, 0.7], LineWidth=0.5);

    xlabel('longitude \lambda, deg');
    ylabel('latitude \phi, deg');

    fontsize(fig, 24, "points");

end
