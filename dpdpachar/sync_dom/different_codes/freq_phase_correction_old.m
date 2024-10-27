function [freq_phase_corrected_data, est_freq, est_phase] = freq_phase_correction(in_data_for_sync, ref_data, mat_or_real)

%% подстройка частоты
% данные после согл. фильтра
y = in_data_for_sync(1:end);
% комп. сопряженные известные данные
if mat_or_real == 1
    a = conj(ref_data(1:length(y)));
else
    a = conj(ref_data(1:length(y)))';
end
% умножение данных
z = y .* a;
% figure;
% plot(real(z));
% hold on;
% plot(imag(z));
% title('real imag z');
% figure;
% plot(abs(fft(z)));
% title('abs fft z');
z_freq_estimate = z(2:end) .* conj(z(1:length(z)-1));
figure;
plot(real(z_freq_estimate));
hold on;
plot(imag(z_freq_estimate));
title('z freq est');
% находим смещение частоты
delta_f_est = 1/(2*pi) * angle(sum(z_freq_estimate));

%% сдвигаем частоту сигнала
offset = -1;
ind = 1 + offset : 1 : length(z) + offset;
[w_orient, index] = max(abs(fft(z)));

k = 1;
max_find_funct_max = 0;
step_size = 1/1e2;
for f = index-2:step_size:index+2
    max_find_funct(k) = abs(sum(z.*exp(1i*2*pi*f/length(z)*ind)'));
    if (max_find_funct(k)>=max_find_funct_max)
        max_find_funct_max = max_find_funct(k);
        max_ind = f;
    end
    k = k + 1;
end
figure;
plot(max_find_funct)
title('max ind funct');
%% сдвигаем частоту сигнала

angle_shift = angle(sum(z.*exp(1i*2*pi*max_ind/length(z)*ind)'));
offset = -1;
ind = 1 + offset : 1 : length(y) + offset;
delta_f_est_with_fft = max_ind + step_size;%length(data_after_rx_filter_mat)
exp_freq_shift_with_fft=exp(2*pi*1i*delta_f_est_with_fft*ind/length(ind) + 1i * angle_shift - 1i * pi/180*90)';
data_out_ADD_corr_diff = y.*exp_freq_shift_with_fft;
scatterplot(data_out_ADD_corr_diff);
title('corr data');


figure;
plot(abs(xcorr(data_out_ADD_corr_diff,conj(a))));


freq_phase_corrected_data = complex(data_out_ADD_corr_diff);
est_freq = delta_f_est_with_fft;
est_phase = angle_shift - pi/180*90;
% save('data_for_save_phase_freq_corr.mat','data_for_save_phase_freq_corr');

