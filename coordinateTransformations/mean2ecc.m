function E = mean2ecc(M, e)
% Converts mean anomaly to eccentric anomaly.
%
% Inputs:
%   * mean anomaly
%   * eccentricity
% Output:
%   * eccentric anomaly

% initial guess
if ((M > -pi) && (M < 0)) || (M > pi)
    E = M - e;
else
    E = M + e;
end
% iteration
tol = 1e-12;
d = -(E - e*sin(E) - M)/(1 - e*cos(E));
while abs(d) >= tol
    E = E + d;
    d = -(E - e*sin(E) - M)/(1 - e*cos(E));
end
end

