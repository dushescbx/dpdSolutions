function data_out = apsk_mod
M = [4 8 20];
modOrder = sum(M);
radii = [0.3 0.7 1.2];
x_mat = randi([0 modOrder-1],1e5,1);
data_out = apskmod(x_mat,M,radii);
scatterplot(data_out)
title('data in');
end