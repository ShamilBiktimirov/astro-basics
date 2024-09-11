function plotGroundTrackMultipleSatellites(rEcef, t0Jd)

    % Function plots satellite orbit ground track

    % Input:
    % rEcefArray 3 x Npoint x nSats [m]

    % Output:
    % No ouput

    fig = figure('NumberTitle', 'off', 'Name', 'Ground track plot');
    hold on;

    earth = imread('earthmap1k.jpg');
    image(earth, "XData", [-180 180], "YData", [90 -90]);

    for satIdx = 1:size(rEcef, 3)

        [azimuth, elevation, ~] = cart2sph(rEcef(1, :, satIdx), rEcef(2, :, satIdx), rEcef(3, :, satIdx));

        plot(rad2deg(azimuth), rad2deg(elevation), 'ok', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'MarkerSize', 2);
        plot(rad2deg(azimuth(1)), rad2deg(elevation(1)), 'og', 'MarkerEdgeColor', 'g', 'MarkerFaceColor', 'g', 'MarkerSize', 5);
        plot(rad2deg(azimuth(end)), rad2deg(elevation(end)), 'or', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', 'MarkerSize', 5);

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
        % legend('ground track', 'start', 'end');
        fontsize(fig, 24, "points");

    end

    [~, sunAzimuth, sunElev] = sun(t0Jd);
    plot(rad2deg(wrapToPiCustom(sunAzimuth)), rad2deg(sunElev), 'oy', 'MarkerEdgeColor', 'y', 'MarkerFaceColor', 'y', 'MarkerSize', 10);


end
