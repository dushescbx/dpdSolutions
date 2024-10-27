function symbol_synch_data = conv_unsync_iq_to_sync(apsk, power, data_to_sync)

%% ��������� ������
[ref_data, trace_data] = load_ref_data(apsk, power);

%% ��������� ����������� ������
rx_filter_out = rx_filter(data_to_sync);

%% ��������� � ������� �������������
freq_phase_corrected_data = freq_phase_correction(rx_filter_out, ref_data);

%% ���������� �������������
symbol_synch_data = symbol_syncronyize(freq_phase_corrected_data, ref_data, delayVec);

%% ��������� � trace
evm = synch_compare(symbol_synch_data, trace_data)