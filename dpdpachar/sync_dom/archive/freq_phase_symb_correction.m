clear all
close all

mat_or_real = 1; % используем сгенерированные данные?
raw_or_iq = 0;
figure_on = 1;
APSK = 32;
power = 8;
dec_factor = 1;

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
    delta_f = 0;
    delpa_phi = (pi/180)*180;
    delayVec = [0];
    phase_freq_offset_sig_out = phase_freq_timing_offset(tx_filter_out, delta_f,delpa_phi, delayVec);
else
    delayVec = [0];
    [phase_freq_offset_sig_out, ref_data, trace_data] = load_real_data(raw_or_iq, APSK, power);
end

%% формируем принимающий фильтр
rx_filter_out = rx_filter(phase_freq_offset_sig_out, mat_or_real, raw_or_iq, figure_on, dec_factor);

%% формируем принимающий фильтр
rx_filter_out_test = rx_filter(phase_freq_offset_sig_out, mat_or_real, raw_or_iq, figure_on, 4);

% %% тестим определение фазового сдвига
% [angle_diff_conj,angle_diff_v_lob] = phase_offset(in_data, rx_filter_out_test);

%% частотная и фазовая синхронизация
[freq_phase_corrected_data, est_freq, est_phase] = freq_phase_correction(shifted_sym,ref_data, mat_or_real, figure_on, raw_or_iq, mat_or_real);
% [freq_phase_corrected_data, est_freq, est_phase] = freq_phase_correction_old(rx_filter_out,ref_data, mat_or_real);
%% символьная синхронизация по изв. данным
[symbol_synch_data, est_symb_del] = symbol_syncronyize(freq_phase_corrected_data,ref_data,delayVec, figure_on, raw_or_iq);

%% ищем оптимальный отсчет (1...4)
shifted_sym = shift_of_symb_finder(rx_filter_out, ref_data, figure_on, mat_or_real);

%% на основе ДПФ, нелинейность 1) DelConj
% [sym_corrected_data_fft_based, est_freq_fft_based, est_symb_del_fft_based] = symbol_syncronyize_with_fft(rx_filter_out);

%% 2) abs
freq_phase_corrected_data_tx_filt = tx_filter(freq_phase_corrected_data);
% [sym_corrected_data_abs, est_symb_del_abs] = symbol_syncronyize_with_fft_abs(freq_phase_corrected_data_tx_filt);
%% сравнение с trace
evm = synch_compare(symbol_synch_data,trace_data, mat_or_real, raw_or_iq);

save(['symbol_synch_data_mat_gen=' num2str(mat_or_real) '_delay=' num2str(delayVec) '.mat'],'symbol_synch_data','ref_data');

% run('synch_again.m');
