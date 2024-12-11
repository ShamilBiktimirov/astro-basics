function rotation_animation(dim, q_vec)

l = dim(1);
w = dim(2);
h = dim(3);

px = [l/2;0;0];
py = [0;l/2;0];
pz = [0;0;l/2];
p1 = [l/2;w/2;-h/2];
p2 = [-l/2;w/2;-h/2];
p3 = [-l/2;-w/2;-h/2];
p4 = [l/2;-w/2;-h/2];
p5 = [l/2;w/2;h/2];
p6 = [-l/2;w/2;h/2];
p7 = [-l/2;-w/2;h/2];
p8 = [l/2;-w/2;h/2];

p = [px, py, pz, p1,p2,p3,p4,p5,p6,p7,p8];

p_vec = [];
for i = 1:size(q_vec,2)
   for j = 1:size(p,2)
   p_vec(:,j,i) = rotateB2I(p(:,j),q_vec(:,i));
   end
end

plotcube(p_vec);

end
