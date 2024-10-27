%% создаем послетовательность данных
data = [zeros(48,1); ones(100000-48,1)];
%% создаем модулятор
bpskModulator = comm.BPSKModulator;
%% модулируем данные
modData = bpskModulator(data);
%% формируем файл I Q fc
I=real(modData);
Q=imag(modData);
fc=25e6;
save(['_BPSK_ref_symb_before_transm_filter.mat'],'I','Q','fc');
Convert_Mat2Wv_function(['_BPSK_ref_symb_before_transm_filter.mat']);

%% передающий фильтр приподнятого косинуса
tx_filter_out = tx_filter(modData);

%% СОЗДАЕМ MAT ФАЙЛ С I Q fc, для конвертации mat в wv формат
I=real(tx_filter_out);
Q=imag(tx_filter_out);
fc=100e6;
filename=['_BPSK_ref_symb_after_filter_for_conv_wv.mat'];
save(filename,'I','Q','fc');
% save(['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier_usil_mal\_BPSK_ref_symb_after_filter.mat'],'ref_sym');
Convert_Mat2Wv_function(filename);
ftp_connect_and_download_to_gen_bpsk_symb(directory);