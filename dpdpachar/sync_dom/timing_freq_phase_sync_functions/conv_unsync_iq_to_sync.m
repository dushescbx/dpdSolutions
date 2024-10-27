function symbol_synch_data = conv_unsync_iq_to_sync(APSK, power, raw_or_iq, direct)

%% загружаем константы
delayVec = [0];
mat_or_real = 0; % используем сгенерированные данные?
figure_on = 0;

if raw_or_iq == 0
    raw_or_iq_str = 'iq';
else
    raw_or_iq_str = 'raw';
end

%% загружаем данные
[phase_freq_offset_sig_out, ref_data, trace_data] = load_real_data(raw_or_iq, APSK, power, direct);

%% формируем принимающий фильтр
dec_factor = 1;
rx_filter_out = rx_filter(phase_freq_offset_sig_out, mat_or_real, raw_or_iq, figure_on, dec_factor);

%% подбираем сдвиг
shifted_sym = shift_of_symb_finder(rx_filter_out, ref_data, 0, 1);

%% символьная синхронизация по изв. данным
[symbol_synch_data, est_symb_del] = symbol_syncronyize(rx_filter_out, ref_data, delayVec, figure_on, mat_or_real, raw_or_iq);

%% сравнение с trace
evm = synch_compare(symbol_synch_data,trace_data, mat_or_real, raw_or_iq);
evm_no_sync = evm_meas(trace_data(1:length(shifted_sym)),shifted_sym);

%% Сравниваем синхр. и несинхр созвездия
compare_scatterplots(symbol_synch_data, shifted_sym, trace_data, APSK, power, evm, evm_no_sync, est_symb_del)

%% сохранение данных
file_name = ['/symbol_synch_data_' num2str(APSK) 'APSK_Power=' num2str(power) '_' num2str(raw_or_iq_str) '_sync_data.mat'];
save_data_in_folder(symbol_synch_data, 'sync_data', file_name)
