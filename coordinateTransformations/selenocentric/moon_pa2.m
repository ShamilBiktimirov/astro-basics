function tmatrix = moon_pa2 (jdate)

% transformation matrix from lunar mean equator and IAU node of j2000
% to the lunar principal axes system using JPL approximate equations

% input

%  jdate = TDB julian date

% output

%  tmatrix = transformation matrix

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dtr = pi / 180.0d0;

% lunar mean equator and IAU node of j2000 (moon_j2000)
% to Earth mean equator and equinox of j2000 (EME2000)
% transformation matrix

tmatrix1(1, 1) = 0.998496505205088d0;
tmatrix1(2, 1) = -5.481540926807404d-2;
tmatrix1(3, 1) = 0.0d0;

tmatrix1(1, 2) = 4.993572939853833d-2;
tmatrix1(2, 2) = 0.909610125238044d0;
tmatrix1(3, 2) = 0.412451018902688d0;
 
tmatrix1(1, 3) = -2.260867140418499d-2;
tmatrix1(2, 3) = -0.411830900942612d0;
tmatrix1(3, 3) = 0.910979778593430d0;

% time arguments

t = (jdate - 2451545.0d0) / 36525.0d0;

d = jdate - 2451545.0d0;

% trig arguments (degrees)

e1 = 125.045d0 -  0.0529921d0 * d;

e2 = 250.089d0 -  0.1059842d0 * d;

e3 = 260.008d0 + 13.0120009d0 * d;

e4 = 176.625d0 + 13.3407154d0 * d;

e5 = 357.529d0 + 0.9856003d0 * d;

e6 = 311.589d0 + 26.4057084d0 * d;

e7 = 134.963d0 + 13.0649930d0 * d;

e8 = 276.617d0 +  0.3287146d0 * d;

e9 = 34.226d0 + 1.7484877d0 * d;

e10 = 15.134d0 -  0.1589763d0 * d;

e11 = 119.743d0 + 0.003609d0 * d;

e12 = 239.961d0 + 0.1643573d0 * d;

e13 = 25.053d0 + 12.9590088d0 * d;

% polynominal part of prime meridian (degrees)

wp = 38.3213d0 + 13.17635815d0 * d - 1.4d-12 * d * d;

% right ascension of the lunar pole (radians)

rasc_pole = 269.9949d0 + 0.0031d0 * t ...
    - 3.8787d0 * sin(dtr * e1) ...
    - 0.1204d0 * sin(dtr * e2) ...
    + 0.0700d0 * sin(dtr * e3) ...
    - 0.0172d0 * sin(dtr * e4) ...
    + 0.0072d0 * sin(dtr * e6) ...
    - 0.0052d0 * sin(dtr * e10) ...
    + 0.0043d0 * sin(dtr * e13);

rasc_pole = rasc_pole + 0.0553d0 * cos(dtr * wp) ...
    + 0.0034d0 * cos(dtr * (wp + e1));

rasc_pole = dtr * rasc_pole;

% declination of the lunar pole (radians)

decl_pole = 66.5392d0 + 0.0130d0 * t ...
    + 1.5419d0 * cos(dtr * e1) ...
    + 0.0239d0 * cos(dtr * e2) ...
    - 0.0278d0 * cos(dtr * e3) ...
    + 0.0068d0 * cos(dtr * e4) ...
    - 0.0029d0 * cos(dtr * e6) ...
    + 0.0009d0 * cos(dtr * e7) ...
    + 0.0008d0 * cos(dtr * e10) ...
    - 0.0009d0 * cos(dtr * e13);

decl_pole = decl_pole + 0.0220d0 * sin(dtr * wp) ...
    + 0.0007d0 * sin(dtr * (wp + e1));

decl_pole = dtr * decl_pole;

% right ascension of the lunar prime meridian (radians)
% (measured relative to the iau node of epoch)

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

rasc_pm = rasc_pm + 0.01775d0 - 0.0507d0 * cos(dtr * wp) ...
    - 0.0034d0 * cos(dtr * (wp + e1));

rasc_pm = dtr * rasc_pm;

% compute the unit vector in the direction of the moon's pole

phat_moon(1) = cos(rasc_pole) * cos(decl_pole);

phat_moon(2) = sin(rasc_pole) * cos(decl_pole);

phat_moon(3) = sin(decl_pole);

zhat(1) = 0.0d0;
zhat(2) = 0.0d0;
zhat(3) = 1.0d0;

% x-direction

xvec = cross (zhat, phat_moon);

xhat = xvec / norm(xvec);

% y-direction

yvec = cross (phat_moon, xhat);

yhat = yvec / norm(yvec);

% load elements of iau node of epoch transformation matrix

twrk1(1, 1) = xhat(1);
twrk1(1, 2) = xhat(2);
twrk1(1, 3) = xhat(3);

twrk1(2, 1) = yhat(1);
twrk1(2, 2) = yhat(2);
twrk1(2, 3) = yhat(3);

twrk1(3, 1) = phat_moon(1);
twrk1(3, 2) = phat_moon(2);
twrk1(3, 3) = phat_moon(3);

% rotate about the z-axis through the prime meridian angle

twrk2 = matran(rasc_pm, 3, 0, 0, 0, 0, 0, 0);

% perform matrix mulatiplication to create
% approximate moon_j2000-to-moon_pa transformation

tmatrix = twrk2 * twrk1 * tmatrix1;



