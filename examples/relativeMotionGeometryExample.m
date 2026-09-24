clear all;

rho1 = 200;
rho2 = 50;
alpha1 = pi/4;
alpha2 = pi/2;
c1 = 0;
c4 = 300;

cState = [c1; rho1; rho2; c4; alpha1; alpha2];

period = calcPeriodKeplerian(Consts.rEarth + 400e3);
n = 2 * pi / period;

rv = hcwConstants2StateProp(cState, n);

% Surface parametrization
theta = linspace(0, 2*pi, 120);
y = linspace(-rho2, rho2, 30);

[T, Y] = meshgrid(theta, y);
X = c4 + rho1*cos(T);
Z = (rho1/2)*sin(T);


figure('Color','w');

subplot(2, 3, [1 2 3]);
hold on;
plot3(rv(1, :), rv(2, :), rv(3, :), 'k', 'LineWidth', 2);

plot3(0, 0, 0, 'ok');
quiver3(0, 0, 0, 50, 0, 0, 'off', 'Color', 'r', 'LineWidth', 2);
quiver3(0, 0, 0, 0, 50, 0, 'off', 'Color', 'g', 'LineWidth', 2);
quiver3(0, 0, 0, 0, 0, 50, 'off', 'Color', 'b', 'LineWidth', 2);

surf(X, Y, Z, ...
    'FaceColor', [0.55 0.45 0.75], ...
    'FaceAlpha', 0.25, ...
    'EdgeColor', 'none');

% axis equal;
axis off
xlabel('x');
xlabel('y');
xlabel('m');
view(5, 11);

subplot(2, 3, 4);
hold on;
plot(rv(1, :) - c4, rv(3, :), 'k', 'LineWidth', 2);
xlabel('T - c_4');
ylabel('R');
grid on;
axis equal;

subplot(2, 3, 5);
hold on;
plot(rv(2, :), rv(1, :) - c4, 'k', 'LineWidth', 2);
xlabel('N');
ylabel('T - c_4');
grid on;
axis equal;

subplot(2, 3, 6);
hold on;
plot(rv(2, :), rv(3, :), 'k', 'LineWidth', 2);
xlabel('N');
ylabel('R');
grid on;
axis equal;


fontsize(20, "points");
step = 200;
for pointIdx = 1:step:size(rv, 2)

    subplot(2, 3, [1 2 3]);
    p1 = plot3(rv(1, pointIdx), rv(2, pointIdx), rv(3, pointIdx), 'ok', 'MarkerFaceColor','k');

    subplot(2, 3, 4);
    p2 = plot(rv(1, pointIdx) - c4, rv(3, pointIdx), 'ok', 'MarkerFaceColor','k');

    subplot(2, 3, 5);
    p3 = plot(rv(2, pointIdx), rv(1, pointIdx) - c4, 'ok', 'MarkerFaceColor','k');

    subplot(2, 3, 6);
    p4 = plot(rv(2, pointIdx), rv(3, pointIdx), 'ok', 'MarkerFaceColor','k');

    drawnow;
    delete(p1);
    delete(p2);
    delete(p3);
    delete(p4);
end
