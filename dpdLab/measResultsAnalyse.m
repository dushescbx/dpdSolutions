% close all;
% clear all;
load('x.mat');
load('y.mat');
figure;
% plot(abs(fft(x)));
% hold on;
plot(abs(fft(y)));

figure; %plot(real(y));
hold on; 
plot(real(x));