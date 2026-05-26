clc; clear; close all

FS = 24;
%% Low-resolution convex asteroid

nTheta = 18;
nPhi   = 9;

[theta,phi] = meshgrid( ...
    linspace(0,2*pi,nTheta), ...
    linspace(0,pi,nPhi));

a = 1.2;
b = 0.85;
c = 0.65;

R = 1 ...
    + 0.05*sin(3*theta).*sin(2*phi) ...
    + 0.02*cos(5*theta).*sin(phi).^2 ...
    + 0.02*sin(4*phi + 2*theta);

x = a*R.*sin(phi).*cos(theta);
y = b*R.*sin(phi).*sin(theta);
z = c*R.*cos(phi);

%% Convex polyhedron

V = [x(:), y(:), z(:)];
V = unique(round(V,8),'rows');

F = convhull(V(:,1),V(:,2),V(:,3));

%% Camera setup

camPosition = [4 -3 2];
camTarget   = [0 0 0];

viewDir = camTarget - camPosition;
viewDir = viewDir/norm(viewDir);

%% Facet normals

v1 = V(F(:,1),:);
v2 = V(F(:,2),:);
v3 = V(F(:,3),:);

fc = (v1 + v2 + v3)/3;

fn = cross(v2-v1, v3-v1, 2);
fn = fn ./ vecnorm(fn,2,2);

bad = dot(fn,fc,2) < 0;
fn(bad,:) = -fn(bad,:);

frontFace = dot(fn,repmat(-viewDir,size(fn,1),1),2) > 0;

%% View setup first

figure('Color','w'); hold on
axis equal off
view(8,13)
camproj perspective

set(gca,'SortMethod','depth')

drawnow   % важно: MATLAB обновит camera position после view()

camPosition = campos;
camTarget   = camtarget;

viewDir = camTarget - camPosition;
viewDir = viewDir/norm(viewDir);

%% Facet normals and front/back classification

v1 = V(F(:,1),:);
v2 = V(F(:,2),:);
v3 = V(F(:,3),:);

fc = (v1 + v2 + v3)/3;

fn = cross(v2-v1, v3-v1, 2);
fn = fn ./ vecnorm(fn,2,2);

% outward normals
bad = dot(fn,fc,2) < 0;
fn(bad,:) = -fn(bad,:);

% faces visible from current camera
frontFace = dot(fn,repmat(-viewDir,size(fn,1),1),2) > 0;

%% Plot asteroid wireframe

% back/hidden edges — faint gray
patch('Faces',F(~frontFace,:), ...
      'Vertices',V, ...
      'FaceColor','none', ...
      'EdgeColor',[0.82 0.82 0.82], ...
      'EdgeAlpha',0.25, ...
      'LineWidth',0.40);

% front/visible edges — black
patch('Faces',F(frontFace,:), ...
      'Vertices',V, ...
      'FaceColor','none', ...
      'EdgeColor','k', ...
      'LineWidth',1.25);


%% Cone, rays, position vector, and local bases

% MATLAB-like colors
matlabBlue  = [0.0000 0.4470 0.7410];
matlabRed   = [0.8500 0.3250 0.0980];
matlabGreen = [0.4660 0.6740 0.1880];

%% Geometry

O_A = [0 0 0];

% Cone apex / spacecraft position
r_L = [0.3 -0.5 2];
C   = r_L;

% Cone direction: adjusted to intersect roughly half of asteroid
r_C = [0.72 0.18 -0.82];
r_C = rotationZ(pi/10) * rotationY(pi/10) * r_C';
r_C = r_C';
r_C = r_C/norm(r_C);

thetaFOV = deg2rad(15);
Nray     = 25;
L        = 3.0;

%% Spacecraft/body frame B

% y_B is opposite to cone direction
yB = -r_C;

% z_B aesthetically points upward as much as possible
zUp = [0 0 1];
zB = zUp - dot(zUp,yB)*yB;

if norm(zB) < 1e-8
    zUp = [1 0 0];
    zB = zUp - dot(zUp,yB)*yB;
end

zB = zB/norm(zB);

% right-handed basis
xB = cross(yB,zB);
xB = xB/norm(xB);

zB = cross(xB,yB);
zB = zB/norm(zB);

% Cone transverse basis
u = xB;
v = zB;

%% Uniform rays inside cone + boundary rays on cone surface

Ninner   = 15;   % internal rays
Nboundary = 12;  % rays exactly on cone surface

dirs = zeros(Ninner + Nboundary,3);

% Internal Fibonacci-like rays
for k = 1:Ninner
    rho = sqrt((k-0.5)/Ninner);
    ang = k*pi*(3-sqrt(5));

    alpha = rho*thetaFOV;

    dirs(k,:) = cos(alpha)*r_C + ...
                sin(alpha)*(cos(ang)*u + sin(ang)*v);

    dirs(k,:) = dirs(k,:)/norm(dirs(k,:));
end

% Boundary rays: alpha = thetaFOV
for k = 1:Nboundary
    ang = 2*pi*(k-1)/Nboundary;

    idx = Ninner + k;

    dirs(idx,:) = cos(thetaFOV)*r_C + ...
                  sin(thetaFOV)*(cos(ang)*u + sin(ang)*v);

    dirs(idx,:) = dirs(idx,:)/norm(dirs(idx,:));
end

Nray = size(dirs,1);
%% Transparent cone surface

Nedge = 90;
edgePts = zeros(Nedge,3);

for k = 1:Nedge
    ang = 2*pi*(k-1)/Nedge;

    d = cos(thetaFOV)*r_C + ...
        sin(thetaFOV)*(cos(ang)*u + sin(ang)*v);

    d = d/norm(d);
    edgePts(k,:) = C + L*d;
end

Xc = [repmat(C(1),1,Nedge+1); edgePts([1:end 1],1)'];
Yc = [repmat(C(2),1,Nedge+1); edgePts([1:end 1],2)'];
Zc = [repmat(C(3),1,Nedge+1); edgePts([1:end 1],3)'];

surf(Xc,Yc,Zc, ...
     'FaceColor',[0.65 0.65 0.65], ...
     'FaceAlpha',0.22, ...
     'EdgeColor','none');

%% Dim rays

% for k = 1:Nray
% 
%     % Ray intersects asteroid
%     if hitNear(k)
% 
%         Q = P_near(k,:);
% 
%         plot3([C(1) Q(1)], ...
%               [C(2) Q(2)], ...
%               [C(3) Q(3)], ...
%               'k-', ...
%               'LineWidth',1.0);
% 
%     % Ray misses asteroid
%     else
% 
%         Q = C + L*dirs(k,:);
% 
%         plot3([C(1) Q(1)], ...
%               [C(2) Q(2)], ...
%               [C(3) Q(3)], ...
%               '-', ...
%               'Color',[0 0 0 0.18], ...
%               'LineWidth',0.45);
% 
%     end
% end
% 
%% Position vector r_L

quiver3(O_A(1),O_A(2),O_A(3), ...
        r_L(1),r_L(2),r_L(3), ...
        0, ...
        'k', ...
        'LineWidth',1.5, ...
        'ShowArrowHead', 'off');

text(0.55*r_L(1), ...
     0.55*r_L(2), ...
     0.55*r_L(3)+0.06, ...
     '$\mathbf{r}_L$', ...
     'Interpreter','latex', ...
     'FontSize',15);

%% Asteroid frame A

basisScaleA = 0.35;

quiver3(O_A(1),O_A(2),O_A(3),basisScaleA,0,0, ...
        0,'Color',matlabRed,'LineWidth',3,'MaxHeadSize',0.7);
quiver3(O_A(1),O_A(2),O_A(3),0,basisScaleA,0, ...
        0,'Color',matlabGreen,'LineWidth',3,'MaxHeadSize',0.7);
quiver3(O_A(1),O_A(2),O_A(3),0,0,basisScaleA, ...
        0,'Color',matlabBlue,'LineWidth',3,'MaxHeadSize',0.7);

text(basisScaleA*1.12,0,0,'$x^{\mathcal{A}}$','Interpreter','latex','FontSize',12,'Color',matlabRed);
text(0,basisScaleA*1.12,0,'$y^{\mathcal{A}}$','Interpreter','latex','FontSize',12,'Color',matlabGreen);
text(0,0,basisScaleA*1.12,'$z^{\mathcal{A}}$','Interpreter','latex','FontSize',12,'Color',matlabBlue);

%% Spacecraft/body frame B at cone apex

basisScaleB = 0.28;

quiver3(C(1),C(2),C(3), ...
        basisScaleB*xB(1),basisScaleB*xB(2),basisScaleB*xB(3), ...
        0,'Color',matlabRed,'LineWidth',3,'MaxHeadSize',0.7);

quiver3(C(1),C(2),C(3), ...
        basisScaleB*yB(1),basisScaleB*yB(2),basisScaleB*yB(3), ...
        0,'Color',matlabGreen,'LineWidth',3,'MaxHeadSize',0.7);

quiver3(C(1),C(2),C(3), ...
        basisScaleB*zB(1),basisScaleB*zB(2),basisScaleB*zB(3), ...
        0,'Color',matlabBlue,'LineWidth',3,'MaxHeadSize',0.7);

text(C(1)+basisScaleB*1.15*xB(1), ...
     C(2)+basisScaleB*1.15*xB(2), ...
     C(3)+basisScaleB*1.15*xB(3), ...
     '$x^{\mathcal{B}}$','Interpreter','latex','FontSize',12,'Color',matlabRed);

text(C(1)+basisScaleB*1.15*yB(1), ...
     C(2)+basisScaleB*1.15*yB(2), ...
     C(3)+basisScaleB*1.15*yB(3), ...
     '$y^{\mathcal{B}}$','Interpreter','latex','FontSize',12,'Color',matlabGreen);

text(C(1)+basisScaleB*1.15*zB(1), ...
     C(2)+basisScaleB*1.15*zB(2), ...
     C(3)+basisScaleB*1.15*zB(3), ...
     '$z^{\mathcal{B}}$','Interpreter','latex','FontSize',12,'Color',matlabBlue);

%% Short thick cone direction vector r_C

% dirScale = 0.38;
% 
% quiver3(C(1),C(2),C(3), ...
%         dirScale*r_C(1), ...
%         dirScale*r_C(2), ...
%         dirScale*r_C(3), ...
%         0, ...
%         'k', ...
%         'LineWidth',2.4, ...
%         'MaxHeadSize',1.0);
% 
% text(C(1)+dirScale*1.12*r_C(1), ...
%      C(2)+dirScale*1.12*r_C(2), ...
%      C(3)+dirScale*1.12*r_C(3), ...
%      '$\mathbf{r}_C$', ...
%      'Interpreter','latex', ...
%      'FontSize',14);
% 
% %% Apex marker only
% 
% plot3(C(1),C(2),C(3), ...
%       'ko', ...
%       'MarkerFaceColor','k', ...
%       'MarkerSize',5);



%% Ray-facet intersections: nearest and farthest points

% Triangle vertices
v1 = V(F(:,1),:);
v2 = V(F(:,2),:);
v3 = V(F(:,3),:);

P_near = nan(Nray,3);
P_far  = nan(Nray,3);

hitNear = false(Nray,1);
hitFar  = false(Nray,1);

for i = 1:Nray

    t_all = [];

    for j = 1:size(F,1)

        [hit,t] = rayTriangleIntersection( ...
            C, dirs(i,:), v1(j,:), v2(j,:), v3(j,:));

        if hit && t > 1e-7
            t_all(end+1) = t; %#ok<SAGROW>
        end
    end

    t_all = unique(round(t_all,8));
    t_all = sort(t_all);

    % nearest intersection
    if ~isempty(t_all)
        hitNear(i) = true;
        P_near(i,:) = C + t_all(1)*dirs(i,:);
    end

    % farthest / second-side intersection
    if numel(t_all) >= 2
        hitFar(i) = true;
        P_far(i,:) = C + t_all(end)*dirs(i,:);
    end
end

%% Plot rays with hit/miss style

%% Plot rays with hit/miss style, extended to cone end

for k = 1:Nray

    Q_end = C + L*dirs(k,:);

    if hitNear(k)

        Q_hit = P_near(k,:);

        % Visible part before nearest intersection
        plot3([C(1) Q_hit(1)], ...
              [C(2) Q_hit(2)], ...
              [C(3) Q_hit(3)], ...
              'k-', ...
              'Color', [0 0 0 0.4], ...
              'LineWidth',1.0);

        % Continuation after intersection to cone end
        plot3([Q_hit(1) Q_end(1)], ...
              [Q_hit(2) Q_end(2)], ...
              [Q_hit(3) Q_end(3)], ...
              '-', ...
              'Color',[0 0 0 0.18], ...
              'LineWidth',0.45);

    else

        % Missed ray
        plot3([C(1) Q_end(1)], ...
              [C(2) Q_end(2)], ...
              [C(3) Q_end(3)], ...
              '-', ...
              'Color',[0 0 0 0.18], ...
              'LineWidth',0.45);

    end
end

%% Sun direction in asteroid frame A

rhat_Sun = [-0.5 -1 0];
rhat_Sun = rhat_Sun/norm(rhat_Sun);

sunScale = 0.58;

sunColor = [0.93 0.55 0.05];

quiver3(O_A(1),O_A(2),O_A(3), ...
        sunScale*rhat_Sun(1), ...
        sunScale*rhat_Sun(2), ...
        sunScale*rhat_Sun(3), ...
        0, ...
        'Color',sunColor, ...
        'LineWidth',3.0, ...
        'MaxHeadSize',1.0);

text(O_A(1)+1.15*sunScale*rhat_Sun(1), ...
     O_A(2)+1.15*sunScale*rhat_Sun(2), ...
     O_A(3)+1.15*sunScale*rhat_Sun(3), ...
     '$\hat{\mathbf r}_{\mathrm{Sun}}$', ...
     'Interpreter','latex', ...
     'FontSize',24, ...
     'Color',sunColor);

%% Covered surface split into illuminated and shadowed parts

P_cov = P_near(hitNear,:);

if size(P_cov,1) >= 4

    % Triangulate covered points
    F_cov = convhull(P_cov(:,1), P_cov(:,2), P_cov(:,3));

    % Facet vertices
    c1 = P_cov(F_cov(:,1),:);
    c2 = P_cov(F_cov(:,2),:);
    c3 = P_cov(F_cov(:,3),:);

    % Facet centers and normals
    c_center = (c1 + c2 + c3)/3;

    c_norm = cross(c2-c1, c3-c1, 2);
    c_norm = c_norm ./ vecnorm(c_norm,2,2);

    % Make normals approximately outward
    bad = dot(c_norm,c_center,2) < 0;
    c_norm(bad,:) = -c_norm(bad,:);

    % Illumination condition
    illumCov = c_norm*rhat_Sun(:) > 0;

% Covered but shadowed: muted red
patch('Faces',F_cov(~illumCov,:), ...
      'Vertices',P_cov, ...
      'FaceColor',[0.75 0.35 0.28], ...
      'FaceAlpha',0.50, ...
      'EdgeColor',[0.65 0.25 0.20], ...
      'LineWidth',1);

    % Covered and illuminated: green
    patch('Faces',F_cov(illumCov,:), ...
          'Vertices',P_cov, ...
          'FaceColor',[0.4660 0.6740 0.1880], ...
          'FaceAlpha',0.60, ...
          'EdgeColor',[0.4660 0.6740 0.1880], ...
          'LineWidth',1.6);
end
%% Plot intersection points

% nearest points: green
plot3(P_near(hitNear,1), ...
      P_near(hitNear,2), ...
      P_near(hitNear,3), ...
      'o', ...
      'MarkerFaceColor',[0.4660 0.6740 0.1880], ...
      'MarkerEdgeColor','k', ...
      'MarkerSize', 5);

% farthest points: red
plot3(P_far(hitFar,1), ...
      P_far(hitFar,2), ...
      P_far(hitFar,3), ...
      'o', ...
      'MarkerFaceColor',[0.8500 0.3250 0.0980], ...
      'MarkerEdgeColor','k', ...
      'MarkerSize', 4);


%% Radius vector to one selected ray-facet intersection point

% idxHit = find(hitNear,1,'first');   % choose first available intersection
idxHit = 24;
if ~isempty(idxHit)

    r_Ip = P_near(idxHit,:);

    % radius vector from asteroid center to intersection point
    quiver3(O_A(1),O_A(2),O_A(3), ...
            r_Ip(1),r_Ip(2),r_Ip(3), ...
            0, ...
            'Color',[0.15 0.15 0.15], ...
            'LineWidth',2.0, ...
            'MaxHeadSize',0.55);

    % highlight selected intersection point
    plot3(r_Ip(1),r_Ip(2),r_Ip(3), ...
          'o', ...
          'MarkerFaceColor',[1 1 1], ...
          'MarkerEdgeColor','k', ...
          'MarkerSize',7, ...
          'LineWidth',1.3);

    % label
    text(0.58*r_Ip(1), ...
         0.58*r_Ip(2), ...
         0.58*r_Ip(3)+0.06, ...
         '$\mathbf{r}_{\mathrm{I}_p}$', ...
         'Interpreter','latex', ...
         'FontSize',FS, ...
         'Color',[0.15 0.15 0.15]);
end
%% Additional vector annotations

% Choose a visible vertex of the polyhedron
iV = 30;
r_Vi = V(iV,:);

% Radius vector to i-th vertex
quiver3(0,0,0, ...
        r_Vi(1),r_Vi(2),r_Vi(3), ...
        0, ...
        'Color',[0.25 0.25 0.25], ...
        'LineWidth',1.8, ...
        'MaxHeadSize',1);

text(0.55*r_Vi(1), ...
     0.55*r_Vi(2), ...
     0.55*r_Vi(3)+0.05, ...
     '$\mathbf{r}_{\mathrm{V}_i}$', ...
     'Interpreter','latex', ...
     'FontSize',24);

% Mark the selected vertex
plot3(r_Vi(1),r_Vi(2),r_Vi(3), ...
      'ko', ...
      'MarkerFaceColor','w', ...
      'MarkerSize',5);

%% Unit vector of j-th ray

jR = 20;                         % choose visible ray
rhat_Rj = dirs(jR,:)/norm(dirs(jR,:));

rayScale = 0.45;

quiver3(C(1),C(2),C(3), ...
        rayScale*rhat_Rj(1), ...
        rayScale*rhat_Rj(2), ...
        rayScale*rhat_Rj(3), ...
        0, ...
        'Color',[0.15 0.15 0.15], ...
        'LineWidth',2.0, ...
        'MaxHeadSize',0.75);

text(C(1)+rayScale*1.15*rhat_Rj(1), ...
     C(2)+rayScale*1.15*rhat_Rj(2), ...
     C(3)+rayScale*1.15*rhat_Rj(3), ...
     '$\hat{\mathbf{r}}_{\mathrm{R}_k}$', ...
     'Interpreter','latex', ...
     'FontSize',24);

%% Rename cone direction vector label to rhat_C

dirScale = 0.38;

quiver3(C(1),C(2),C(3), ...
        dirScale*r_C(1), ...
        dirScale*r_C(2), ...
        dirScale*r_C(3), ...
        0, ...
        'k', ...
        'LineWidth',2.6, ...
        'MaxHeadSize',1.0);

text(C(1)+dirScale*1.12*r_C(1), ...
     C(2)+dirScale*1.12*r_C(2), ...
     C(3)+dirScale*1.12*r_C(3), ...
     '$\hat{\mathbf{r}}_\mathrm{C}$', ...
     'Interpreter','latex', ...
     'FontSize',24);

function [hit,t] = rayTriangleIntersection(O,D,V0,V1,V2)

epsVal = 1e-9;

E1 = V1 - V0;
E2 = V2 - V0;

P = cross(D,E2);
detA = dot(E1,P);

if abs(detA) < epsVal
    hit = false;
    t = nan;
    return
end

invDet = 1/detA;

T = O - V0;
u = dot(T,P)*invDet;

if u < 0 || u > 1
    hit = false;
    t = nan;
    return
end

Q = cross(T,E1);
v = dot(D,Q)*invDet;

if v < 0 || (u + v) > 1
    hit = false;
    t = nan;
    return
end

t = dot(E2,Q)*invDet;

hit = t > epsVal;

end

fontsize(24, "points");

exportgraphics(gcf, ...
    'coverage_illustration.png', ...
    'Resolution',800);