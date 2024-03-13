clear; close all
deg = pi/180; %Degrees to radians

Consts.muEarth = 3.98600441500000e5;
Consts.muSun   = 132712440017.987; %Sun's gravitational parameter (km^3/s^2)
Consts.muMoon  = 4902.800066; %Moon's gravitational parameter (km^3/s^2)
Consts.rEarthEquatorial = 6.37813630000000e3;
Consts.wEarth = 7.29211514670698e-05; %Earth's angular velocity (rad/s)
Consts.solarConstant = 1367; %Solar constant (W/m^2) ;
Consts.lightSpeed = 2.998e8; %Speed of light (m/s)
Consts.astronomicUnit = 149597870691;
spacecraft.SRParea = 1; %Soalr radiation pressure area (m2)
spacecraft.CR = 1.8; % Coefficient of reflectivity
spacecraft.CD = 2.2; % drag coefficient
spacecraft.mass = 200; %mass
spacecraft.area = 4; % drag area (m2)
input.degree = 5;
input.order  = 5;
input.JD0    = 2460311.5; %January 1, 2024

%...Initial orbital parameters (given):
e0 = 0.1715; %Eccentricity
a0 = 8052; %Semimajor axis
RA0 = 45*deg; %Right ascension of the node (radians)
i0 = 28*deg; %Inclination (radians)
w0 = 30*deg; %Argument of perigee (radians)
TA0 = 40*deg; %True anomaly (radians)

mu = Consts.muEarth;
h0 = sqrt(a0*mu*(1-e0^2)); %Angular momentum (km^2/s)
T0 = 2*pi/sqrt(mu)*a0^1.5; %Period (s)
coe0 = [h0;e0;RA0;i0;w0;TA0];

[r0, v0] = sv_from_coe(coe0,mu);

degree = 5;
order = 5;

t0 = 0;
tf = 2*24*3600;
nout = 2000; %Number of solution points to output for plotting purposes
tspan = linspace(t0, tf, nout);
options = odeset(...
'reltol', 1.e-13, ...
'abstol', 1.e-13);%, ...
%'initialstep', T0/1000);
y0 = [r0 v0]';
[t,y] = ode45(@(t,y) pert_sv(t,y,Consts,input,spacecraft), tspan, y0, options);

n_times = length(t); %n_times is the number of solution times
for j = 1:n_times
    R = [y(j,1:3)];
    V = [y(j,4:6)];
    coe = coe_from_sv(R,V, mu);
    h(j) = coe(1);
    e(j) = coe(2);
    RA(j) = coe(3);
    i(j) = coe(4);
    w(j) = coe(5);
    TA(j) = coe(6);
end

a = h.^2./(mu.*(1-e.^2)); %Semimajor axis

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

AA = xlsread("GMAT_JGM2_MSISE90_SRP_Lunar_Solar.xlsx");
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
xlabel('time (hours)')
grid on
grid minor
axis tight
subplot(5,1,2)
plot(tt/3600, AOP)
title('Argument of Perigee (degrees)')
xlabel('time (hours)')
grid on
grid minor
axis tight
subplot(5,1,3)
plot(tt/3600,hh)
title('Angular Momentum (km^2/s)')
xlabel('time(hours)')
grid on
grid minor
axis tight
subplot(5,1,4)
plot(tt/3600,ECC)
title('Eccentricity')
xlabel('time(hours)')
grid on
grid minor
axis tight
subplot(5,1,5)
plot(tt/3600,INC)
title('Inclination (degrees)')
xlabel('time(hours)')
grid on
grid minor
axis tight

figure(3)
plot(t/3600, RA/deg)
hold on
plot(tt/3600, RAAN)
ylabel('Right Ascension (degrees)')
xlabel('hours')
legend('MATLAB code', 'GMAT')
grid on

figure(4)
plot(t/3600,h)
hold on
plot(tt/3600,hh)
ylabel('Angular Momentum (km^2/s)')
xlabel('time(hours)')
legend('MATLAB code', 'GMAT')
grid on

figure(5)
plot(t/3600, w/deg)
hold on
plot(tt/3600, AOP)
ylabel('Argument of Perigee (degrees)')
xlabel('time(hours)')
legend('MATLAB code', 'GMAT')
grid on

figure(6)
plot(t/3600,e)
hold on
plot(tt/3600,ECC)
ylabel('Eccentricity')
xlabel('time (hours)')
legend('MATLAB code', 'GMAT')
grid on

figure(7)
plot(t/3600,i/deg)
hold on
plot(tt/3600,INC)
ylabel('Inclination (degrees)')
xlabel('hours')
legend('MATLAB code', 'GMAT')
grid on

figure(8)
plot(t/3600,mod(TA/deg, 360))
hold on
plot(tt/3600,TAL)
ylabel('True anomaly (degrees)')
xlabel('hours')
legend('MATLAB code', 'GMAT')
grid on

figure(9)
plot(t/3600,a)
hold on
plot(tt/3600,SMA)
ylabel('Semimajor axis (km)')
xlabel('hours')
legend('MATLAB code', 'GMAT')
grid on

function fdot = pert_sv(t,f, Consts, input, spacecraft)

mu      = Consts.muEarth;
mu_Sun  = Consts.muSun;
mu_Moon = Consts.muMoon;

JD0 = input.JD0;
JD = JD0 + t/(3600*24); %Update Julian date

x   = f(1);
y   = f(2);
z   = f(3);
vx  = f(4);
vy  = f(5);
vz  = f(6);

rv = [x y z vx vy vz];
[~, ~, R_Sun]  = solar_position(JD, Consts); %Calculate solar position with respect to the Earth at epoch JD
R_Moon = lunar_position(JD, Consts); %Calculate lunar position with respect to the Earth at epoch JD

%Pertubations
p_aspherical   = EarthGravity(rv, Consts, input);
p_drag         = AtmosphericDrag(rv, Consts, spacecraft);
p_SRP          = SolarRadiationPressure(rv, Consts, spacecraft, JD);
p_SolarGravity = ThirdBodyPertubation(rv,R_Sun,mu_Sun);
p_LunarGravity = ThirdBodyPertubation(rv,R_Moon,mu_Moon);

%Total pertubation acceleration
p_total = p_aspherical + p_drag + p_SRP + p_SolarGravity + p_LunarGravity;

r2 = x*x + y*y + z*z;
r  = sqrt(r2);
r3 = r*r2;
% % 

dxdt  = vx;
dydt  = vy;
dzdt  = vz;
dvxdt = -mu*x/r3 + p_total(1);
dvydt = -mu*y/r3 + p_total(2);
dvzdt = -mu*z/r3 + p_total(3);

fdot =  [dxdt dydt dzdt dvxdt dvydt dvzdt]';

end