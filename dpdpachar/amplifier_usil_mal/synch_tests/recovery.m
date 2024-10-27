close all
clear all

APSK_ar = 32;
f = 1;
i = 1;
ARBitrary_TRIGger_SLENgth = 1e4;
T = 1;

run('constant_for_model.m');
run('download_power_arrays.m');




start_of_data=21;




%% ��������� ������� ��������� �� ����������� IQ
load(['C:\Users\abf\Desktop\RABOTA\27-03\ampl_scripts\output_input_signals\_' num2str(APSK_ar(f)) 'APSK'  num2str(input_ar.d(i)) 'dbm_DPD_on=False_pa_on=True_iq.mat']);
% load(['C:\Users\imya\Desktop\27-03\ampl_scripts\output_input_signals\_' num2str(APSK_ar(f)) 'APSK'  num2str(input_ar.d(i)) 'dbm_DPD_on=False_pa_on=True_iq.mat']);

% load(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\_' num2str(APSK_ar(f)) 'APSK'  num2str(input_ar.d(i)) 'dbm_DPD_on=False_pa_on=True_iq.mat']);



data_out_ADD=iq_data(start_of_data:4*4e4-3);
data_out_ADD=data_out_ADD(:);
%% ������������ � ������������ � �������� ���������
data_out_ADD=scale_power(data_out_ADD,input_ar.d,i);%%%%%%%%<------- output_ar
scatterplot(data_out_ADD);
% % % %% ��������� ��������������� ������� IQ
% % % load(['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier_usil_mal\_' num2str(APSK_ar(f)) 'APSK_ref_symb_after_filter.mat']);
% % % data_in_ADD = ref_sym(start_of_data:4*4e4-3);

%% ��������� ��������� �������
% load(['C:\Users\imya\Desktop\27-03\amplifier_usil_mal\_' num2str(APSK_ar(f)) 'APSK_ref_symb_before_transm_filter.mat']);
load(['C:\Users\abf\Desktop\RABOTA\27-03\amplifier_usil_mal\_' num2str(APSK_ar(f)) 'APSK_ref_symb_before_transm_filter.mat']);

% load(['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier_usil_mal\_' num2str(APSK_ar(f)) 'APSK_ref_symb_before_transm_filter.mat']);


data_in_ADD = complex(I,Q);

%% ������������ � ������������ � ������� ���������
data_in_ADD = scale_power(data_in_ADD,input_ar.d,i);
scatterplot(data_in_ADD);



%% ���������� ����� ������
simin.data = data_out_ADD;
simin.time = 0:1:length(simin.data) - 1;
simin = timeseries(simin.data,simin.time);
sim('timing_sync_model.slx');

%% ���������� �������
% ������ ����� ����. �������
y = demod_sym_after_filt(42:end);
% ����. ����������� ��������� ������
a = conj(data_in_ADD(1:length(y)));
% ��������� ������
z = y .* a;
figure;
plot(real(z));
hold on;
plot(imag(z));
plot(abs(fft(z)));
z_freq_estimate =z(2:end) .* conj(z(1:length(z)-1));
% ������� �������� �������
delta_f = 1/(2*pi*T) * angle(sum(z_freq_estimate));


% % % %% �������� ������� �������
% % % ind = 1:1:length(data_out_ADD);
% % % exp_freq_shift=exp(-1i*delta_f*ind)';
% % % data_out_ADD_corr = data_out_ADD.*exp_freq_shift;
% % % figure;
% % % plot(abs(fft(data_out_ADD_corr)));
% % % hold on;
% % % plot(abs(fft(data_out_ADD)));

ind = 1:1:length(z);
[w_orient, index] = max(abs(fft(z)));

k = 1;
max_find_funct_max = 0;
for f = index-2:0.001:index+2
    max_find_funct(k) = abs(sum(z.*exp(1i*2*pi*f/length(z)*ind)'));
    if (max_find_funct(k)>=max_find_funct_max)
        max_find_funct_max = max_find_funct(k);
        max_ind = f;
    end
    k = k + 1;
end
figure;
plot(max_find_funct)
%% �������� ������� �������
angle_shift = angle(sum(z.*exp(1i*2*pi*max_ind/length(z)*ind)'));

ind = 1:1:length(demod_sym_after_filt);
delta_f_est_with_fft = max_ind/length(demod_sym_after_filt)
exp_freq_shift_with_fft=exp(2*pi*1i*delta_f_est_with_fft*ind )'; %+ 1i * angle_shift
data_out_ADD_corr_diff = demod_sym_after_filt.*exp_freq_shift_with_fft;
scatterplot(data_out_ADD_corr_diff);



% %% �������� ������� �������
% ind = 1:1:length(demod_sym_after_filt);
% exp_freq_shift=exp(2*pi*T*1i*delta_f*ind)';
% data_out_ADD_corr = demod_sym_after_filt.*exp_freq_shift;
% figure;
% plot(abs(fft(data_out_ADD_corr)));
% hold on;
% plot(abs(fft(demod_sym_after_filt)));

%% �������� ��������� ����������



%% ��������� ��� ���������� ��������� ��������
start_sym = 0;
point_num = 25e3;
x = 1:point_num;
x_ar = 1:1:length(data_out_ADD_corr_diff);
yy_r = zeros(0,0);
yy_i = zeros(0,0);

data_in_ADD_scaled = scale_power(data_in_ADD,10*log10(mean(abs(data_out_ADD_corr_diff).^2/1e-3)),1);
figure;
scatterplot(data_out_ADD_corr_diff);
scatterplot(data_in_ADD_scaled);

%% ���������� ��������� ��������
i = 1; 
step_size_start = 0;
step_of_loop = 0.1;
step_size_end = 4;
for step_size = step_size_start:step_of_loop:step_size_end
    
    %������ ����� �����
    xx_fixed = x(1:point_num) + step_size;
    % �������� �������� ������� � ���� ������
    %     yy_r = spline(x,real(demod_sym_after_filt(1:length(x))),xx_fixed);
    %     yy_i = spline(x,imag(demod_sym_after_filt(1:length(x))),xx_fixed);
    yy_r = spline(x,real(data_out_ADD_corr_diff(1:length(x))),xx_fixed);
    yy_i = spline(x,imag(data_out_ADD_corr_diff(1:length(x))),xx_fixed);

    epsilon(i) = abs(sum(conj(data_in_ADD(1:length(yy_r))) .* complex(yy_r,yy_i)'));%(1:4:end)
    signal = complex(yy_r(1:4:end),yy_i(1:4:end)) .* exp(-1i * angle_shift);
    i = i + 1;
    % ������ ������
    scatterplot(complex(yy_r(1:4:end),yy_i(1:4:end)));
    title(['fix step size=' num2str(step_size) ' index=' num2str(i) 'wo phase corr']);
    scatterplot(signal);
    title(['fix step size=' num2str(step_size) ' index=' num2str(i)]);
    
end
% end
[max, index] = max(epsilon);

plot(epsilon);
step_size_est = step_size_start + (index - 1) * step_of_loop;

    xx_fixed = x(1:point_num) + step_size_est;
    yy_r = spline(x,real(data_out_ADD_corr_diff(1:length(x))),xx_fixed);
    yy_i = spline(x,imag(data_out_ADD_corr_diff(1:length(x))),xx_fixed);
        signal = complex(yy_r(1:4:end),yy_i(1:4:end)) .* exp(-1i * angle_shift);
    scatterplot(complex(yy_r(1:4:end),yy_i(1:4:end)));
    scatterplot(signal);
    
