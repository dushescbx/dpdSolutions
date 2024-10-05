clear all
close all
clc
M = 1;
K = 1;
gain = 10;
a_coef = gain*reshape((1:M*K), M*K, 1).*ones(M*K,1);
a_coefInit = ones(M*K,1);
mu = 0.1;
% reshape()

% for k = 0:K-1
%     for m = 0:M-1
%         a(1+M*k+m) = 1+M*k+m;
%     end
% end
% figure;
% plot(a);