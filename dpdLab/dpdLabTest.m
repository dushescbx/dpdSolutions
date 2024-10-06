close all;
nSamp = 1e6;
res = 50;
pindBm = -10; %dBm
pin = 10.^((pindBm-30)/10); % dBm2Watts

x = complex(randn(1, nSamp), randn(1, nSamp));
x = x./max(x)*sqrt(pin*res);
% figure; plot(abs(x));
RMSin = 10*log10(mean(abs(x).^2/res)) + 30;
% figure; histogram(real(x));
% figure; plot(abs(fft(x)));
[y, RMSout, Idc, Vdc] = RFWebLab_PA_meas_v1_2(x, RMSin);