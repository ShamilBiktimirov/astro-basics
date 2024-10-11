function [phi, theta, psi, phi_dot, theta_dot, psi_dot] = lunarlib(jdate)

% lunar libration angles and rates using a JPL binary ephemeris

% input

%  jdate = TDB julian date

% output

%  phi, theta, psi = libration angles (radians)
%  phi_dot, theta_dot, psi_dot = libration angle rates (radians/day)

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

icent = 0;

itarg = 15;

sv = jplephem (jdate, itarg, icent);

phi = sv(1);

theta = sv(2);

psi = sv(3);

phi_dot = sv(4);

theta_dot = sv(5);

psi_dot = sv(6);






