function ap = AtmosphericDrag(rv, JD, Consts, spacecraft)


%r  = norm(R);

RE = Consts.rEarthEquatorial;
CD = spacecraft.CD;
A  = spacecraft.area;
m  = spacecraft.mass;
wE = [0 0 Consts.wEarth]';

wE_norm = Consts.wEarth;

theta = wE_norm*(JD-2451545)*(24*3600);

Q = [cos(theta)  sin(theta)  0;
     -sin(theta) cos(theta)  0;
     0           0           1];

r_bf = Q*rv(1:3)';

alt = norm(r_bf) - RE; %Altitude (km)
%rho = CIRA72(alt); %Air density from US Standard Model (kg/m^3)
%rho = atmosphere(alt); %Air density from US Standard Model (kg/m^3)
rho = exponential_model(alt);

% x = r_bf(1);
% y = r_bf(2);
% z = r_bf(3);
% 
% r = norm(r_bf);
% 
% latitude = asin(z/r);
% longitude = atan2(y,x); 
% 
% [year, month, day, ~, ~, ~] = invJulian(JD); 
% 
% doy = dayOfYear(year, month, day);
% if alt > 1000
%     alt = 1000;
% end
% 
% if alt < 0
%     alt = 0;
% end
% 
% f107 = 87.7;
% f107a = 83.356790123456790;
% aph = [17.375  15.00  20.00  15.00  27.00 18.125  21.75];
% 
% [~, rrho] = atmosnrlmsise00(alt*1e3,latitude*180/pi,longitude*180/pi,year,doy,0, f107a, f107, aph);
% 
% rho = rrho(6);

%rho = nrlmsise00(JD, r_bf, JD, JD)

V_bf = Q*rv(4:6)';

Vrel = V_bf - cross(wE,r_bf); %Velocity relative to the atmosphere (km/s)
vrel = norm(Vrel); %Speed relative to the atmosphere (km/s)

uv = Vrel/vrel; %Relative velocity unit vector
ap_bf = -0.5*CD*rho*A/m*(1000*vrel)^2/1000*uv;  %Acceleration due to drag (km/s^2)

ap = Q'*ap_bf;
