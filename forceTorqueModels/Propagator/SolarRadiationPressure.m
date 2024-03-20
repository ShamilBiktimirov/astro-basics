function ap = SolarRadiationPressure(rv, Consts, spacecraft, JD)
% Taken from Curtis
%...Compute the apparent position vector of the sun:
[lambda, eps, r_sun] = solar_position(JD, Consts);

%...Convert the ecliptic latitude and the obliquity to radians:
deg = pi/180;
lambda = lambda*deg;
eps = eps*deg;

R  = rv(1:3);
As = spacecraft.SRParea;
m  = spacecraft.mass;
CR = spacecraft.CR;
S  = Consts.solarConstant;
c  = Consts.lightSpeed;

%Shadow function: nu = 0 if the spacecraft is the shadow
nu = los(R, r_sun);

pSR = nu*(S/c)*CR*As/m/1000; %Solar radiation accelaration magnitude

%solar radiation pressure pertubation
ap = -pSR*[cos(lambda) cos(eps)*sin(lambda) sin(eps)*sin(lambda)]';



