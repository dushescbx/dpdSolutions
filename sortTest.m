clear all
close all
rng(0);
A = randi(10, 3, 3);
[B, I] = sort(A(:, 1));