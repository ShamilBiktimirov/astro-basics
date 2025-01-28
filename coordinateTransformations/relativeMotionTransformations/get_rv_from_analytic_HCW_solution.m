function rv_HCW = get_rv_from_analytic_HCW_solution(target_rv_ECI, formation_geometry, varargin)

    % HCW solution is from [1]
    % 1. Writing with Sunlight: CubeSat Formation Control Using Aerodynamic
    % Forces, Ivanov D. et al

    % Notation for orbital reference frame: x - along track; y - out-of-plane; z - radial

    % x = c1 * cos(arg_of_lat + alpha) + c3;
    % y = c2 * sin(arg_of_lat + alpha);
    % z = c1/2 * sin(arg_of_lat + alpha);
    % dx/dt = - n * c1 * sin(arg_of_lat + alpha);
    % dy/dt =  n * c2 * cos(arg_of_lat + alpha);
    % dz/dt =  n * c1/2 * cos(arg_of_lat + alpha);

    if nargin == 1
        planetGp = Consts.muEarth;
    elseif nargin == 3
        if strcmpi(varargin(1), 'planetGp')
            planetGp = cell2mat(varargin(2));
        else
            error('Improper function input');
        end
    elseif nargin > 3
        error('Improrer function input');
    end

    target_oe = rv2oe(target_rv_ECI);
    mean_motion = sqrt(planetGp / target_oe(1)^3);
    arg_of_lat = target_oe(8);

    c1 = formation_geometry(1,:);
    c2 = formation_geometry(2,:);
    c3 = formation_geometry(3,:);
    alpha = formation_geometry(4,:);

    r_x = c1.*cos(arg_of_lat + alpha) + c3;
    r_y = c2.*sin(arg_of_lat + alpha);
    r_z = (c1/2).*sin(arg_of_lat + alpha);
    v_x = -mean_motion*c1.*sin(arg_of_lat + alpha);
    v_y = mean_motion*c2.*cos(arg_of_lat + alpha);
    v_z = mean_motion*c1/2.*cos(arg_of_lat + alpha);

    rv_HCW = [r_x ; r_y ; r_z ; v_x ; v_y ; v_z];

 end