function sF = calcFundamentalGroundTrackInterval(oe)

    % orbit is assumed as circular

    [raanDot, ~, ~] = calcSecularPrecessionRates(oe(1, :), zeros(1, size(oe, 2)), oe(3, :));
    periodNodal     = calcDraconicPeriod([oe(1, :); zeros(1, size(oe, 2)); oe(3, :)]);

    sF = (Consts.omegaEarth - raanDot) .* periodNodal; % fundamental interval, radians

end
