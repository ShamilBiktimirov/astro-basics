function xCyl = mapHcwCart2Cyl(xCart, r)

%MAPCART2CYL Convert Cartesian HCW state to cylindrical HCW state.
%
% Cartesian state convention:
%
%   xCart = [x;
%            y;
%            z;
%            xDot;
%            yDot;
%            zDot]
%
% where
%   x - along-track
%   y - cross-track
%   z - radial
%
% Cylindrical state convention:
%
%   xCyl = [deltaS;
%           y;
%           deltaR;
%           deltaSDot;
%           yDot;
%           deltaRDot]
%
% with
%   deltaS = r * deltaTheta
%
% INPUT:
%   xCart - 6x1 Cartesian relative state
%   r     - reference orbit radius [m]
%
% OUTPUT:
%   xCyl  - 6x1 cylindrical relative state

% Reference: https://github.com/ShamilBiktimirov/Classical-mechanics/blob/main/spacecraft_relative_motion_models.ipynb


    %% Ensure column vector
    xCart = xCart(:);

    %% Position

    x = xCart(1);
    y = xCart(2);
    z = xCart(3);

    deltaR = sqrt(x^2 + (r + z)^2) - r;

    deltaTheta = atan2(x, r + z);

    deltaS = r * deltaTheta;


    %% Velocity transformation

    A_xi_rho = [cos(deltaTheta), 0, -sin(deltaTheta);
                0,               1,  0;
                sin(deltaTheta), 0,  cos(deltaTheta)];

    vXi = A_xi_rho * xCart(4:6);


    %% Assemble cylindrical state

    xCyl = zeros(6,1);

    xCyl(1) = deltaS;
    xCyl(2) = y;
    xCyl(3) = deltaR;

    xCyl(4:6) = vXi;

end
