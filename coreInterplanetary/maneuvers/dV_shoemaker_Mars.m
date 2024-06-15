function dV = dV_shoemaker_Mars(a,e,inc, LMO_radius)

% Source: EARTH-APPROACHING ASTEROIDS AS TARGETS FOR EXPLORATION, L.M. SHOEMAKER and L.E. HELIN 

% The formulas have to be verified

% e - eccentricity of the asteroid
% a - semimajor axis of asteroid
% Q - aphelion distance of asteroid normalized to AU
% inc - inclination of the asteroid orbit
% S - Mars escape velocity from LMO (normalized)
% U0 - normalized orbital speed at at LMO

n = 24.07; % Mean orbital velocity of Mars (km/s)

Uo = v_LMOcirc(LMO_radius)/n;
S = V_Mars_esc(LMO_radius)/n;
Q = a.*(1+e);
Ut = sqrt(3 + 2/(Q+1) - 2*sqrt(2*Q./(Q+1)).*cosd(inc/2))/n;

% Impulse required to inject a spacecraft into a trasfer trajectory 
Ul = sqrt(Ut.^2 + S^2) - Uo;

% Impulse required to rendevous with target asteroid 
Uc = sqrt(3/Q - 2/(Q+1) - 2/Q.*sqrt(2/(Q+1)).*cosd(inc/2));
Ur = sqrt(3/Q - 1/a - 2/Q*sqrt(a./Q.*(1-e.^2)));
UR = sqrt(Uc.^2 - 2*Ur.*Uc.*cosd(inc/2) + Ur.^2);

F = Ul + UR; 

dV = 30*F + 0.5 ;

end