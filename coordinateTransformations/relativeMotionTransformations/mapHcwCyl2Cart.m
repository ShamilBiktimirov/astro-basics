function xCart = mapHcwCyl2Cart(xCyl, r)
%MAPCYL2CART Convert cylindrical HCW state to Cartesian Hill state.
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
% Cartesian state convention:
%
%   xCart = [x;
%            y;
%            z;
%            xDot;
%            yDot;
%            zDot]
%
% INPUT:
%   xCyl - 6x1 cylindrical relative state
%   r    - reference orbit radius [m]
%
% OUTPUT:
%   xCart - 6x1 Cartesian relative state

% Reference: https://github.com/ShamilBiktimirov/Classical-mechanics/blob/main/spacecraft_relative_motion_models.ipynb


    %% Ensure column vector
    xCyl = xCyl(:);

    %% Angular separation

    deltaTheta = xCyl(1) / r;


    %% Cylindrical-to-Cartesian rotation

    A_rho_xi = [cos(deltaTheta), 0,  sin(deltaTheta);
                0,               1,  0;
                -sin(deltaTheta), 0,  cos(deltaTheta)];


    %% Position transformation

    rF0 = [0; xCyl(2); r + xCyl(3)];

    rL = [0; 0; r];

    rho = A_rho_xi * rF0 - rL;


    %% Velocity transformation

    vRho = A_rho_xi * xCyl(4:6);


    %% Assemble Cartesian state

    xCart = zeros(6,1);

    xCart(1:3) = rho;
    xCart(4:6) = vRho;

end