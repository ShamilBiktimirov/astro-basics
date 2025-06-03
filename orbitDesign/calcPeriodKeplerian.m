function period = calcPeriodKeplerian(a, varargin)

    % Function calculates Keplerian orbital period for a given semi-major axis
    % Note: The sma should be mean if working with J2 perturbed dynamics for proper period estimate. Refer to calcPeriodNodal function for J2-perturbed motion.

    % Reference:
    % The formulas for the drifts are taken from D.A. Vallado Fundamentals of Astrodynamics
    % page 869, eq. 11-22

    % Input:
    % a [m], semi-major axis
    % varargin, 'planetGp' in m/s^2

    % Output:
    % period [s], Keplerian orbit period

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

    period = 2 * pi * sqrt(a^3 / planetGp);

end
