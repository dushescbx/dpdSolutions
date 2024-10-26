load('x.mat');
res = 50;
RMSinTest = 10*log10(mean(abs(x).^2/res)) + 30; % dB to dBm
RMSin = 10*log10( norm(x)^2/50/length(x));