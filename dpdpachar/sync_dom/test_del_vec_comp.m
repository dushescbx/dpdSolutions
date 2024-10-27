clear all
close all
clc

mat_or_real = 1; % используем сгенерированные данные?
raw_or_iq = 1;
figure_on = 1;
APSK = 32;
power = 0;


load('data_in_mat.mat');
in_data = data_in_mat;%(1:1e3)
ref_data = in_data;
trace_data = in_data;
%% формируем передающий фильтр
tx_filter_out = tx_filter(in_data);
%% формируем сдвиг по частоте, фазе и временную задержку
delta_f = 0;
delpa_phi = 0;
delayVec = [0.1];
fract_del_symb_out = (fract_del(tx_filter_out, delayVec));
%% формируем принимающий фильтр
dec_factor = 1;
rx_filter_out = rx_filter(fract_del_symb_out, in_data, mat_or_real, raw_or_iq, figure_on, dec_factor);
%% сдвигаем отсчеты обратно
sync_symbols = (fract_del(rx_filter_out, -delayVec));
for i = 1:4
    corr_ar(i) = max(abs(xcorr(ref_data,sync_symbols(i:4:end))));
end
[M,I] = max(corr_ar);

sync_data = offset_find(sync_symbols(I : 4 : end), ref_data);
scatterplot(sync_data);