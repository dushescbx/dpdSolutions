clear all;
% close all;
run('constant_for_model.m');
load('a_coef.mat');

av_power=-15:2:5;
offset_in=-23.5;%%сдвиг характеристики усилител€
offset_out=27.5;
%% загрузка входных данных

%% -6 дЅм на входе
load('_-8dbm_DPD_on=False_input=fal.DAT.mat')
data_in_min6dbm=simin.data;
av_input_power=mean(abs(data_in_min6dbm).^2);
av_input_power_expected=1e-3*10^((-6-offset_in)/10);
diff=av_input_power_expected/av_input_power;%на сколько дбм изменить входной сигнал
data_in_min6dbm=data_in_min6dbm*sqrt(diff);
av_input_power=10*log10(mean(abs(data_in_min6dbm).^2/1e-3));


%% -10 дЅм на входе
load('_-8dbm_DPD_on=False_input=fal.DAT.mat')
data_in_m10dbm=simin.data;
av_input_power=mean(abs(data_in_m10dbm).^2);
av_input_power_expected=1e-3*10^((-10-offset_in)/10);
diff=av_input_power_expected/av_input_power;%на сколько дбм изменить входной сигнал
data_in_m10dbm=data_in_m10dbm*sqrt(diff);
av_input_power=10*log10(mean(abs(data_in_m10dbm).^2/1e-3));



%% объединение 0 и 5 и 10 дЅм data_in_min5dbm;
data_in=[ data_in_min6dbm, data_in_m10dbm ];


%% загрузка выходных значений мощности (со смещением)
av_output_power_array=[ 45.85+offset_out 43.4+offset_out ];

%% -6дЅм на входе
load('m6dbm_DPD_on=False_input=False.DAT.mat')
data_out_m6dbm=simin.data;
av_output_power=mean(abs(data_out_m6dbm).^2);
av_output_power_expected=1e-3*10^(av_output_power_array(1)/10);
diff=av_output_power_expected/av_output_power;%на сколько дбм изменить входной сигнал
data_out_m6dbm=data_out_m6dbm*sqrt(diff);
av_output_power=10*log10(mean(abs(data_out_m6dbm).^2/1e-3));


%% -10дЅм на входе
load('_-10dbm_DPD_on=False_input=True.DAT.mat')
data_out_m10dbm=simin.data;
av_output_power=mean(abs(data_out_m10dbm).^2);
av_output_power_expected=1e-3*10^(av_output_power_array(2)/10);
diff=av_output_power_expected/av_output_power;%на сколько дбм изменить входной сигнал
data_out_m10dbm=data_out_m10dbm*sqrt(diff);
av_output_power=10*log10(mean(abs(data_out_m10dbm).^2/1e-3));

%% объединение массивов выходных данных 
data_out=[   data_out_m6dbm; data_out_m10dbm  ];

a_coef = fit_memory_poly_model(data_in,data_out,PAmemory,PAorder,'MemPoly')
save('a_coef.mat','a_coef');



for i=1:1:length(av_power)
    
    load('_-8dbm_DPD_on=False_input=fal.DAT.mat')
    av_input_power=mean(abs(simin.data).^2);
    av_input_power_expected=1e-3*10^(av_power(i)/10);
    diff=av_input_power_expected/av_input_power;%на сколько дбм изменить входной сигнал
    simin.data=simin.data*sqrt(diff);
    av_input_power=10*log10(mean(abs(simin.data).^2/1e-3))
    
    sim('dpd_static_verify_01_04_find_opt_volterra_20_05.slx');
    data_in_ar_power(i)=mean(abs(data_in)).^2;
    data_out_ar_power(i)=mean(abs(data_out)).^2;
end

%% строим графики
figure
plot(10*log10(data_in_ar_power/1e-3),10*log10(data_out_ar_power/1e-3),'-o');%
hold on;
plot([5.3 4.8 4.3 3.8 3.3 2.8 2.3 1.8 1.3 0.8 0.3 -0.2 -0.7 -1.2 -1.7 -2.3 -2.8 -3.3 -3.8 -4.3 -4.8 -5.3 -6.3 -7.3 -8.3 -9.3 -10.3],([45.2504480703685 45.5750720190566 45.8771096501891 46.1278385671974 46.4048143697042 46.6275783168157 46.8124123737559 46.9722934275972 47.1011736511182 47.1933128698373 47.2509452108147 47.2754125702856 47.2672720902657 47.2345567203519 47.1767050300226 47.0757017609794 46.9722934275972 46.8394713075151 46.7024585307412 46.5417654187796 46.3648789635337 46.1595005165640 45.7287160220048 45.2113808370404 44.6239799789896 43.9445168082622 43.2221929473392]));
% plot(10*log10(data_in_ar_power),10*log10(data_out_ar_power),'-o');%dB
grid on;
grid minor;
title('’арактеристика усилител€','FontName','Arial Cyr');
xlabel('P_в_х , dBm','FontName','Arial Cyr');
ylabel('P_в_ы_х , dBm','FontName','Arial Cyr');
% xlabel('P_в_х , dB','FontName','Arial Cyr');
% ylabel('P_в_ы_х , dB','FontName','Arial Cyr');

