function [...
    angle_shift, delta_f_est_with_fft, delta_f_est...
    ] = freq_phase_correction(in_data_for_sync,...
    ref_data)

%% подстройка частоты
% данные после согл. фильтра
y = in_data_for_sync;
% комп. сопряженные известные данные
a = conj(ref_data(1:length(y)));
% умножение данных
z = y .* a;

z_freq_estimate = z(2:end) .* conj(z(1:length(z)-1));
delta_f_est = 1/(2*pi) * angle(sum(z_freq_estimate));

%% сдвигаем частоту сигнала
ind = 0:1:length(z)-1;
%% RF Architectures and Digital Signal Processing Aspects of Digital Wireless Transceivers - Nezami
% 7-50
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
% figure;
% plot(max_find_funct)
% title('max ind funct');
angle_shift = angle(sum(z.*exp(1i*2*pi*max_ind/length(z)*ind)'));
delta_f_est_with_fft = max_ind/length(z);% + step_size;%length(data_after_rx_filter_mat)
