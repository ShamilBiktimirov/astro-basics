function ap = AtmosphericDrag(rv, Consts, spacecraft)

R  = rv(1:3);
r  = norm(R);

RE = Consts.rEarthEquatorial;
CD = spacecraft.CD;
A  = spacecraft.area;
m  = spacecraft.mass;
wE = [0 0 Consts.wEarth]';

alt = r - RE; %Altitude (km)
%rho = CIRA72(alt); %Air density from US Standard Model (kg/m^3)
%rho = atmosphere(alt); %Air density from US Standard Model (kg/m^3)
rho = exponential_model(alt);


V = rv(4:6); 
Vrel = V - cross(wE,R); %Velocity relative to the atmosphere (km/s)
vrel = norm(Vrel); %Speed relative to the atmosphere (km/s)

uv = Vrel/vrel; %Relative velocity unit vector
ap = -0.5*CD*rho*A/m*(1000*vrel)^2/1000*uv;  %Acceleration due to drag (km/s^2)
