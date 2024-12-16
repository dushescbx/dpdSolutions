close all;
clear all;
load('x.mat');
nSamp = 1e6;
res = 50;
pindBm = -10 : 5 : -10; %dB
x = x./max(x);
for i = 1 : length(pindBm)
    pin = 10.^((pindBm-30)/10); % dBm2Watts
    xLoad = x.*sqrt(pin(i)*res);
    RMSin = 10*log10(mean(abs(xLoad).^2/res)) + 30;
    [y, RMSout, Idc, Vdc] = RFWebLab_PA_meas_v1_2(xLoad, RMSin);
    save(['RMSindBm_pindBm=' num2str(pindBm(i)) '.mat'], 'RMSin');
    save(['y_pindBm=' num2str(pindBm(i)) '.mat'], 'y', 'RMSout', 'Idc', 'Vdc');
end