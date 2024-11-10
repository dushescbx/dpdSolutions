function data_in_mat = apsk_save
%% Задаем модуляцию
M = [4 8 20];
modOrder = sum(M);
radii = [0.3 0.7 1.2];
x_mat = randi([0 modOrder-1],1e5,1);
data_in_mat = apskmod(x_mat,M,radii);
scatterplot(data_in_mat)
title('data in');
save('data_in_mat.mat','data_in_mat');
end