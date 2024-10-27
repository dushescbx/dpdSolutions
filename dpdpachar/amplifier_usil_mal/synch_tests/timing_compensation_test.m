close all
clear all

APSK_ar = 32;
f = 1;
i = 1;
ARBitrary_TRIGger_SLENgth = 1e4;
T = 1;

run('constant_for_model.m');
run('download_power_arrays.m');


%% «ј√–”∆ј≈ћ идеальные символы
load(['C:\Users\imya\Desktop\27-03\amplifier_usil_mal\_'...
    num2str(APSK_ar(f)) 'APSK_ref_symb_before_transm_filter.mat']);
% load(['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier_usil_mal\_'...
%     num2str(APSK_ar(f)) 'APSK_ref_symb_before_transm_filter.mat']);


data_in_ADD = complex(I,Q);
scatterplot(data_in_ADD);

%% формируем передающий фильтр
txfilter = comm.RaisedCosineTransmitFilter('FilterSpanInSymbols',10,'OutputSamplesPerSymbol',4);


data_after_tx_filter = txfilter(data_in_ADD);
% scatterplot(data_after_tx_filter);

%% формируем временную задержку
varDelay = dsp.VariableFractionalDelay;

delayVec = [2.15];
delaySig = varDelay(data_after_tx_filter,delayVec);


% nSamp = length(data_after_tx_filter);
% vdelay = (0:1/nSamp:1-1/nSamp)';
% delaySig = varDelay(data_after_tx_filter,vdelay);
% scatterplot(delaySig);

%% формируем принимающий фильтр
rxfilter = comm.RaisedCosineReceiveFilter('InputSamplesPerSymbol',4, ...
    'DecimationFactor',4);
data_after_rx_filter = rxfilter(delaySig);
scatterplot(data_after_rx_filter);


%% константы дл€ подстройки временной задержки
start_sym = 0;
point_num = length(data_after_rx_filter);


x = 1:point_num;
yy_r = zeros(0,0);
yy_i = zeros(0,0);
% % % % % 
% % % % % %% подстройка временной задержки
% % % % % i = 1;
% % % % % step_size_start = 0;
% % % % % step_of_loop = 0.1;
% % % % % step_size_end = 1;
% % % % % for step_size = step_size_start:step_of_loop:step_size_end
% % % % %     
% % % % %     %задаем новые точки
% % % % %     step_size_ar(i) = step_size;
% % % % %     xx_fixed = x(1:point_num) + step_size;
% % % % %     % получаем значени€ функции в этих точках
% % % % %     %     yy_r = spline(x,real(demod_sym_after_filt(1:length(x))),xx_fixed);
% % % % %     %     yy_i = spline(x,imag(demod_sym_after_filt(1:length(x))),xx_fixed);
% % % % %     yy_r = spline(x,real(data_after_rx_filter(1:length(x))),xx_fixed);
% % % % %     yy_i = spline(x,imag(data_after_rx_filter(1:length(x))),xx_fixed);
% % % % % %     epsilon(i) = abs(sum(conj(data_in_ADD(1:length(yy_r))) .* complex(yy_r,yy_i)'));%(1:4:end)
% % % % %   epsilon(i) = abs(sum(conj(data_in_ADD(1:4:length(yy_r))) .* complex(yy_r(1:4:end),yy_i(1:4:end))'));%(1:4:end)
% % % % %     i = i + 1;
% % % % %     % строим график
% % % % % %     scatterplot(complex(yy_r(1:4:end),yy_i(1:4:end)));%(1:4:end)
% % % % % %     scatterplot(complex(yy_r(1:4:end),yy_i(1:4:end)));%(1:4:end)
% % % % %     
% % % % %     title(['fix step size=' num2str(step_size) ' index=' num2str(i) 'wo phase corr']);
% % % % % end
% % % % % 
% % % % % figure;
% % % % % [max, index] = max(epsilon);
% % % % % step_size_est = step_size_start + (index - 1) * step_of_loop;
% % % % % 
% % % % % plot(step_size_ar,epsilon);
% % % % % title(['step size est=' num2str(step_size_est) ' index=' num2str(index)]);
% % % % % 
%% строим символы с заданной задержкой
    xx_fixed = x(1:point_num) + delayVec/4;
    yy_r = spline(x,real(data_after_rx_filter(1:length(x))),xx_fixed);
    yy_i = spline(x,imag(data_after_rx_filter(1:length(x))),xx_fixed); 
%     scatterplot(complex(yy_r(1:4:end),yy_i(1:4:end)));
 scatterplot(complex(yy_r,yy_i));

    