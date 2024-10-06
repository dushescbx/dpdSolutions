close all;
load('x.mat');
res = 50;
pindBm = -10; %dBm
pin = 10.^((pindBm-30)/10); % dBm2Watts
x = x./max(x)*sqrt(pin*res);
RMSin = 10*log10(mean(abs(x).^2/res)) + 30;
figure; plot(abs(fft(x)));
PAPR = 20*log10(max(abs(x))*sqrt(length(x))/norm(x));
[y, RMSout, Idc, Vdc] = RFWebLab_PA_meas_v1_2(x, RMSin);