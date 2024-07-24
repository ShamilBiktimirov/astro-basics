function dV = dV_shoemaker_Earth(e,inc,a)

%e - eccentricity of the asteroid
%a - semimajor axis of asteroid
%Q - aphelion distance of asteroid normalized to A
%inc - inclination of the ASTEROID orbit
%S - Earth escape velocity from LEO (normalized)
%U0 - normalized orbital speed at at LEO

h = 500;
n = 24; % speed of the earth km/s

Uo = v_LMOcirc(h)/n;
S = V_Mars_esc(h)/n;
Q = a.*(1+e);
Ut = sqrt(3 + 2/(Q+1) - 2*sqrt(2*Q./(Q+1)).*cosd(inc/2))/n;

%Impulse required to inject a spacecraft into a trasfer trajectory 
Ul = sqrt(Ut.^2 + S^2) - Uo;

%Impulse required to rendevous with target asteroid 
Uc = sqrt(3/Q - 2/(Q+1) - 2/Q.*sqrt(2/(Q+1)).*cosd(inc/2));
Ur = sqrt(3/Q - 1/a - 2/Q*sqrt(a./Q.*(1-e.^2)));
UR = sqrt(Uc.^2 - 2*Ur.*Uc.*cosd(inc/2) + Ur.^2);

F = Ul + UR; 

dV = 30*F + 0.5 ;

end