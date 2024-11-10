clear all
% close all

mat_or_real = 1; % используем сгенерированные данные?
raw_or_iq = 1;
%% Задаем модуляцию
if (mat_or_real == 1)
    load('data_in_mat.mat');
%     in_data = data_in_mat;
        in_data = apsk_mod;
    ref_data = in_data;
    trace_data = in_data;
    %% формируем передающий фильтр
    tx_filter_out = tx_filter(in_data);
    
    %% формируем сдвиг по частоте, фазе и временную задержку
    delta_f = 0;
    delpa_phi = pi/6;
    delayVec = [0];
    phase_freq_offset_sig_out = phase_freq_timing_offset(tx_filter_out,delta_f,delpa_phi,delayVec);
else
    delayVec = [0];
    [phase_freq_offset_sig_out,ref_data, trace_data] = load_real_data(raw_or_iq);
end

%% формируем принимающий фильтр
rx_filter_out = rx_filter(phase_freq_offset_sig_out);
scatterplot(rx_filter_out);
scatterplot(ref_data);

%% частотная и фазовая синхронизация
freq_phase_corrected_data = freq_phase_correction(rx_filter_out,ref_data);

%% символьная синхронизация
symbol_synch_data = symbol_syncronyize(freq_phase_corrected_data,ref_data,delayVec);

%% сравнение с trace
evm = synch_compare(symbol_synch_data,trace_data);

