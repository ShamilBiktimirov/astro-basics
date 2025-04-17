function a = calcOrbitSMA(rv, varargin)

    % rv [6, Npoints]

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

    radius = vecnorm(rv(1:3, :));
    speed  = vecnorm(rv(4:6, :));
    specificEnergy = speed .^ 2 / 2 - planetGp ./ radius;

    a = -planetGp ./ (2 * specificEnergy);

end
