function [d_out, est_freq, est_phase] =...
    freq_phase_correction(d_in, d_ref, figure_on)
d_in = reshape(d_in, 1, []);
d_ref = reshape(d_ref, 1, []);
%% подстройка частоты
% данные после согл. фильтра
y = d_in;

% y = in_data_for_sync;
% комп. сопряженные известные данные
a = conj(d_ref(1:length(y)));
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
if (figure_on == 1)
    figure;
    plot(real(z_freq_estimate));
    hold on;
    plot(imag(z_freq_estimate));
    title('z freq est');
end
% находим смещение частоты
delta_f_est = length(z_freq_estimate)/(2*pi) * angle(sum(z_freq_estimate));

%% сдвигаем частоту сигнала
offset = -1;
ind = (1 + offset : 1 : length(z) + offset);
[w_orient, index] = max(abs(fft(z)));
if (figure_on == 1)
    figure;
    plot(abs(fft(z)));
    title('abs(fft(z)))');
end
k = 1;
max_find_funct_max = 0;
step_size = 1/1e2;
for f = index-2:step_size:index+2
    max_find_funct(k) = abs(sum(z.*exp(-1i*2*pi*f/length(z)*ind)));
    %     max_find_funct_test(k) = abs(sum(z.*exp(1i*2*pi*f/length(z)*ind')));
    if (max_find_funct(k)>=max_find_funct_max)
        max_find_funct_max = max_find_funct(k);
        max_ind = f;
    end
    k = k + 1;
end
if (figure_on == 1)
    figure;
    plot(max_find_funct)
    title('max ind funct');
end
% figure;
% plot(max_find_funct_test)
% title('max ind funct test');
%% сдвигаем частоту сигнала

angle_shift = angle(sum(z.*exp(-1i*2*pi*max_ind/length(z)*ind)));
% angle_shift_test = angle(sum(z.*exp(1i*2*pi*max_ind/length(z)*ind).'));
offset = -1;
ind = (1 + offset : 1 : length(y) + offset);
delta_f_est_with_fft = max_ind;% + step_size       length(data_after_rx_filter_mat)
exp_freq_shift_with_fft = exp(-2*pi*1i*delta_f_est_with_fft*ind/length(ind) - 1i * angle_shift );
data_out_ADD_corr_diff = y.*exp_freq_shift_with_fft;
if (figure_on == 1)
    scatterplot(data_out_ADD_corr_diff);
    title('corr data');
    figure;
    plot(abs(xcorr(data_out_ADD_corr_diff,conj(a))));
end

d_out = complex(data_out_ADD_corr_diff);
est_freq = delta_f_est_with_fft;
est_phase = angle_shift;

