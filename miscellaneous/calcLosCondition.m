function losFlag = calcLosCondition(r1, r2, varargin)

    % The function calculates line-of-sight (LOS) condition for a pair of vectors
    % For LOS condition for a spherical central body of radius R

    % By default Earth mean radius is considered

    % Input:
    % r1, [3, 1], m - cartesian coordinates of an object 1
    % r2, [3, 1], m - cartesian coordinates of an object 2
    % varargin:
    % rCentralBody, m, radius of a central body

    % Reference: D. Vallado, Fundamentals of Astrodynamics and Application,
    % section 5.3.3 Application: Sight and Light - First approach with trigonometric functions

    %%  checking inputs
    parser = inputParser;

    % Define optional parameters
    addParameter(parser, 'rCentralBody', [], @(x) isempty(x) || (isnumeric(x) && isscalar(x) && x > 0));

    % Parse inputs
    parse(parser, varargin{:});
    rCentralBody = parser.Results.rCentralBody;

    % Set default central body radius is it is not provided
    if isempty(rCentralBody)
        rCentralBody = Consts.rEarth;
    end


    %% Calculating LOS condition by comparing current angle between r1 and r2 with the critical one for the central body radius

    alfaCritical = acos(rCentralBody / norm(r1)) + acos(rCentralBody / norm(r2));
    beta = acos(dot(r1, r2) / norm(r1) / norm(r2));

    if beta < alfaCritical
        losFlag = 1;
    else
        losFlag = 0;
    end

end
