function tmatrix = moon_pa1(jdate)

% transformation matrix from lunar mean equator and IAU node of j2000
% to the lunar principal axes system using JPL binary ephemeris

% input

%  jdate = TDB julian date

% output

%  tmatrix = transformation matrix

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
      
% compute lunar libration angles (radians)

icent = 0;

itarg = 15;

sv = jplephem (jdate, itarg, icent);

phi = sv(1);

theta = sv(2);

psi = mod(sv(3), 2.0 * pi);

% compute lunar libration matrix

tmatrix2 = matran (phi, 3, theta, 1, psi, 3, 0.0d0, 0);

% create moon_j2000 to lunar principal axes transformation matrix

tmatrix = tmatrix2 * tmatrix1;



