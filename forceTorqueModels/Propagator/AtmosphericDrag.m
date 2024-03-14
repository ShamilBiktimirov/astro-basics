function ap = AtmosphericDrag(rv, JD, Consts, spacecraft)


%r  = norm(R);

RE = Consts.rEarthEquatorial;
CD = spacecraft.CD;
A  = spacecraft.area;
m  = spacecraft.mass;
wE = [0 0 Consts.wEarth]';

wE_norm = Consts.wEarth;

theta = wE_norm*(JD-2451545.5)*(24*3600);

Q = [cos(theta)  sin(theta)  0;
     -sin(theta) cos(theta)  0;
     0           0           1];

r_bf = Q*rv(1:3)';

alt = norm(r_bf) - RE; %Altitude (km)
%rho = CIRA72(alt); %Air density from US Standard Model (kg/m^3)
%rho = atmosphere(alt); %Air density from US Standard Model (kg/m^3)
rho = exponential_model(alt);

V_bf = Q*rv(4:6)';

Vrel = V_bf - cross(wE,r_bf); %Velocity relative to the atmosphere (km/s)
vrel = norm(Vrel); %Speed relative to the atmosphere (km/s)

uv = Vrel/vrel; %Relative velocity unit vector
ap_bf = -0.5*CD*rho*A/m*(1000*vrel)^2/1000*uv;  %Acceleration due to drag (km/s^2)

ap = Q'*ap_bf;
