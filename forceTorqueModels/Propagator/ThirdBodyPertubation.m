function ap = ThirdBodyPertubation(rv, R3, mu3)

R = rv(1:3); % postion of the satellite relative to Earth

r_B3 = norm(R3);
R_rel = R3' - R; %position vector of the third body relative to satellite
r_rel = norm(R_rel);

%...See Appendix F (Curtis)
q = dot(R,(2*R3' - R))/r_B3^2;
F = (q^2 - 3*q + 3)*q/(1 + (1-q)^1.5);
%...Gravitational perturbation of the third body 

ap = mu3/r_rel^3*(F*R3' - R);
