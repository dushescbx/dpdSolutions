close all
clear all

APSK_ar = 32;
f = 1;
i = 1;
ARBitrary_TRIGger_SLENgth = 1e4;
T = 1;

run('constant_for_model.m');
run('download_power_arrays.m');


%% ЗАГРУЖАЕМ идеальные символы
% load(['C:\Users\imya\Desktop\27-03\amplifier_usil_mal\_'...
%     num2str(APSK_ar(f)) 'APSK_ref_symb_before_transm_filter.mat']);
% load(['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier_usil_mal\_'...
%     num2str(APSK_ar(f)) 'APSK_ref_symb_before_transm_filter.mat']);

load(['C:\Users\abf\Desktop\RABOTA\27-03\amplifier_usil_mal\_'...
    num2str(APSK_ar(f)) 'APSK_ref_symb_before_transm_filter.mat']);

% data_in_ADD = complex(I,Q);
%% Задаем модуляцию
M = [4 8 20];
modOrder = sum(M);
radii = [0.3 0.7 1.2];
x_mat = randi([0 modOrder-1],1e5,1);
data_in_mat = apskmod(x_mat,M,radii);
data_in_ADD = data_in_mat;


title('data in');
scatterplot(data_in_ADD);
%% формируем передающий фильтр
txfilter = comm.RaisedCosineTransmitFilter('FilterSpanInSymbols',10,'OutputSamplesPerSymbol',4);


data_after_tx_filter = txfilter(data_in_ADD);
scatterplot(data_after_tx_filter);
title('data after tx filt');


%% формируем сдвиг по частоте и фазе
delta_f = 1e4;
delpa_phi = pi/4;

ind = 1:1:length(data_after_tx_filter);
exp_freq_shift=exp(-2*pi*1i*delta_f*ind + 1i*delpa_phi)';
% exp_freq_shift=exp(-2*pi*1i*delta_f*ind + delpa_phi)';

data_out_ADD_distorted = data_after_tx_filter.*exp_freq_shift;
figure;
plot(abs(fft(data_out_ADD_distorted)));
hold on;
plot(abs(fft(data_after_tx_filter)));


%% формируем принимающий фильтр
rxfilter = comm.RaisedCosineReceiveFilter('InputSamplesPerSymbol',4, ...
    'DecimationFactor',4);
data_after_rx_filter = rxfilter(data_out_ADD_distorted);
scatterplot(data_after_rx_filter);
title('data after rx filt');

%% подстройка частоты
% данные после согл. фильтра
y = data_after_rx_filter(11:end);%11
% комп. сопряженные известные данные
a = conj(data_in_ADD(1:length(y)));
% умножение данных
z = y .* a;
plot(real(z));
hold on;
plot(imag(z));
title('real imag z');
figure;
plot(abs(fft(z)));
title('abs fft z');
z_freq_estimate =z(2:end) .* conj(z(1:length(z)-1));
figure;
plot(real(z_freq_estimate));
hold on;
plot(imag(z_freq_estimate));
title('z freq est');
% находим смещение частоты
delta_f_est = 1/(2*pi) * angle(sum(z_freq_estimate));

%% сдвигаем частоту сигнала
ind = 1:1:length(z);
% exp_freq_shift_corr=exp(2*pi*1i*delta_f_est*ind)';
% data_out_ADD_corr = data_after_rx_filter.*exp_freq_shift_corr;
% scatterplot(data_out_ADD_corr);


[w_orient, index] = max(abs(fft(z)));

k = 1;
max_find_funct_max = 0;
for f = index-2:0.001:index+2
    max_find_funct(k) = abs(sum(z.*exp(1i*2*pi*f/length(z)*ind)'));
    if (max_find_funct(k)>=max_find_funct_max)
        max_find_funct_max = max_find_funct(k);
        max_ind = f;
    end
    k = k + 1;
end
figure;
plot(max_find_funct)
title('max ind funct');
%% сдвигаем частоту сигнала

angle_shift = angle(sum(z.*exp(1i*2*pi*max_ind/length(z)*ind)'));

ind = 1:1:length(data_after_rx_filter);
delta_f_est_with_fft = max_ind/length(data_after_rx_filter)
exp_freq_shift_with_fft=exp(2*pi*1i*delta_f_est_with_fft*ind + 1i * angle_shift)';
data_out_ADD_corr_diff = data_after_rx_filter.*exp_freq_shift_with_fft;
scatterplot(data_out_ADD_corr_diff);
title('corr data');


