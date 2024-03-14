function ap = ThirdBodyPertubation(rv, JD, Consts, R3, mu3)

wE    = Consts.wEarth;
theta = wE*(JD-2451545.5)*(24*3600);

%Transformation matrix
Q = [cos(theta)  sin(theta)  0;
     -sin(theta) cos(theta)  0;
     0           0           1];

R = Q*rv(1:3)'; % postion of the satellite relative to Earth

r_B3 = norm(R3);
R_rel = R3 - R; %position vector of the third body relative to satellite
r_rel = norm(R_rel);

%...See Appendix F (Curtis)
q = dot(R,(2*R3 - R))/r_B3^2;
F = (q^2 - 3*q + 3)*q/(1 + (1-q)^1.5);
%...Gravitational perturbation of the third body 

ap = mu3/r_rel^3*(F*R3 - R);

%ap = -mu3*(R_rel/r_rel^3 + R3'/r_B3^3)';

% % Relative position vector of satellite w.r.t. point mass 
% d = r - s;
% 
% % Acceleration 
% a = -GM * ( d/(norm(d)^3) + s/(norm(s)^3) );
