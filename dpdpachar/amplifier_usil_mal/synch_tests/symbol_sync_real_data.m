close all
clear all
apsk_ref=load(['C:\Users\abf\Desktop\RABOTA\27-03\ampl_scripts\output_input_signals\_32APSK10dbm_DPD_on=False_pa_on=True_trace.dat.mat']);
y_ref = apsk_ref.simin.data(:);
scatterplot(y_ref);
apsk=load(['C:\Users\abf\Desktop\RABOTA\27-03\ampl_scripts\output_input_signals\_32APSK10dbm_DPD_on=False_pa_on=True_raw.dat.mat']);
y = apsk.simin.data(:);

%% формируем принимающий фильтр
rxfilter = comm.RaisedCosineReceiveFilter('InputSamplesPerSymbol',4, ...
    'DecimationFactor',4);
data_after_rx_filter = rxfilter(y);

scatterplot(data_after_rx_filter);
title('after rx filter');

%% константы для подстройки временной задержки
start_sym = 0;
point_num = length(data_after_rx_filter);


x = 1:point_num;
yy_r = zeros(0,0);
yy_i = zeros(0,0);

%% подстройка временной задержки
i = 1;
step_size_start = 0;
step_size_end = 0.25;
step_of_loop = (step_size_end-step_size_start)/1e2;

for step_size = step_size_start:step_of_loop:step_size_end
    
    %задаем новые точки
    step_size_ar(i) = step_size;
    xx_fixed = x(1:point_num) + step_size;
    % получаем значения функции в этих точках
    yy_r = spline(x,real(data_after_rx_filter),xx_fixed);
    yy_i = spline(x,imag(data_after_rx_filter),xx_fixed);
    epsilon_dr(i) = max(abs(xcorr(y_ref,complex(yy_r,yy_i))));
    epsilon(i) = abs(sum(conj(y_ref) .* complex(yy_r,yy_i)'));
    scatterplot(complex(yy_r,yy_i));
    title(['step size =' num2str(step_size)]);
    i = i + 1;
end
figure;
plot(epsilon);
figure;
[max_val, index] = max(epsilon);
step_size_est = step_size_start + (index - 1) * step_of_loop;

figure;
plot(epsilon_dr);
figure;
[max_val_dr, index_dr] = max(epsilon_dr(:));
step_size_est_dr = step_size_start + (index_dr - 1) * step_of_loop;

plot(step_size_ar,epsilon);
title(['step size est=' num2str(step_size_est) ' index=' num2str(index)]);

plot(step_size_ar,epsilon_dr);
title(['step size est dr=' num2str(step_size_est) ' index=' num2str(index)]);


%% строим символы с заданной скорректированной задержкой
% for delayVec_test=0:delayVec/16:0.5
% x = 1:(length(data_after_rx_filter));
% xx_fixed = x + delayVec/4;
% yy_r = spline(x,real(data_after_rx_filter),xx_fixed);
% yy_i = spline(x,imag(data_after_rx_filter),xx_fixed);
% scatterplot(complex(yy_r,yy_i));
% title(['after symbol sync known data delay vec =' num2str(delayVec/4)]);
% % end

%% строим символы с найденной задержкой
% for delayVec_test=0:delayVec/16:0.5
x = 1:(length(data_after_rx_filter));
xx_fixed = x + step_size_est;
yy_r = spline(x,real(data_after_rx_filter),xx_fixed);
yy_i = spline(x,imag(data_after_rx_filter),xx_fixed);
scatterplot(complex(yy_r,yy_i));
title(['after symbol sync est data delay vec =' num2str(step_size_est)]);
% end


x = 1:(length(data_after_rx_filter));
xx_fixed = x + step_size_est;
yy_r = spline(x,real(data_after_rx_filter),xx_fixed);
yy_i = spline(x,imag(data_after_rx_filter),xx_fixed);
scatterplot(complex(yy_r,yy_i));
title(['after symbol sync est data delay vec dr =' num2str(step_size_est_dr)]);