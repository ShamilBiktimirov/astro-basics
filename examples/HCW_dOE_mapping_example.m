clear all
clc
close all

% define cheif orbital elements
OEc = [Consts.rEarth + 400e3; 0.00001; 40 * pi/180; 0 * pi/180; 0 * pi/180; 0 * pi/180];
meanMotion     = sqrt(Consts.muEarth / OEc(1)^3);
rvECIc = oe2rv(OEc);

% define HCW constants
c1 = 10; 
c4 = 10; 
pho1 = 1000;
pho2 = 0; 
alpha1 = 0; 
alpha2 = 0; 


% convert HCW to rv relative orbital frame

rvOrbHCW = hcwConstants2StateProp([c1; ...
                                   pho1; ...
                                   pho2; ...
                                   c4; ...
                                   alpha1; ...
                                   alpha2], ...
                                   meanMotion);




plot3(rvOrbHCW(1, :), rvOrbHCW(2, :), rvOrbHCW(3, :) )
xlabel('along track');
ylabel('out of plane');
zlabel('radial')


Theta = 0:0.1:6*pi;

for i = 1:length(Theta)
    da = -2 * c1;
    de = pho1/2/OEc(1);
    di = 2 * pho2 / OEc(1);
    dM = c4/OEc(1);
    OEc(6) = Theta(i);
    dOE = [da; de; di; 0; 0; dM]; %[da, de, di, dRAAN, domega, dM]
    rvOrbdOE(:, i) = nearCircdOE2rvorb(dOE, OEc);
end

figure
plot3(rvOrbdOE(2, :), rvOrbdOE(3, :), rvOrbdOE(1, :))
xlabel('along track');
zlabel('radial');
ylabel('out of plane')

