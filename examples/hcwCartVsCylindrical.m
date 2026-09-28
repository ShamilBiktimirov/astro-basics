%% Test Cartesian <-> Cylindrical relative-state mapping
clear;
clc;

%% Reference orbit

h  = 400e3;            % reference altitude [m]
r = Consts.rEarth + h;            % reference orbit radius [m]


%% Test Cartesian relative state
%
% Convention:
%
% xCart = [x;
%          y;
%          z;
%          xDot;
%          yDot;
%          zDot]
%
% x - along-track
% y - cross-track
% z - radial

xCart = [ ...
    1000e3;     % x     [m]
    100;        % y     [m]
    500;        % z     [m]
    1.0;        % xDot  [m/s]
    0.01;       % yDot  [m/s]
    0.02];      % zDot  [m/s]


%% Cartesian -> Cylindrical

xCyl = mapHcwCart2Cyl(xCart, r);


%% Cylindrical -> Cartesian

xCartBack = mapHcwCyl2Cart(xCyl, r);


%% Reconstruction error

errorVector = xCartBack - xCart;


%% Print results

fprintf('\n');
fprintf('=============================================\n');
fprintf('Cartesian -> Cylindrical -> Cartesian test\n');
fprintf('=============================================\n\n');

fprintf('Reference radius = %.3f km\n\n', r/1e3);

fprintf('Original Cartesian state:\n');
fprintf('x      = %12.6f km\n', xCart(1)/1e3);
fprintf('y      = %12.6f km\n', xCart(2)/1e3);
fprintf('z      = %12.6f km\n', xCart(3)/1e3);
fprintf('xDot   = %12.6f m/s\n', xCart(4));
fprintf('yDot   = %12.6f m/s\n', xCart(5));
fprintf('zDot   = %12.6f m/s\n\n', xCart(6));


fprintf('Cylindrical state:\n');
fprintf('deltaS      = %12.6f km\n', xCyl(1)/1e3);
fprintf('y           = %12.6f km\n', xCyl(2)/1e3);
fprintf('deltaR      = %12.6f km\n', xCyl(3)/1e3);
fprintf('deltaSDot   = %12.6f m/s\n', xCyl(4));
fprintf('yDot        = %12.6f m/s\n', xCyl(5));
fprintf('deltaRDot   = %12.6f m/s\n\n', xCyl(6));


deltaTheta = xCyl(1)/r;

fprintf('Angular separation:\n');
fprintf('deltaTheta = %.8f rad\n', deltaTheta);
fprintf('deltaTheta = %.6f deg\n\n', rad2deg(deltaTheta));


fprintf('Recovered Cartesian state:\n');
fprintf('x      = %12.6f km\n', xCartBack(1)/1e3);
fprintf('y      = %12.6f km\n', xCartBack(2)/1e3);
fprintf('z      = %12.6f km\n', xCartBack(3)/1e3);
fprintf('xDot   = %12.6f m/s\n', xCartBack(4));
fprintf('yDot   = %12.6f m/s\n', xCartBack(5));
fprintf('zDot   = %12.6f m/s\n\n', xCartBack(6));


fprintf('Reconstruction error:\n');
disp(errorVector)

fprintf('Position error norm = %.3e m\n', ...
    norm(errorVector(1:3)));

fprintf('Velocity error norm = %.3e m/s\n', ...
    norm(errorVector(4:6)));
