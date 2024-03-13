
function [r, v] = sv_from_coe(coe,mu)

%{ 
This function computes the state vector (r,v) from the
classical orbital elements (coe).
mu - gravitational parameter (km^3;s^2)
coe - orbital elements [h e RA incl w TA]

where
R3_w - Rotation matrix about the z-axis through the angle w
R1_i - Rotation matrix about the x-axis through the angle i
R3_W - Rotation matrix about the z-axis through the angle RA
Q_pX - Matrix of the transformation from perifocal to geocentric
equatorial frame
rp - position vector in the perifocal frame (km)
vp - velocity vector in the perifocal frame (km/s)
r - position vector in the geocentric equatorial frame (km)
v - velocity vector in the geocentric equatorial frame (km/s)
User M-functions required: none
%}
% ----------------------------------------------
%From Curtis
h = coe(1);
e = coe(2);
RA = coe(3);
incl = coe(4);
w = coe(5);
TA = coe(6);

rp = (h^2/mu) * (1/(1 + e*cos(TA))) * (cos(TA)*[1;0;0] + sin(TA)*[0;1;0]);
vp = (mu/h) * (-sin(TA)*[1;0;0] + (e + cos(TA))*[0;1;0]);

R3_W = [ cos(RA) sin(RA) 0
-sin(RA) cos(RA) 0
0 0 1];

R1_i = [1 0 0
        0 cos(incl) sin(incl)
        0 -sin(incl) cos(incl)];

R3_w = [ cos(w) sin(w) 0
        -sin(w) cos(w) 0
                  0 0 1];

Q_pX = (R3_w*R1_i*R3_W)';

r = Q_pX*rp;
v = Q_pX*vp;

r = r';
v = v';
end


