clear all
close all
%% spectrum plot
load('x.mat');
load('y.mat');
Fs = 200e6;
res = 50;
RMSinTest = 10*log10(mean(abs(x).^2/res)); % dB
% f = 10e6;
% Ns = Fs/f; % samples in one period
% N = 1000; % number of periods in sim
% t = 0:1/Fs:Ns*N/Fs-1/Fs;
% x = cos(2*pi*f*t) + 1i*sin(2*pi*f*t);
% figure; plot(x);
figure; spectrumPlot(Fs, x);
hold on
% spectrumPlot(Fs, y);
% figure; plot(real(x)); hold on; plot(real(y));
% figure; plot(imag(x)); hold on; plot(imag(y));
% figure; plot(y);
