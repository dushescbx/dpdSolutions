close all
clear all

apsk = load(['C:\Users\abf\Desktop\RABOTA\27-03\ampl_scripts\output_input_signals\_32APSK10dbm_DPD_on=False_pa_on=True_raw.dat.mat']);
y_real = apsk.simin.data(:);
y_real = y_real(1:length(y_real)/16);
M = [4 8 20];
modOrder = sum(M);
radii = [0.3 0.7 1.2];
x_mat = randi([0 modOrder-1],length(y_real),1);
y_mat = apskmod(x_mat,M,radii);
scatterplot(y_mat)
% qpskMod  = comm.QPSKModulator;
% data      = randi([0 3], 100, 1);           % Random data
% y     = qpskMod(data);                  % QPSK modulation
% y = apsk.simin.data(:);

%% формируем передающий фильтр
txfilter = comm.RaisedCosineTransmitFilter('FilterSpanInSymbols',10,'OutputSamplesPerSymbol',4);


data_after_tx_filter_mat = txfilter(y_mat);
data_after_tx_filter_real = txfilter(y_real);


scatterplot(data_after_tx_filter_mat);
title('after tx filter mat');
scatterplot(data_after_tx_filter_real);
title('after tx filter real');
%% формируем временную задержку
varDelay = dsp.VariableFractionalDelay;

delayVec = [0.5];
delaySig_mat = varDelay(data_after_tx_filter_mat,delayVec);


%% формируем принимающий фильтр
rxfilter = comm.RaisedCosineReceiveFilter('InputSamplesPerSymbol',4, ...
    'DecimationFactor',4);
data_after_rx_filter_mat = rxfilter(delaySig_mat);
data_after_rx_filter_real = rxfilter(data_after_tx_filter_real);

scatterplot(data_after_rx_filter_mat);
title('after rx filter mat');
scatterplot(data_after_rx_filter_real);
title('after rx filter real');

%% константы для подстройки временной задержки
start_sym = 0;
point_num_mat = length(data_after_rx_filter_mat);


x_mat = 1:point_num_mat;
yy_r_mat = zeros(0,0);
yy_i_mat = zeros(0,0);

%% подстройка временной задержки
i = 1;
step_size_start_mat = -0.5;
step_size_end_mat = 0.5;
step_of_loop_mat = (step_size_end_mat-step_size_start_mat)/1e3;

for step_size_mat = step_size_start_mat:step_of_loop_mat:step_size_end_mat
    
    %задаем новые точки
    step_size_ar_mat(i) = step_size_mat;
    xx_fixed_mat = x_mat(1:point_num_mat) + step_size_mat;
    % получаем значения функции в этих точках
    yy_r_mat = spline(x_mat,real(data_after_rx_filter_mat),xx_fixed_mat);
    yy_i_mat = spline(x_mat,imag(data_after_rx_filter_mat),xx_fixed_mat);
    epsilon_dr(i) = max(abs(xcorr(y_mat,complex(yy_r_mat,yy_i_mat))));
    
    epsilon(i) = abs(sum(conj(y_mat) .* complex(yy_r_mat,yy_i_mat)'));%(1:4:end)
    i = i + 1;
    % строим график
    %     scatterplot(complex(yy_r(1:4:end),yy_i(1:4:end)));%(1:4:end)
    %         scatterplot(complex(yy_r,yy_i));%(1:4:end)
    
    %     title(['fix step size=' num2str(step_size) ' index=' num2str(i) 'wo phase corr']);
end
figure;
plot(epsilon);
figure;
[max_val, index] = max(epsilon);
step_size_est_mat = step_size_start_mat + (index - 1) * step_of_loop_mat;

figure;
plot(epsilon_dr);
figure;
[max_val_dr, index_dr] = max(epsilon_dr(:));
step_size_est_dr_mat = step_size_start_mat + (index_dr - 1) * step_of_loop_mat;

plot(step_size_ar_mat,epsilon);
title(['step size est=' num2str(step_size_est_mat) ' index=' num2str(index)]);

plot(step_size_ar_mat,epsilon_dr);
title(['step size est dr=' num2str(step_size_est_mat) ' index=' num2str(index_dr)]);


%% строим символы с заданной скорректированной задержкой
% for delayVec_test=0:delayVec/16:0.5
x_mat = 1:(length(data_after_rx_filter_mat));
xx_fixed_mat = x_mat + delayVec/4;
yy_r_mat = spline(x_mat,real(data_after_rx_filter_mat),xx_fixed_mat);
yy_i_mat = spline(x_mat,imag(data_after_rx_filter_mat),xx_fixed_mat);
scatterplot(complex(yy_r_mat,yy_i_mat));
title(['after symbol sync known data delay vec =' num2str(delayVec/4)]);
% end

%% строим символы с найденной задержкой
% for delayVec_test=0:delayVec/16:0.5
x_mat = 1:(length(data_after_rx_filter_mat));
xx_fixed_mat = x_mat + step_size_est_mat;
yy_r_mat = spline(x_mat,real(data_after_rx_filter_mat),xx_fixed_mat);
yy_i_mat = spline(x_mat,imag(data_after_rx_filter_mat),xx_fixed_mat);
scatterplot(complex(yy_r_mat,yy_i_mat));
title(['after symbol sync est data delay vec =' num2str(step_size_est_mat)]);
% end


x_mat = 1:(length(data_after_rx_filter_mat));
xx_fixed_mat = x_mat + step_size_est_mat;
yy_r_mat = spline(x_mat,real(data_after_rx_filter_mat),xx_fixed_mat);
yy_i_mat = spline(x_mat,imag(data_after_rx_filter_mat),xx_fixed_mat);
scatterplot(complex(yy_r_mat,yy_i_mat));
title(['after symbol sync est data delay vec dr =' num2str(step_size_est_dr_mat)]);


real_data_sim = 0;
if real_data_sim == 1
    
    %% константы для подстройки временной задержки
    start_sym = 0;
    point_num_real = length(data_after_rx_filter_real);
    
    
    x_real = 1:point_num_real;
    yy_r_real = zeros(0,0);
    yy_i_real = zeros(0,0);
    
    %% подстройка временной задержки
    i = 1;
    step_size_start_real = 0;
    step_size_end_real = 0.25;
    step_of_loop_real = (step_size_end_real-step_size_start_real)/1e3;
    
    for step_size_real = step_size_start_real:step_of_loop_real:step_size_end_real
        
        %задаем новые точки
        step_size_ar_real(i) = step_size_real;
        xx_fixed_real = x_real(1:point_num_real) + step_size_real;
        % получаем значения функции в этих точках
        yy_r_real = spline(x_real,real(data_after_rx_filter_real),xx_fixed_real);
        yy_i_real = spline(x_real,imag(data_after_rx_filter_real),xx_fixed_real);
        epsilon_dr(i) = max(abs(xcorr(y_real,complex(yy_r_real,yy_r_real))));
        
        epsilon(i) = abs(sum(conj(y_real) .* complex(yy_r_real,yy_i_real)'));%(1:4:end)
        i = i + 1;
        % строим график
        %     scatterplot(complex(yy_r(1:4:end),yy_i(1:4:end)));%(1:4:end)
        %         scatterplot(complex(yy_r,yy_i));%(1:4:end)
        
        %     title(['fix step size=' num2str(step_size) ' index=' num2str(i) 'wo phase corr']);
    end
    figure;
    plot(epsilon);
    figure;
    [max_val, index] = max(epsilon);
    step_size_est_real = step_size_start_real + (index - 1) * step_of_loop_real;
    
    figure;
    plot(epsilon_dr);
    figure;
    [max_val_dr, index_dr] = max(epsilon_dr(:));
    step_size_est_dr_real = step_size_start_real + (index_dr - 1) * step_of_loop_real;
    
    plot(step_size_ar_real,epsilon);
    title(['step size est=' num2str(step_size_est_real) ' index=' num2str(index)]);
    
    plot(step_size_ar_real,epsilon_dr);
    title(['step size est dr=' num2str(step_size_est_real) ' index=' num2str(index)]);
    
    
    %% строим символы с заданной скорректированной задержкой
    % for delayVec_test=0:delayVec/16:0.5
    x_real = 1:(length(data_after_rx_filter_real));
    xx_fixed_real = x_real + delayVec/4;
    yy_r_real = spline(x_real,real(data_after_rx_filter_real),xx_fixed_real);
    yy_i_real = spline(x_real,imag(data_after_rx_filter_real),xx_fixed_real);
    scatterplot(complex(yy_r_real,yy_i_real));
    title(['after symbol sync known data delay vec =' num2str(delayVec/4)]);
    % end
    
    %% строим символы с найденной задержкой
    % for delayVec_test=0:delayVec/16:0.5
    x_real = 1:(length(data_after_rx_filter_real));
    xx_fixed_real = x_real + step_size_est_real;
    yy_r_real = spline(x_real,real(data_after_rx_filter_real),xx_fixed_real);
    yy_i_real = spline(x_real,imag(data_after_rx_filter_real),xx_fixed_real);
    scatterplot(complex(yy_r_real,yy_i_real));
    title(['after symbol sync est data delay vec =' num2str(step_size_est_real)]);
    % end
    
    
    x_real = 1:(length(data_after_rx_filter_real));
    xx_fixed = x_real + step_size_est_real;
    yy_r_real = spline(x_real,real(data_after_rx_filter_real),xx_fixed_real);
    yy_i_real = spline(x_real,imag(data_after_rx_filter_real),xx_fixed_real);
    scatterplot(complex(yy_r_real,yy_i_real));
    title(['after symbol sync est data delay vec dr =' num2str(step_size_est_dr_real)]);
end



