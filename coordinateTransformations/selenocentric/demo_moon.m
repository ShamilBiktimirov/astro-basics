% demo_moon.m       May 27, 2008

% demonstrates how to compute lunar orientation
% angles and useful transformation matrices

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

global iephem km ephname

rtd = 180.0 / pi;

% initialize jpl ephemeris

iephem = 1;

km = 1;

ephname = 'de421.bin';

% begin simulation

clc; home;

fprintf('\nprogram demo_moon\n');

jdate = 2451545.0;

fprintf('\nTDB Julian date          %12.6f \n', jdate);

% compute lunar orientation angles

[rasc_pole, decl_pole, rasc_pm] = moon_angles (jdate);

fprintf('\n\norientation angles of the moon with respect to EME2000\n');

fprintf('\nrasc_pole        %14.8f degrees\n', rtd * rasc_pole);

fprintf('\ndecl_pole        %14.8f degrees\n', rtd * decl_pole);

fprintf('\nrasc_pm          %14.8f degrees\n', rtd * rasc_pm);

tmatrix = mm2000 (jdate);

fprintf('\n\neme2000 to moon mean equator and IAU node');
fprintf('\nof epoch transformation matrix\n');

fprintf('\n   %+16.14e  %+16.14e  %+16.14e', ...
    tmatrix(1, 1), tmatrix(1, 2), tmatrix(1, 3));

fprintf('\n   %+16.14e  %+16.14e  %+16.14e', ...
    tmatrix(2, 1), tmatrix(2, 2), tmatrix(2, 3));

fprintf('\n   %+16.14e  %+16.14e  %+16.14e\n', ...
    tmatrix(3, 1), tmatrix(3, 2), tmatrix(3, 3));

fprintf('\n\nlunar mean equator and IAU node of J2000 (moon_j2000)');
fprintf('\nto lunar principal axis (PA) transformation matrix\n');

tmatrix = moon_pa1(jdate);

fprintf('\nmoon_pa1 function\n');

fprintf('\n   %+16.14e  %+16.14e  %+16.14e', ...
    tmatrix(1, 1), tmatrix(1, 2), tmatrix(1, 3));

fprintf('\n   %+16.14e  %+16.14e  %+16.14e', ...
    tmatrix(2, 1), tmatrix(2, 2), tmatrix(2, 3));

fprintf('\n   %+16.14e  %+16.14e  %+16.14e\n', ...
    tmatrix(3, 1), tmatrix(3, 2), tmatrix(3, 3));

tmatrix = moon_pa2(jdate);

fprintf('\nmoon_pa2 function\n');

fprintf('\n   %+16.14e  %+16.14e  %+16.14e', ...
    tmatrix(1, 1), tmatrix(1, 2), tmatrix(1, 3));

fprintf('\n   %+16.14e  %+16.14e  %+16.14e', ...
    tmatrix(2, 1), tmatrix(2, 2), tmatrix(2, 3));

fprintf('\n   %+16.14e  %+16.14e  %+16.14e\n', ...
    tmatrix(3, 1), tmatrix(3, 2), tmatrix(3, 3));

fprintf('\n\nlunar mean Earth/polar axis (ME) to lunar');
fprintf('\nprincipal axis (PA) transformation matrix\n');

tmatrix = moon_me2pa;

fprintf('\n   %+16.14e  %+16.14e  %+16.14e', ...
    tmatrix(1, 1), tmatrix(1, 2), tmatrix(1, 3));

fprintf('\n   %+16.14e  %+16.14e  %+16.14e', ...
    tmatrix(2, 1), tmatrix(2, 2), tmatrix(2, 3));

fprintf('\n   %+16.14e  %+16.14e  %+16.14e\n\n', ...
    tmatrix(3, 1), tmatrix(3, 2), tmatrix(3, 3));


