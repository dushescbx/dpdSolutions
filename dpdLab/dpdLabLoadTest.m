close all;
load('x.mat');
res = 50;
pindBm = -25; %dBm
pin = 10.^((pindBm-30)/10); % dBm2Watts
x = x./max(x)*sqrt(pin*res);
m = max(x);
PeakReal=max(abs(real(x)));  
PeakImag=max(abs(imag(x)));
Peak=max([PeakReal PeakImag]);
% if Peak ~=0
%     x=double(x./Peak);
% else
%     x=double(x);
% end


PAPR = 20*log10(max(abs(x))*sqrt(length(x))/norm(x));
RMSin = 10*log10(mean(abs(x).^2/res)) + 30 + PAPR;
figure; plot(abs(fft(x)));

% [y, RMSout, Idc, Vdc] = RFWebLab_PA_meas_v1_2(x, RMSin);