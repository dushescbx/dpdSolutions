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




%% ЗАГРУЖАЕМ отсчеты СЧИТАННЫЕ ИЗ АНАЛИЗАТОРА IQ
load(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\_' num2str(APSK_ar(f)) 'APSK'  num2str(input_ar.d(i)) 'dbm_DPD_on=False_pa_on=True_iq.mat']);
data_out_ADD=iq_data(start_of_data:4*4e4-3);
data_out_ADD=data_out_ADD(:);
%% МАСШТАБИРУЕМ В СООТВЕТСТВИИ С ВЫХОДНОЙ МОЩНОСТЬЮ
data_out_ADD=scale_power(data_out_ADD,input_ar.d,i);%%%%%%%%<------- output_ar
scatterplot(data_out_ADD);
% % % %% ЗАГРУЖАЕМ сгенерированные отсчеты IQ
% % % load(['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier_usil_mal\_' num2str(APSK_ar(f)) 'APSK_ref_symb_after_filter.mat']);
% % % data_in_ADD = ref_sym(start_of_data:4*4e4-3);

%% ЗАГРУЖАЕМ идеальные символы
load(['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier_usil_mal\_' num2str(APSK_ar(f)) 'APSK_ref_symb_before_transm_filter.mat']);
data_in_ADD = complex(I,Q);

%% МАСШТАБИРУЕМ В СООТВЕТСТВИИ С ВХОДНОЙ МОЩНОСТЬЮ
data_in_ADD = scale_power(data_in_ADD,input_ar.d,i);
scatterplot(data_in_ADD);



%% пропускаем через фильтр
simin.data = data_out_ADD;
simin.time = 0:1:length(simin.data) - 1;
simin = timeseries(simin.data,simin.time);
sim('timing_sync_model.slx');

%% подстройка частоты
% данные после согл. фильтра
y = demod_sym_after_filt(42:1e3);
% комп. сопряженные известные данные
a = ctranspose(data_in_ADD(1:length(y)));
% умножение данных
z = a * y;
z_freq_estimate =z(2:end) .* conj(z(1:length(z)-1));
% находим смещение частоты
delta_f = 1/(2*pi*T) * angle(sum(z_freq_estimate));


% % % %% сдвигаем частоту сигнала
% % % ind = 1:1:length(data_out_ADD);
% % % exp_freq_shift=exp(-1i*delta_f*ind)';
% % % data_out_ADD_corr = data_out_ADD.*exp_freq_shift;
% % % figure;
% % % plot(abs(fft(data_out_ADD_corr)));
% % % hold on;
% % % plot(abs(fft(data_out_ADD)));

%% сдвигаем частоту сигнала
ind = 1:1:length(demod_sym_after_filt);
exp_freq_shift=exp(-2*pi*T*1i*delta_f*ind)';
data_out_ADD_corr = demod_sym_after_filt.*exp_freq_shift;
figure;
plot(abs(fft(data_out_ADD_corr)));
hold on;
plot(abs(fft(demod_sym_after_filt)));



%% константы для подстройки временной задержки
start_sym = 0;
point_num = 25e3;
x = 1:point_num;
x_ar = 1:1:length(data_out_ADD_corr);
yy_r = zeros(0,0);
yy_i = zeros(0,0);

%% подстройка временной задержки
for step_size = 0:0.01:0.2
    
    %задаем новые точки
    xx_fixed = x(1:point_num) + step_size;
    % получаем значения функции в этих точках
    %     yy_r = spline(x,real(demod_sym_after_filt(1:length(x))),xx_fixed);
    %     yy_i = spline(x,imag(demod_sym_after_filt(1:length(x))),xx_fixed);
    yy_r = spline(x,real(data_out_ADD_corr(1:length(x))),xx_fixed);
    yy_i = spline(x,imag(data_out_ADD_corr(1:length(x))),xx_fixed);
    % строим график
    scatterplot(complex(yy_r(1:4:end),yy_i(1:4:end)));
    title(['fix step size=' num2str(step_size) ' start sym shift=' num2str(start_sym)]);
    
end
% end

