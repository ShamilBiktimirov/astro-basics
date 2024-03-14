function ap = EarthGravity(rv, JD, Consts, input)

%Get constants and user inputs
mu    = Consts.muEarth;
R     = Consts.rEarthEquatorial;
wE    = Consts.wEarth;
degree = input.degree;
order = input.order;

 if(order > degree)
    error('Order cannot be larger than degree')
 end

%Convert into Earth-fixed (rotating) frame (cosidering earth rotation only)
theta = wE*(JD-2451545.5)*(24*3600);

%Transformation matrix
Q = [cos(theta)  sin(theta)  0;
     -sin(theta) cos(theta)  0;
     0           0           1];

r_bf  = Q*rv(1:3)';

x = r_bf(1);
y = r_bf(2);
z = r_bf(3);

r = norm(r_bf);
C = zeros(5,5);
S = zeros(5,5);


%EGM-01 coefficients from Vallado (TableS D-1 and D-2)
% C(2,1:3) = [-0.001082626724393, -2.66739475237484E-10,  1.57461532572292E-06];
% S(2,1:3) = [0                    ,  1.78727064852404E-09, -9.03872789196567E-07];
% 
% C(3,1:4) = [2.53241051856772E-06 ,  2.19314963131333E-06,  3.09043900391649E-07, 1.00583513408823E-07];
% S(3,1:4) = [0                    ,  2.68087089400898E-07, -2.11430620933483E-07, 1.97221581835718E-07];
% 
% C(4,1:5) = [1.61989759991697E-06, -5.08643560439584E-07, 7.83745457404552E-08,  5.92150177639666E-08, -3.98320424873187E-09];
% S(4,1:5) = [0                   , -4.49265432143808E-07, 1.48135037248860E-07, -1.20094612622961E-08,  6.52467287187687E-09];
% 
% C(5,1:6) = [2.27753590730836E-07, -5.38824899516695E-08,  1.05528866715599E-07, -1.49264876546633E-08, -2.29951140350422E-09,  4.30428041979182E-10];
% S(5,1:6) = [0                   , -8.08134749120457E-08, -5.23297729692969E-08, -7.10091727223769E-09,  3.87811503746114E-10, -1.64817193269055E-09];

%JGM-02 coefficients from GMAT
C(2,1:3) = [ -0.001082626724393,  -2.414000052222093e-10,  1.57461532572292E-06];
S(2,1:3) = [0                    , 1.574421758350994e-06, -9.037666669616874e-07];

C(3,1:4) = [2.532307818191775e-06 ,  2.190922081404716e-06,  3.089143533816487e-07, 1.005601040626586e-07];
S(3,1:4) = [0                     ,  2.687418863136855e-07, -2.115075122835371e-07, 1.971780250456937e-07];

C(4,1:5) = [1.620429990000000e-06, -5.088433157745930e-07, 7.834048953908266e-08,  5.917924178248455e-08, -3.982546443559899e-09];
S(4,1:5) = [0                    , -4.491281704606470e-07, 1.482219920570510e-07, -1.201263975958658e-08,  6.525548406274755e-09];

C(5,1:6) = [2.270711043920343e-07, -5.062850454573727e-08,  1.057407806740425e-07, -1.492828993315676e-08, -2.297575180964277e-09,  4.308201396626214e-10];
S(5,1:6) = [0                    , -8.180935693958488e-08, -5.239861381081096e-08, -7.105580790722052e-09,  3.867447526359026e-10, -1.648837413307390e-09];


% Auxilliary variables
Rr    = R/r;
mur   = mu/r;
mur2  = mu/(r*r);

sphi = z/r; % sin(psi): psi = latitude
phi = asin(sphi);
lambda = atan2(y,x); % longitude

dUdr      = 0;
dUdpsi    = 0;
dUdlambda = 0;

%Calculate gradient of gravity potential (Vallado, page 577)
for l = 2:degree
    P = legendre(l,sphi);
    for m = 0:l
        if(mod(m+1,2) ==0) 
            P(m+1) = -P(m+1);
        end
         dUdr = dUdr - mur2*Rr^l*(l+1)*P(m+1)...
             *(C(l,m+1)*cos(m*lambda)+S(l,m+1)*sin(m*lambda));
         dUdlambda =  dUdlambda + mur*Rr^l*m*P(m+1)...
             *(S(l,m+1)*cos(m*lambda) - C(l,m+1)*sin(m*lambda));
    end
    for mm = 0:l-1
        dUdpsi = dUdpsi +  mur*(Rr^l*P(mm+2) - mm*tan(phi)*P(mm+1))...
             *(C(l,mm+1)*cos(mm*lambda)+S(l,mm+1)*sin(mm*lambda));
    end
end

a1 = (1/r)*dUdr - (z*dUdpsi/(r*r*sqrt(x*x+y*y)));
a2 = dUdlambda/(x*x + y*y);

%Perturbing acceleration
ax = a1*x - a2*y;
ay = a1*y + a2*x;
az = dUdr*z/r + sqrt(x*x + y*y)*dUdpsi/(r*r);
ap_bf = [ax ay az]'; %Peturbation accelaration in body-axis coordinate frame

%Convert into inertial frame
ap = Q'*ap_bf;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----Alternative method----
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rp = sqrt(x*x + y*y);
% drdrvec      = [x y z]'/r;
% dpsidrvec    = (1/rp)*(-[x y z]'*z/(r*r) + [0 0 1]');
% dlambdadrvec = (1/(rp*rp))*(x*[0 1 0]' - y*[1 0 0]');
% 
% %Perturbing acceleration
% ap_bf = [dUdr*drdrvec + dUdpsi*dpsidrvec + dUdlambda*dlambdadrvec]'

