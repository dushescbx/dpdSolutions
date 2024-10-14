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
spectrumPlot(Fs, x);
% spectrumPlot(Fs, y);
figure; plot(real(x)); hold on; plot(real(y));
function spectrumPlot(Fs, x)
% t = 0:1/Fs:1-1/Fs;
y = fft(x);
z = fftshift(y);
ly = length(y);
f = (-ly/2:ly/2-1)/ly*Fs;
figure;plot(f,mag2db(abs(z)/length(z)))
title("Double-Sided Amplitude Spectrum of x(t)")
xlabel("Frequency (Hz)")
ylabel("|y|")
grid

tol = 1e-6;
z(abs(z) < tol) = 0;

theta = angle(z);
% figure;
% stem(f,theta/pi)
% title("Phase Spectrum of x(t)")
% xlabel("Frequency (Hz)")
% ylabel("Phase/\pi")
% grid
end