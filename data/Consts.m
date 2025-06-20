classdef Consts

    properties (Constant)

        %% Planetary radii, [m]
        % Source: https://ssd.jpl.nasa.gov/planets/phys_par.html#refs
        rMercury         = 2439.4e3;
        rVenus           = 6051.8e3;
        rEarth           = 6371009;
        rMars            = 3396e3;
        rJupiter         = 69911e3;
        rSaturn          = 58232e3;
        rUranus          = 25362e3;
        rNeptune         = 24622e3;

        % Small body radii
        rJustitia        = 50.728e3 / 2;                                    % Justita asteroid mean radius, [m], from JPL SSD
        rJustitiaLasp    = 28e3;                                            % Justita asteroid mean radius, [m], from lasp conf paper

        % Planetary equatorial radius, [m]
        rEarthEquatorial   = 6.378136300e6;
        rJupiterEquatorial = 71492e3;


        %% Planetary gravitational parameter, [m^3/s^2]
        % Source: https://ssd.jpl.nasa.gov/planets/phys_par.html#refs
        muMercury        = 0.330103e24 * 6.6743e-11;
        muVenus          = 4.86731e24  * 6.6743e-11;
        muEarth          = 3.986004415e14;                                  % Earth stadard gravitational parameter, [m^3 / s^2]
        muMars           = 42828e9;                                         % Mars gravitational parameter, [m^3 / s^2]
        muJupiter        = 1.26686534e17;                                   % Jupiter gravitational parameter, [m^3 / s^2]
        muSaturn         = 568.317e24 * 6.6743e-11;
        muUranus         = 86.8099e24 * 6.6743e-11;
        muNeptune        = 102.4092 * 6.6743e-11;

        muSun            = 132712440017.987 * 10^9;                         % Sun gravitational parameter, [m3/s2]
        muSunAuYear      = Consts.muSun / Consts.astronomicUnit^3 * (2 * pi / Consts.earthMeanMotion)^2; % Sun mu in au^3/year^2
        muMoon           = 4902.800066 * 1e9;                               % Moon standard graviational parameter, [m^3 / s^2]

        muJustitia       = 4.37e6;                                          % Justitia asteroid gravitational parameter, [m^3 / s^2]
        muJustitiaLow    = 5.287e6;                                         % Justitia asteroid GM - low density, [m^3 / s^2]
        muJustitiaMid    = 7.98e6;                                          % Justitia asteroid GM - mid density, [m^3 / s^2]
        muJustitiaHigh   = 14.16e6;                                         % Justitia asteroid GM - high density, [m^3 / s^2]

        % Spherical harmonics coefficients
        earthJ2          = 1.082626e-3;                                     % First zonal harmonic coefficient in the expansion of the Earth's gravity field
        justitiaJ2       = -0.01272;                                        % Justitia J2, from LASP conf paper
        justitiaJ4       = 0.001594;                                        % Justitia J4, from LASP conf paper

        % Laplace Sphere of Influence (SOI), m
        rSoiJupiter = 48.2e9;

        %% Earth relevant parameters
        astronomicUnit   = 149597870691;                                    % Astronomic Unit, [m]
        omegaEarth       = 7.29211585275553e-05;                            % Earth self revolution angular velocity [rad/s]
        wEarth           = [0; 0; 7.29211514670698e-05];                    % Earth angular velocity, [rad/s]

        earthMeanMotion  = 1.99098367476852e-07                             % Earth mean motion, [rad/s]
        gravitationalAcceleration = 9.80665;                                % gravitational acceleration on Earth, [m/s^2]
        gravitationalAccelerationAuYear = Consts.gravitationalAcceleration / Consts.astronomicUnit * (2 * pi / Consts.earthMeanMotion)^2
        solarRadiationPressure    = 4.57e-6;                                % solar radiation pressure, [N/m^2]
        karmanLineHeight          = 100e3;                                  % Karman line - end of life altitude, [m]
        sunlightIntensity         = 1370;                                   % Sunlight intensity at Earth orbit, W/m^2
        earthMagneticField        = 7.812e15;                               % Average Earth magnetic field dipole strength [W*b/m]

        %% General mathematical constants
        deg2rad          = pi/180;                                          % conversion from degrees to radians
        rad2deg          = 180/pi;                                          % conversion from radians to degrees
        km2m             = 1000;                                            % conversion from kilometers to meters
        m2km             = 1e-3;                                            % conversion from meters to kilometers
        day2sec          = 86400;                                           % conversion from days to seconds

        delta_MJD_GMAT   = 2430000.0;                                       % backward convertion from modified Julian days in GMAT to Julian days
        delta_mjd = 2400000.5;
        goldenRatio      = (1 + sqrt(5)) / 2                                % golden ratio, []
        year2day         = 365;

        gravitationalConstant = 6.6743e-11;                                 % m^3 / kg^2 / s^2

    end

end
