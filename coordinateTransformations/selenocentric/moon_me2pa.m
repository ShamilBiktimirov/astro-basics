function tmatrix = moon_me2pa

% transformation matrix from the lunar Mean Earth/polar axis (ME)
% system to the lunar principal axes (PA) system

% output

%  tmatrix = me-to-pa transformation matrix

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tmatrix(1, 1) = 0.999999878527094;
tmatrix(1, 2) = 3.097894216177013E-004;
tmatrix(1, 3) = -3.833748976184077E-004;

tmatrix(2, 1) = -3.097891271165531E-004;
tmatrix(2, 2) = 0.999999952015005;
tmatrix(2, 3) = 8.275630251118771E-007;

tmatrix(3, 1) = 3.833751355924360E-004;
tmatrix(3, 2) = -7.087975496937868E-007;
tmatrix(3, 3) = 0.999999926511499;
