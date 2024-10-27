clear all
close all

mat_or_real = 0; % используем сгенерированные данные?
raw_or_iq = 0;
figure_on = 1;
APSK = 32;
power = 8;
direct = 'C:\Users\Konstantinov_PA\Desktop\RABOTA\actual';

%% Задаем модуляцию
if (mat_or_real == 1)
    load('data_in_mat.mat');
    in_data = data_in_mat(1:1e4);
    %     in_data = apsk_mod;
    ref_data = in_data;
    trace_data = in_data;
    %% формируем передающий фильтр
    tx_filter_out = tx_filter(in_data);
    
    %% формируем сдвиг по частоте, фазе и временную задержку
    delta_f = 10;
    delpa_phi = 0;
    delayVec = [0];
    phase_freq_offset_sig_out = phase_freq_timing_offset(tx_filter_out, delta_f,delpa_phi, delayVec);
else
    delayVec = [0];
    [phase_freq_offset_sig_out, ref_data, trace_data] = load_real_data(raw_or_iq, APSK, power, direct);
%     [phase_freq_offset_sig_out, ref_data, trace_data] = load_real_data_wo_offset(raw_or_iq, APSK, power, direct);
end

%% формируем принимающий фильтр
dec_factor = 1;
rx_filter_out = rx_filter(phase_freq_offset_sig_out, dec_factor);

%% формируем принимающий фильтр
% dec_factor = 1;
% rx_filter_out = rx_filter_offset_find_test(phase_freq_offset_sig_out, dec_factor);
% %% подбираем сдвиг
% shifted_sym = shift_of_symb_finder(rx_filter_out, ref_data, 1, 0);
% %% функция нахождения сдвига в данных
% data_out = offset_find(shifted_sym, ref_data);


%% символьная синхронизация по изв. данным
[symbol_synch_data, est_symb_del] = symbol_syncronyize(rx_filter_out,ref_data,delayVec, figure_on, mat_or_real, raw_or_iq);

%% сравнение с trace
evm = synch_compare(symbol_synch_data,trace_data, mat_or_real, raw_or_iq);

save(['symbol_synch_data_mat_gen=' num2str(mat_or_real) '_delay=' num2str(delayVec) '.mat'],'symbol_synch_data','ref_data');

% run('synch_again.m');