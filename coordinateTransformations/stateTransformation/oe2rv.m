function sv = oe2rv(oe, varargin)

    % Converts orbital elements to inertial state - position and velocity
    %
    % Input:
    %   - orbital elements [m, rad]
    %   - varargin, 'planetGp' in m/s^2
    
    % Output:
    %   - rv [m, m/s], column vector
    
    % planetGp - planet gravitational parameter
    
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

    sma  = oe(1); % m
    ecc  = oe(2); %  -
    inc  = oe(3); % rad
    RAAN = oe(4); % rad
    AOP  = oe(5); % rad
    MA   = oe(6); % rad

    E = mean2ecc(MA, ecc);
    v = 2 * atan(sqrt((1 + ecc) / (1 - ecc)) * tan(E / 2));
    r = sma * (1 - ecc ^ 2) / (1 + ecc * cos(v));

    r_pqw = r * [cos(v); sin(v); 0];
    v_pqw = sqrt(planetGp / (sma * (1 - ecc ^ 2))) * ...
            [-sin(v); ecc + cos(v); 0];

    Rz_O = [cos(RAAN), -sin(RAAN), 0;...
            sin(RAAN), cos(RAAN), 0; ...
            0, 0, 1];

    Rx_i = [1, 0, 0; ...
            0, cos(inc), -sin(inc); ...
            0, sin(inc), cos(inc)];

    Rz_w = [cos(AOP), -sin(AOP), 0; ...
            sin(AOP), cos(AOP), 0;  ...
            0, 0, 1];

    R = Rz_O * Rx_i * Rz_w;

    r_ijk = (R * r_pqw)';
    v_ijk = (R * v_pqw)';

    sv = [r_ijk'; v_ijk'];

end