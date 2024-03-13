function rhoAtmo = CIRA72(altitude)

%% Inputs
% orbit altitude, m

%% Output
% Atmospheric density, kg/m^3

    baseAltitudes = [1000:-100:500, 450:-50:200, 180, 150:-10:30, 25, 0];
    scaleAltitudes = [268, 181.05, 124.64, 88.667, 71.835, 63.822, 60.828, 58.515, 53.298, 53.628, 45.546, 37.105, 29.740, ...
                      22.523, 16.149, 12.636, 9.473, 7.263, 5.877, 5.382, 5.799, 6.549, 7.714, 8.382, 7.554, 6.682, 6.349, 7.249];
    nominalDensities = [3.019e-15, 5.245e-15, 1.170e-14, 3.614e-14, 1.454e-13, 6.967e-13, 1.585e-12, 3.725e-12, 9.518e-12, ...
                        2.418e-11, 7.248e-11, 2.789e-10, 5.464e-10, 2.07e-9, 3.845e-9, 8.484e-9, 2.438e-8, 9.661e-8, 5.297e-7, 3.396e-6, ...
                        1.905e-5, 8.77e-5, 3.206e-4, 1.057e-3, 3.972e-3, 1.774e-2, 3.899e-2, 1.225];

    intervalNumber = sum(altitude'/Consts.km2m <= baseAltitudes, 2) + 1;
    baseAltitude = baseAltitudes(intervalNumber);
    scaleAltitude = scaleAltitudes(intervalNumber);
    nominalDensity = nominalDensities(intervalNumber);

    if altitude/1e3 <= baseAltitudes(1,1)
        rhoAtmo = nominalDensity * exp((baseAltitude - altitude / Consts.km2m ) / scaleAltitude);  
    else
        rhoAtmo = 0;
    end

end