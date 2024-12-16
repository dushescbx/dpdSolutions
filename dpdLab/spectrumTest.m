clear all
close all
%%
if exist('meas','dir')
    p = genpath('meas');
    addpath(p);
end
%% spectrum plot
load('meas/x.mat');
load('meas/y_pindBm=-35.mat');
Fs = 200e6;
res = 50;
RMSinTest = 10*log10(mean(abs(x).^2/res)); % dB
figure; spectrumPlot(Fs, x);
hold on
spectrumPlot(Fs, y);
figure; plot(real(x)); hold on; plot(real(y));
figure; plot(imag(x)); hold on; plot(imag(y));
% figure; plot(y);
