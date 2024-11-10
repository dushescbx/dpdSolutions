function [freq_phase_corrected_data, ...
    angle_shift, delta_f_est_with_fft, delta_f_est...
    ] = freq_phase_correction(in_data_for_sync,...
    ref_data)

%% ���������� �������
% ������ ����� ����. �������
y = in_data_for_sync;
% ����. ����������� ��������� ������
a = conj(ref_data(1:length(y)));
% ��������� ������
z = y .* a;

z_freq_estimate = z(2:end) .* conj(z(1:length(z)-1));
delta_f_est = 1/(2*pi) * angle(sum(z_freq_estimate));

%% �������� ������� �������
ind = 1:1:length(z);
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
%% �������� ������� �������

angle_shift = angle(sum(z.*exp(1i*2*pi*max_ind/length(z)*ind)'));

ind = 1:1:length(y);
delta_f_est_with_fft = max_ind;% + step_size;%length(data_after_rx_filter_mat)
exp_freq_shift_with_fft=exp(2*pi*1i*delta_f_est_with_fft*ind/length(ind) + 1i * angle_shift)'; %  - 1i * pi/180*90
data_out_ADD_corr_diff = y.*exp_freq_shift_with_fft;
% f1 = figure();
% plot(data_out_ADD_corr_diff(16:end), '*');
% title('corr data');


freq_phase_corrected_data = complex(data_out_ADD_corr_diff);

