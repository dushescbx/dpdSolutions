function symbol_synch_data = conv_unsync_iq_to_sync(APSK, power, raw_or_iq, const)

%% ��������� ���������
delayVec = [0];
mat_or_real = 0; % ���������� ��������������� ������?
figure_on = 0;

if raw_or_iq == 0
    raw_or_iq_str = 'iq';
else
    raw_or_iq_str = 'raw';
end

%% ��������� ������
[phase_freq_offset_sig_out, ref_data, trace_data, raw_data] = load_real_data(APSK, power, const);

%% ��������� ����������� ������
dec_factor = 1;
rx_filter_out = rx_filter(raw_data, dec_factor);
% rx_filter_out = rx_filter_out(7:end);
%% ��������� �����
shifted_sym = shift_of_symb_finder(rx_filter_out, ref_data, 0);

%% ���������� ������������� �� ���. ������
[symbol_synch_data, est_symb_del] = symbol_syncronyize(rx_filter_out, ref_data, delayVec, figure_on, mat_or_real, raw_or_iq);

%% ��������� � trace
evm = synch_compare(symbol_synch_data,trace_data);
% figure;
% plot(real(symbol_synch_data));
% hold on
% plot(real(trace_data));
min_len = min([length(shifted_sym) length(trace_data)]);
evm_no_sync = evm_meas(trace_data(1:min_len),shifted_sym(1:min_len));

%% ���������� �����. � ������� ���������
compare_scatterplots(symbol_synch_data, shifted_sym, trace_data, APSK, power, evm, evm_no_sync, est_symb_del)

% %% ���������� ������
% file_name = ['/symbol_synch_data_' num2str(APSK) 'APSK_Power=' num2str(power) '_' num2str(raw_or_iq_str) '_sync_data.mat'];
% save_data_in_folder(symbol_synch_data, 'sync_data', file_name)

if (exist(const.com.meas_sig_folder_name, 'dir') ~= 7)
    mkdir(const.com.meas_sig_folder_name);
end
%% ���������� ������
file_name = strcat(const.com.meas_sig_folder_name, '\', num2str(APSK), 'APSK_Power=', num2str(power), '_sync_symbols.mat');
save(file_name, 'symbol_synch_data');
