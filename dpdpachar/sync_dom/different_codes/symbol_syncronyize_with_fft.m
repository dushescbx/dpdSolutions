function [sym_corrected_data, est_freq, est_symb_del] = symbol_syncronyize_with_fft(in_data_for_sync) %est_phase, 
%% константы дл€ подстройки временной задержки
n = 1;
T = 1;
N = 4;
%% подстройка временной задержки p.193 Matlab
z = (in_data_for_sync);
offset = -1;
ind = (1 + offset : 1 : length(z) + offset - 1)';

k = 1;
C_minus = sum(z(2:end) .* conj(z(1:length(z)-1)) .* exp(-1i*2*pi*ind*n*k/N));
C_plus = sum(z(2:end) .* conj(z(1:length(z)-1)) .* exp(1i*2*pi*ind*n*k/N));
delta_f = -1/(4*pi*T)*angle(C_minus*C_plus); %
% figure;
% plot(C_minus*C_plus);
test = angle(C_minus*C_plus);

%% сдвигаем частоту
offset = -1;
ind = (1 + offset : 1 : length(z) + offset)';
exp_freq_shift_with_fft=exp(2*pi*1i*delta_f*ind/length(ind));%+ 1i * angle_shift - 1i * pi/180*90
data_out_ADD_corr_diff = in_data_for_sync.*exp_freq_shift_with_fft;
figure;
% plot(abs(fft(data_out_ADD_corr_diff)));
scatterplot(data_out_ADD_corr_diff);


%% символьна€ синхронизаци€ p 196
est_symb_del = 1/(2*pi)*((angle(C_plus)-angle(C_minus))/2);



%% интерпол€ци€
% x_mat = (1:(length(in_data_for_sync)))';
% xx_fixed_mat = x_mat + symbol_timing_offset;
% yy_r_mat = spline(x_mat,real(in_data_for_sync),xx_fixed_mat);
% yy_i_mat = spline(x_mat,imag(in_data_for_sync),xx_fixed_mat);
% sym_corrected_data = complex(yy_i_mat,yy_r_mat)';
% scatterplot(sym_corrected_data);
% title(['after symbol sync est data delay vec dr =' num2str(symbol_timing_offset*4)]);

est_freq = delta_f;
sym_corrected_data = data_out_ADD_corr_diff;
% est_phase =; 
% est_symb_del =;