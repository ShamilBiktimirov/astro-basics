clear; close all
deg = pi/180; %Degrees to radians
mu = 3.98600441500000e5; %Gravitational parameter (km^3/s^2)
RE = 6.37813630000000e3; %Earth=s radius (km)
%J2 = 1082.63e-6;
%J2 = 1.08262617385222E-03;
%...Initial orbital parameters (given):
zp0 = 300; %Perigee altitude (km)
za0 = 3062; %Apogee altitude (km)
RA0 = 45*deg; %Right ascension of the node (radians)
i0 = 28*deg; %Inclination (radians)
w0 = 30*deg; %Argument of perigee (radians)
TA0 = 40*deg; %True anomaly (radians)

rp0 = RE + zp0; %Perigee radius (km)
ra0 = RE + za0; %Apogee radius (km)
%e0 = (ra0 - rp0)/(ra0 + rp0); %Eccentricity
%a0 = (ra0 + rp0)/2; %Semimajor axis (km)


e0 = 0.1715;
a0 = 8052;
h0 = sqrt(a0*mu*(1-e0^2)); %Angular momentum (km^2/s)
T0 = 2*pi/sqrt(mu)*a0^1.5; %Period (s)
coe0 = [h0;e0;RA0;i0;w0;TA0];


degree = 5;
order = 5;

t0 = 0;
tf = 5*24*3600;
nout = 7925; %Number of solution points to output for plotting purposes
tspan = linspace(t0, tf, nout);
options = odeset(...
'reltol', 1.e-13, ...
'abstol', 1.e-13, ...
'initialstep', T0/1000);
y0 = coe0';
%yf = matlabFunction(y);
[t,y] = ode78(@pert, tspan, y0, options);

% rpp = norm(R0);
% Rpp = R0;
% %...Compute the J2 perturbing acceleration from Equation 12.30:
% xx = Rpp(1); yy = Rpp(2); zz = Rpp(3);
% fac = 3/2*J2*(mu/rpp^2)*(RE/rpp)^2;
% ap = -fac*[(1 - 5*(zz/rpp)^2)*(xx/rpp) ...
% (1 - 5*(zz/rpp)^2)*(yy/rpp) ...
% (3 - 5*(zz/rpp)^2)*(zz/rpp)];

h = y(:,1);
e = y(:,2);
RA = y(:,3);
i = y(:,4);
w = y(:,5);
TA = y(:,6);

aaa = h.^2./(mu.*(1-e.^2));

%...Plot the time histories of the osculating elements:
figure(1)
subplot(5,1,1)
plot(t/3600, RA/deg)
title('Right Ascension (degrees)')
xlabel('hours')
grid on
grid minor
axis tight
subplot(5,1,2)
plot(t/3600, w/deg)
title('Argument of Perigee (degrees)')
xlabel('hours')
grid on
grid minor
axis tight
subplot(5,1,3)
plot(t/3600,h)
title('Angular Momentum (km^2/s)')
xlabel('hours')
grid on
grid minor
axis tight
subplot(5,1,4)
plot(t/3600,e)
title('Eccentricity')
xlabel('hours')
grid on
grid minor
axis tight
subplot(5,1,5)
plot(t/3600,i/deg)
title('Inclination (degrees)')
xlabel('hours')
grid on
grid minor
axis tight

AA = xlsread("GMAT_5by5_EGM.xlsx");
tt   = AA(:,1);
RAAN = AA(:,2);
SMA  = AA(:,3);
ECC  = AA(:,5);
INC  = AA(:,7);
TAL  = AA(:,4);
AOP  = AA(:,6);
hh   = sqrt(mu*SMA.*(1-ECC.^2));

figure(2)
subplot(5,1,1)
plot(tt/3600, RAAN)
title('Right Ascension (degrees)')
xlabel('hours')
grid on
grid minor
axis tight
subplot(5,1,2)
plot(tt/3600, AOP)
title('Argument of Perigee (degrees)')
xlabel('hours')
grid on
grid minor
axis tight
subplot(5,1,3)
plot(tt/3600,hh)
title('Angular Momentum (km^2/s)')
xlabel('hours')
grid on
grid minor
axis tight
subplot(5,1,4)
plot(tt/3600,ECC)
title('Eccentricity')
xlabel('hours')
grid on
grid minor
axis tight
subplot(5,1,5)
plot(tt/3600,INC)
title('Inclination (degrees)')
xlabel('hours')
grid on
grid minor
axis tight

figure(3)
plot(t/3600, RA/deg)
hold on
plot(tt/3600, RAAN)
ylabel('Right Ascension (degrees)')
xlabel('hours')
grid on

figure(4)
plot(t/3600,h)
hold on
plot(tt/3600,hh)
ylabel('Angular Momentum (km^2/s)')
xlabel('hours')
grid on

figure(5)
plot(t/3600, w/deg)
hold on
plot(tt/3600, AOP)
title('Argument of Perigee (degrees)')
xlabel('hours')
grid on

figure(6)
plot(t/3600,e)
hold on
plot(tt/3600,ECC)
ylabel('Eccentricity')
xlabel('hours')
grid on

figure(7)
plot(t/3600,i/deg)
hold on
plot(tt/3600,INC)
ylabel('Inclination (degrees)')
xlabel('hours')
grid on

figure(8)
plot(t/3600,mod(TA/deg, 360))
hold on
plot(tt/3600,TAL)
ylabel('True anomaly (degrees)')
xlabel('hours')
grid on

figure(9)
plot(t/3600,aaa)
hold on
plot(tt/3600,SMA)
ylabel('Semimajor axis (km)')
xlabel('hours')
grid on


function fdot = pert(t,f)

degree = 5;
order = 5;
mu = 398600;

h   = f(1);
e   = f(2);
RA  = f(3);
i   = f(4);
w   = f(5);
TA  = f(6);

r   = h^2/mu/(1 + e*cos(TA));  %The radius
u   = w + TA;                 %Argument of latitude


[rvec, vvec] = sv_from_coe(f,mu);
% 
rv = [rvec vvec];

p_xyz = EarthGravity(rv, degree, order);

sRA = sin(RA); cRA = cos(RA);
si  = sin(i);  ci = cos(i);
su  = sin(u);  cu  = cos(u);
sTA = sin(TA); cTA = cos(TA);

Q = [-sRA*ci*su+cRA*cu   cRA*ci*su+sRA*cu    si*su
     -sRA*ci*cu-cRA*su   cRA*ci*cu-sRA*su    si*cu
     sRA*si                 -cRA*si           ci   ]; %Rotation matrix
% % 
p_rsw = Q*p_xyz;

p_r = p_rsw(1);
p_s = p_rsw(2);
p_w = p_rsw(3);

dhdt  = r*p_s;
dedt  =  (h/mu)*sTA*p_r + ((h^2 + mu*r)*cTA + mu*e*r)*p_s/(mu*h);
dRAdt = r*su*p_w/(h*si);
didt  = r*cu*p_w/h;
dwdt  = -(h^2*cTA*p_r/(mu) - (r + h^2/mu)*sTA*p_s)/(e*h) - r*sin(w+TA)*p_w/(h*tan(i));
dTAdt = h/r^2 + (1/(e*h))*(h^2*cTA*p_r/mu - (r + h^2/mu)*sTA*p_s);

fdot =  [dhdt dedt dRAdt didt dwdt dTAdt]';

end