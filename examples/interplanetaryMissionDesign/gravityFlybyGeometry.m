clear all;

RGB = orderedcolors("gem");
H = rgb2hex(RGB);

% Consider sphere of radius 1 - represents plane

% hyperbola
rP = 1.2;
c = 2.2;
a = rP;
b = c^2 - a^2;
ecc = sqrt(a^2 + b^2) / a;

phiAssymptote = acos(-1 / ecc);
phiArray = linspace(phiAssymptote, -phiAssymptote, 100);

x = -a * cosh(phiArray(20:80)) + 2 * a;
y = -b * sinh(phiArray(20:80));

trajHyperbola = [x; y; zeros(1, length(x))];
trajHyperbola = rotationZ(pi/3 + pi/3) * rotationX(pi/12) * trajHyperbola;

% figure
% plot3(trajHyperbola(1, :), trajHyperbola(2, :), trajHyperbola(3, :));
% axis equal;

vInfInbound = trajHyperbola(1:3, 2) - trajHyperbola(1:3, 1);
vInfInbound = vInfInbound / norm(vInfInbound) * 2;

trajHyperbola = rotvec2matCustom(vInfInbound * -pi/12) * trajHyperbola;

h = cross(trajHyperbola(1:3, 1), trajHyperbola(1:3, end)); % only direction
h = h / norm(h) * 2;

planeVertices = [[1.5; 1.5; 0], ...
                 [-1.5; 1.5; 0], ...
                 [-1.5; -1.5; 0], ...
                 [1.5; -1.5; 0]];

bPlaneNode = cross([0;0;1], vInfInbound) / norm(cross([0;0;1], vInfInbound)) * 2;
bPlanePrecession = atan2(bPlaneNode(2), bPlaneNode(1));
bPlaneNutation = acos(vInfInbound(3) / norm(vInfInbound));

BplaneVertices = rotationZ(bPlanePrecession) * rotationX(bPlaneNutation) * planeVertices;

orbitNode = cross([0; 0; 1], h) / norm(cross([0; 0; 1], h)) * 2;
orbitNodePrecession = atan2(orbitNode(2), orbitNode(1));
orbitNodeNutation = acos(h(3) / norm(h));

orbitPlaneVertices = rotationZ(orbitNodePrecession) * rotationX(orbitNodeNutation) * planeVertices;

figure;
hold on;
axis equal;
axis off;
view(134, 27);
[X,Y,Z] = sphere(1000);
surface(X/5, ...
        Y/5, ...
        Z/5, FaceColor = [0.65, 0.65, 0.65], FaceAlpha=1, EdgeColor="none");

pltX = quiver3(0,0,0, 2, 0, 0, Color=H(2), LineWidth=1, ShowArrowHead="off");
pltY = quiver3(0,0,0, 0, 2, 0, Color=H(5), LineWidth=1, ShowArrowHead="off");
pltZ = quiver3(0,0,0, 0, 0, 2, Color=H(1), LineWidth=1, ShowArrowHead="off");
plot3(-2, -2, -2);

pltVInfInbound = quiver3(0,0,0, ...
                         vInfInbound(1), vInfInbound(2), vInfInbound(3), 'k', LineWidth=1, ShowArrowHead="off");

node1 = cross(vInfInbound, [0; 0; 1]) / norm(cross(vInfInbound, [0; 0; 1])) * 2; 
pltNodeBE = quiver3(0,0,0, ...
                         node1(1), node1(2), node1(3), 'k', LineWidth=1, ShowArrowHead="off");
node2 = cross(h, vInfInbound) / norm(cross(h, vInfInbound)) * 2;
pltNodeBO = quiver3(0,0,0, node2(1), node2(2), node2(3), 'k', LineWidth=1, ShowArrowHead="off");

% axisK = cross(vInfInbound, node1) / norm(cross(vInfInbound, node1)) * 2;, 
% 
% pltKaxis = quiver3(0,0,0, axisK(1), axisK(2), axisK(3), 'k', LineWidth=2);

pltTrajectory = plot3(trajHyperbola(1, :), trajHyperbola(2, :), trajHyperbola(3, :),  'k', LineWidth=1);
pltPeriapsis = plot3(trajHyperbola(1, 30), trajHyperbola(2, 30), trajHyperbola(3, 30), LineWidth=2, Marker="o", MarkerFaceColor="k", MarkerEdgeColor="k");

pltAngMomentum = quiver3(0,0,0, h(1), h(2), h(3), 'k', LineWidth=1, ShowArrowHead="off");

% pltEclPlane = patch('Vertices', planeVertices', 'Faces', [1 2 3 4], ...
%                     'FaceColor', [0.5 0.5 0.5], ...
%                     'EdgeColor', [0.2 0.2 0.2], ...
%                     'EdgeAlpha', 0.15, ...
%                     FaceAlpha=0.8);

pltBPlane = patch('Vertices', BplaneVertices'/1.5, 'Faces', [1 2 3 4], ...
                    'FaceColor', [0.5 0.5 0.5], ...
                    'EdgeColor', [0.2 0.2 0.2], ...
                    'EdgeAlpha', 0.15, ...
                    FaceAlpha=0.8);

% pltOrbitPlane = patch('Vertices', orbitPlaneVertices', 'Faces', [1 2 3 4], ...
%                     'FaceColor', [0.5 0.5 0.5], ...
%                     'EdgeColor', [0.2 0.2 0.2], ...
%                     'EdgeAlpha', 0.15, ...
%                     FaceAlpha=0.8);

% constantplane(vInfInbound,[0 0], 'FaceColor', 'b');
% constantplane(h,[0 0], 'FaceColor', 'g');
axis off;
axis equal;
% view([1, 1, 1]);
