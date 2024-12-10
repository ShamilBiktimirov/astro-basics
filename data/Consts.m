classdef Consts

    properties (Constant)

        rEarth           = 6371009;                                         % Earth mean radius, [m]
        rMars            = 3396e3;                                          % Mars mean radius, [m]
        rEarthEquatorial = 6.378136300e6;                                   % mean Earth equtorial radius, [m]
        rJustitia        = 50.728e3 / 2;                                    % Justita asteroid mean radisu, [m]
        muEarth          = 3.986004415e14;                                  % Earth stadard gravitational parameter, [m^3 / s^2]
        muMoon           = 4902.800066 * 1e9;                               % Moon standard graviational parameter, [m^3 / s^2]
        muSun            = 132712440017.987 * 10^9;                         % Sun gravitational parameter, [m3/s2]
        muJustitia       = 4.37e6;                                          % Justitia asteroid gravitational parameter, [m^3 / s^2]
        astronomicUnit   = 149597870691;                                    % Astronomic Unit, [m]
        earthJ2          = 1.082626e-3;                                     % First zonal harmonic coefficient in the expansion of the Earth's gravity field
        earthMeanMotion  = 1.99098367476852e-07                             % Earth mean motion, [rad/s]
        deg2rad          = pi/180;                                          % conversion from degrees to radians
        rad2deg          = 180/pi;                                          % conversion from radians to degrees
        km2m             = 1000;                                            % conversion from kilometers to meters
        m2km             = 1e-3;                                            % conversion from meters to kilometers
        omegaEarth       = 7.29211585275553e-05;                            % Earth self revolution angular velocity [rad/s]
        wEarth           = [0; 0; 7.29211514670698e-05];                    % Earth angular velocity, [rad/s]
        day2sec          = 86400;                                           % conversion from days to seconds
        gravitationalAcceleration = 9.80665;                                % gravitational acceleration on Earth, [m/s^2]
        solarRadiationPressure    = 4.57e-6;                                % solar radiation pressure, [N/m^2]
        delta_MJD_GMAT            = 2430000.0;                              % backward convertion from modified Julian days in GMAT to Julian days
        karmanLineHeight          = 100e3;                                  % Karman line - end of life altitude, [m]
        sunlightIntensity         = 1370;                                   % Sunlight intensity at Earth orbit, W/m^2
        earthMagneticField        = 7.812e15;                               % Average Earth magnetic field dipole strength [W*b/m]
        goldenRatio               = (1 + sqrt(5)) / 2                       % golden ratio, []
        p_srp = 4.57e-6;                                                    % solar radiation pressure, N/m^2
    end

end
