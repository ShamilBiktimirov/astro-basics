function plotcube(p)

% The function plot an animation of the motion of the cube
% with points of the cube for each moment as the initial data
% The points is 3d-array where:
% First dimension coordinates of the point
% Second dimension its distribution in the cube:
% 1-origin, 2-botom along x, 3 botom along y, 4  botom diagonal
% 5,6,7,8 the same, but in the top flore

[n,l,m] = size(p);
side = sqrt((p(1,2,1)-p(1,1,1))^2 + (p(2,2,1)-p(2,1,1))^2 + (p(3,2,1)-p(3,1,1))^2);
% for i = 1:1:l
%     for j =1:1:8
%         p(:,i,j) = p(:,i,j) - [side/2;side/2;side/2];
%     end
% end
%         
edges = points2edges(p(:, 4:end, :));
x = [[0;0;0],[1; 0; 0]]*side;
y = [[0;0;0],[0; 1; 0]]*side;
z = [[0;0;0],[0; 0; 1]]*side;
figure;
plot3(x(1,:), x(2,:), x(3,:), 'r');
hold on;
plot3(y(1,:), y(2,:), y(3,:), 'g');
hold on;
plot3(z(1,:), z(2,:), z(3,:), 'b');
hold on;
axis([-side*4 side*4 -side*4 side*4 -side*4 side*4]);
axis square;
xlabel('x, m');
ylabel('y, m');
zlabel('z, m');
gif('attitude_dynamics.gif','frame',gcf);

for i=1:m
xax = [[0;0;0],p(:,1,i)];
yax = [[0;0;0],p(:,2,i)];
zax = [[0;0;0],p(:,3,i)];

c = plot3(xax(1,:), xax(2,:), xax(3,:),'r',...
          yax(1,:), yax(2,:), yax(3,:),'g',...
          zax(1,:), zax(2,:), zax(3,:),'b',...
          edges(1,:,1,i),edges(2,:,1,i),edges(3,:,1,i),'k',...
          edges(1,:,2,i),edges(2,:,2,i),edges(3,:,2,i),'k',...
          edges(1,:,3,i),edges(2,:,3,i),edges(3,:,3,i),'k',...
          edges(1,:,4,i),edges(2,:,4,i),edges(3,:,4,i),'k',...
          edges(1,:,5,i),edges(2,:,5,i),edges(3,:,5,i),'k',...
          edges(1,:,6,i),edges(2,:,6,i),edges(3,:,6,i),'k',...
          edges(1,:,7,i),edges(2,:,7,i),edges(3,:,7,i),'k',...
          edges(1,:,8,i),edges(2,:,8,i),edges(3,:,8,i),'k',...
          edges(1,:,9,i),edges(2,:,9,i),edges(3,:,9,i),'k',...
          edges(1,:,10,i),edges(2,:,10,i),edges(3,:,10,i),'k',...
          edges(1,:,11,i),edges(2,:,11,i),edges(3,:,11,i),'k',...
          edges(1,:,12,i),edges(2,:,12,i),edges(3,:,12,i),'k');
    gif;
    drawnow;
    pause(0.0001);
    delete(c);

end
end