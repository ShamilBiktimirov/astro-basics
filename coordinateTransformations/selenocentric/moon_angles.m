function [rasc_pole, decl_pole, rasc_pm] = moon_angles (jdate)

% orientation angles of the moon with respect to EME2000

% input

%  jdate = julian date

% output

%  rasc_pole = right ascension of the lunar pole (radians)
%  decl_pole = declination of the lunar pole (radians)
%  rasc_pm   = right ascension of the lunar prime meridian (radians)

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% conversion factor - degrees to radians

dtr = pi / 180.0;

% fundamental time arguments

t = (jdate - 2451545.0d0) / 36525.0d0;

d = jdate - 2451545.0d0;

% fundamental trig arguments

e1 = 125.045d0 -  0.0529921d0 * d;

e2 = 250.089d0 -  0.1059842d0 * d;

e3 = 260.008d0 + 13.0120009d0 * d;

e4 = 176.625d0 + 13.3407154d0 * d;

e5 = 357.529d0 +  0.9856003d0 * d;

e6 = 311.589d0 + 26.4057084d0 * d;

e7 = 134.963d0 + 13.0649930d0 * d;

e8 = 276.617d0 +  0.3287146d0 * d;

e9 = 34.226d0 + 1.7484877d0 * d;

e10 = 15.134d0 -  0.1589763d0 * d;

e11 = 119.743d0 + 0.003609d0 * d;

e12 = 239.961d0 + 0.1643573d0 * d;

e13 = 25.053d0 + 12.9590088d0 * d;

% right ascension of the lunar pole

rasc_pole = 269.9949d0 + 0.0031d0 * t ...
    - 3.8787d0 * sin(dtr * e1) ...
    - 0.1204d0 * sin(dtr * e2) ...
    + 0.0700d0 * sin(dtr * e3) ...
    - 0.0172d0 * sin(dtr * e4) ...
    + 0.0072d0 * sin(dtr * e6) ...
    - 0.0052d0 * sin(dtr * e10) ...
    + 0.0043d0 * sin(dtr * e13);

rasc_pole = dtr * rasc_pole;

% declination of the lunar pole

decl_pole = 66.5392d0 + 0.0130d0 * t ...
    + 1.5419d0 * cos(dtr * e1) ...
    + 0.0239d0 * cos(dtr * e2) ...
    - 0.0278d0 * cos(dtr * e3) ...
    + 0.0068d0 * cos(dtr * e4) ...
    - 0.0029d0 * cos(dtr * e6) ...
    + 0.0009d0 * cos(dtr * e7) ...
    + 0.0008d0 * cos(dtr * e10) ...
    - 0.0009d0 * cos(dtr * e13);

decl_pole = dtr * decl_pole;

% right ascension of the lunar prime meridian

rasc_pm = 38.3213d0 + 13.17635815d0 * d ...
    - 1.4d-12 * d * d ...
    + 3.5610 * sin(dtr * e1) ...
    + 0.1208d0 * sin(dtr * e2) ...
    - 0.0642d0 * sin(dtr * e3) ...
    + 0.0158d0 * sin(dtr * e4) ...
    + 0.0252d0 * sin(dtr * e5) ...
    - 0.0066d0 * sin(dtr * e6) ...
    - 0.0047d0 * sin(dtr * e7) ...
    - 0.0046d0 * sin(dtr * e8) ...
    + 0.0028d0 * sin(dtr * e9) ...
    + 0.0052d0 * sin(dtr * e10) ...
    + 0.0040d0 * sin(dtr * e11) ...
    + 0.0019d0 * sin(dtr * e12) ...
    - 0.0044d0 * sin(dtr * e13);

rasc_pm = dtr * rasc_pm;
