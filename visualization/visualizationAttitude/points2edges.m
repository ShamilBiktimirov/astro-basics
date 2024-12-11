function edges = points2edges(p)

for i = 1:length(p)
edges(:,:,1,i) = [p(:,1,i),p(:,2,i)];
edges(:,:,2,i) = [p(:,2,i),p(:,3,i)];
edges(:,:,3,i) = [p(:,3,i),p(:,4,i)];
edges(:,:,4,i) = [p(:,4,i),p(:,1,i)];
edges(:,:,5,i) = [p(:,5,i),p(:,6,i)];
edges(:,:,6,i) = [p(:,6,i),p(:,7,i)];
edges(:,:,7,i) = [p(:,7,i),p(:,8,i)];
edges(:,:,8,i) = [p(:,8,i),p(:,5,i)];
edges(:,:,9,i) = [p(:,1,i),p(:,5,i)];
edges(:,:,10,i) = [p(:,2,i),p(:,6,i)];
edges(:,:,11,i) = [p(:,4,i),p(:,8,i)];
edges(:,:,12,i) = [p(:,3,i),p(:,7,i)];

end