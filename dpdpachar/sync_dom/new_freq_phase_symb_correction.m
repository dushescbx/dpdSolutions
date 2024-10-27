clear all
close all

mat_or_real = 0; % ���������� ��������������� ������?
raw_or_iq = 0;
figure_on = 1;
APSK = 32;
power = 8;
direct = 'C:\Users\Konstantinov_PA\Desktop\RABOTA\actual';

%% ������ ���������
if (mat_or_real == 1)
    load('data_in_mat.mat');
    in_data = data_in_mat(1:1e4);
    %     in_data = apsk_mod;
    ref_data = in_data;
    trace_data = in_data;
    %% ��������� ���������� ������
    tx_filter_out = tx_filter(in_data);
    
    %% ��������� ����� �� �������, ���� � ��������� ��������
    delta_f = 10;
    delpa_phi = 0;
    delayVec = [0];
    phase_freq_offset_sig_out = phase_freq_timing_offset(tx_filter_out, delta_f,delpa_phi, delayVec);
else
    delayVec = [0];
    [phase_freq_offset_sig_out, ref_data, trace_data] = load_real_data(raw_or_iq, APSK, power, direct);
%     [phase_freq_offset_sig_out, ref_data, trace_data] = load_real_data_wo_offset(raw_or_iq, APSK, power, direct);
end

%% ��������� ����������� ������
dec_factor = 1;
rx_filter_out = rx_filter(phase_freq_offset_sig_out, dec_factor);

%% ��������� ����������� ������
% dec_factor = 1;
% rx_filter_out = rx_filter_offset_find_test(phase_freq_offset_sig_out, dec_factor);
% %% ��������� �����
% shifted_sym = shift_of_symb_finder(rx_filter_out, ref_data, 1, 0);
% %% ������� ���������� ������ � ������
% data_out = offset_find(shifted_sym, ref_data);


%% ���������� ������������� �� ���. ������
[symbol_synch_data, est_symb_del] = symbol_syncronyize(rx_filter_out,ref_data,delayVec, figure_on, mat_or_real, raw_or_iq);

%% ��������� � trace
evm = synch_compare(symbol_synch_data,trace_data, mat_or_real, raw_or_iq);

save(['symbol_synch_data_mat_gen=' num2str(mat_or_real) '_delay=' num2str(delayVec) '.mat'],'symbol_synch_data','ref_data');

% run('synch_again.m');