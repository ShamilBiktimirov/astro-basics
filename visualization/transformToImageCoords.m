function [azTildaDeg, elevTildaDeg] = transformToImageCoords(az, elev, imageHeightPixels, imageWidthPixels)

    multiplier = imageWidthPixels * 360;
    elev = -elev; % change axis sign;
    azDeg = az * 180 / pi;
    elevDeg = elev * 180 / pi;

    azDeg = azDeg + 180;
    elevDeg = elevDeg + 90;

    azTildaDeg = rem(azDeg, imageWidthPixels) * imageWidthPixels / 360;
    elevTildaDeg = rem(elevDeg, imageHeightPixels) * imageWidthPixels / 360;

end
