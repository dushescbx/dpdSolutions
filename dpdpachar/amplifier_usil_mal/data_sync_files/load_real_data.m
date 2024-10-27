function [real_data, apsk_ref, trace_data, raw_samples] = load_real_data(APSK, power, const)
%% сдвиг в данных появляется из-за переходных процессов
%% загружаем iq данные
apsk_raw = load( strcat(const.com.pa_meas_sig_folder_name, '\_', num2str(APSK), 'APSK', num2str(power), 'dbm_iq.mat') );
real_data(:) = apsk_raw.iq_data(161 : 4 * floor(length(apsk_raw.iq_data)/4) - 160);
real_data = real_data.';
%% загружаем trace
apsk_trace = load( strcat(const.com.pa_meas_sig_folder_name, '\_', num2str(APSK), 'APSK', num2str(power), 'dbm_trace.dat.mat'));
trace_data(:) = apsk_trace.simin.data(6:end);
trace_data = (trace_data).';
%% загружаем raw
raw_data = load( strcat(const.com.pa_meas_sig_folder_name, '\_', num2str(APSK), 'APSK', num2str(power), 'dbm_raw.dat.mat'));
raw_samples(:) = raw_data.simin.data(18:end);
raw_samples = (raw_samples).';
%% загружаем ref
apsk_ref = load( strcat(const.com.ref_wv_folder_name, '\_', num2str(APSK), const.sig.ref_symb_filename(2), '.mat') );
apsk_ref = complex(apsk_ref.I,apsk_ref.Q);
% min_len = min([length(apsk_ref); length(trace_data)]);
% ref_real_data = apsk_ref(1 : min_len);
% ref_real_data = (ref_real_data);
% ref_samp = tx_filter(ref_real_data);
% ref_samp = offset_find(ref_samp, ref_real_data);
% raw_samples = offset_find(raw_samples, ref_samp);
end