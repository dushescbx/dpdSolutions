function [sym_corrected_data, est_symb_del] = symbol_syncronyize_with_fft_abs(in_data_for_sync) 
%% символьная синхронизация p 238
offset = -1;
ind = (1 + offset : 1 : length(in_data_for_sync) + offset)';
exp_mult = exp(-2*pi*1i*ind/length(ind));%+ 1i * angle_shift - 1i * pi/180*90
est_symb_del = -1/(2*pi)*angle(sum(abs(in_data_for_sync).^2 .* exp_mult));
sym_corrected_data = in_data_for_sync; 