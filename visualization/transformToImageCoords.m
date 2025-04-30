function [azTildaDeg, elevTildaDeg] = transformToImageCoords(az, elev, imageHeightPixels, imageWidthPixels)

    % flip y axis to make it in image reference frame
    elev = -elev;

    % converting azimuth and elevation to from rad to deg
    azDeg = az * 180 / pi;
    elevDeg = elev * 180 / pi;

    % transform reference frame origin of satellite sph coord to image reference frame
    azDeg = azDeg + 180;
    elevDeg = elevDeg + 90;

    % bring coordinates to range from [0, imageHeighPixels] & [0, imageWidthPixels]
    % and scale the coordinates
    azTildaDeg = rem(azDeg, imageWidthPixels) * imageWidthPixels / 360;
    elevTildaDeg = rem(elevDeg, imageHeightPixels) * imageHeightPixels / 180;

end
