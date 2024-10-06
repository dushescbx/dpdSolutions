clear all
close all
clc
rng(1)
if exist('functions','dir')
    p = genpath('functions');
    addpath(p);
end
%%
Fs = 1000;                    % Sampling frequency
T = 1/Fs;                     % Sampling period
L = 1e6;                     % Length of signal
nIter = 3;                    % freqency iterations number
%%
t = (0:L-1)*T;                % Time vector
x1 = cos(2*pi*50*t);          % First row wave
x2 = cos(2*pi*150*t);         % Second row wave
x3 = cos(2*pi*300*t);         % Third row wave
%%
% X = sum([x1; x2; x3], 1) + 0.2*randn(size(x1));
X = complex(randn(size(x1)), randn(size(x1)));
n = 2^nextpow2(L);
Y = fft(X);

P2 = abs(Y/L);
P1 = P2(:,1:n/2+1);
P1(:,2:end-1) = 2*P1(:,2:end-1);

% figure;
% plot(P2)
%% split fft 100
figEn = 1;
% nAr = [1 100 250 length(Y)/2]; %
nAr = floor(linspace(1, length(Y), nIter+1));
y1 = splitFFT(nAr, Y, figEn);

%% inv fft
Xi = ifft(Y);
Xt = (ifft(sum(y1, 1)));

% figure; plot(d);
% figure; plot(real(Xt));
% figure; plot(real(Xi));
%

subplot(1, length(nAr), length(nAr));
plot(abs(Xt(1:length(X)) - X)./abs(X));
figure; plot(abs(Xt(1:length(X)) - X));
meanAbsError = mean(abs(Xt(1:length(X)) - X));
xlabel('n (sample)');
ylabel('absolute error');
set(findall(gcf,'-property','FontSize'),'FontSize',18)
