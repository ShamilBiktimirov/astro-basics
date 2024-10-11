% demo_llib.m    May 22, 2008

% demonstrates how to compute the lunar
% libration angles and rates using a
% JPL binary ephemeris file

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

global iephem km ephname

% unit conversion constants

rtd = 180 / pi;

iephem = 1;

km = 1;

ephname = 'de421.bin';

% begin simulation

clc; home;
   
fprintf('\nprogram demo_llib\n');
   
jdate = 2451545.0;

[phi, theta, psi, phi_dot, theta_dot, psi_dot] = lunarlib(jdate);

fprintf('\nlunar libration angles and rates\n');

fprintf('\nTDB Julian date          %12.6f \n', jdate);

fprintf('\nphi          %14.8f degrees\n', rtd * phi);

fprintf('\ntheta        %14.8f degrees\n', rtd * theta);

fprintf('\npsi          %14.8f degrees\n', mod(rtd * psi, 360));

fprintf('\n\nphi_dot      %14.8f degrees/day\n', rtd * phi_dot);

fprintf('\ntheta_dot    %14.8f degrees/day\n', rtd * theta_dot);

fprintf('\npsi_dot      %14.8f degrees/day\n\n', rtd * psi_dot);

