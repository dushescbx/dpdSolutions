function data_out=data_out_form(av_output_power_array)

%% 0дЅм на входе
load('File0.DAT.mat');
data_out_0dbm=simin.data;
av_output_power=mean(abs(data_out_0dbm).^2);
av_output_power_expected=1e-3*10^(av_output_power_array(1)/10);
diff=av_output_power_expected/av_output_power;%на сколько дбм изменить входной сигнал
data_out_0dbm=data_out_0dbm*sqrt(diff);
av_output_power=10*log10(mean(abs(data_out_0dbm).^2/1e-3));

%% 3дЅм на входе
load('File0_003.DAT.mat');
data_out_3dbm=simin.data;
av_output_power=mean(abs(data_out_3dbm).^2);
av_output_power_expected=1e-3*10^(av_output_power_array(2)/10);
diff=av_output_power_expected/av_output_power;%на сколько дбм изменить входной сигнал
data_out_3dbm=data_out_3dbm*sqrt(diff);
av_output_power=10*log10(mean(abs(data_out_3dbm).^2/1e-3));

%% 7дЅм на входе
load('File0_007.DAT.mat');
data_out_7dbm=simin.data;
av_output_power=mean(abs(data_out_7dbm).^2);
av_output_power_expected=1e-3*10^(av_output_power_array(3)/10);
diff=av_output_power_expected/av_output_power;%на сколько дбм изменить входной сигнал
data_out_7dbm=data_out_7dbm*sqrt(diff);
av_output_power=10*log10(mean(abs(data_out_7dbm).^2/1e-3));

%% 10дЅм на входе
load('File0_010.DAT.mat');
data_out_10dbm=simin.data;
av_output_power=mean(abs(data_out_10dbm).^2);
av_output_power_expected=1e-3*10^(av_output_power_array(4)/10);
diff=av_output_power_expected/av_output_power;%на сколько дбм изменить входной сигнал
data_out_10dbm=data_out_10dbm*sqrt(diff);
av_output_power=10*log10(mean(abs(data_out_10dbm).^2/1e-3));


%% 13дЅм на входе
load('File0_013.DAT.mat');
data_out_13dbm=simin.data;
av_output_power=mean(abs(data_out_13dbm).^2);
av_output_power_expected=1e-3*10^(av_output_power_array(5)/10);
diff=av_output_power_expected/av_output_power;%на сколько дбм изменить входной сигнал
data_out_13dbm=data_out_13dbm*sqrt(diff);
av_output_power=10*log10(mean(abs(data_out_13dbm).^2/1e-3));


%% 15дЅм на входе
load('File0_015.DAT.mat');
data_out_15dbm=simin.data;
av_output_power=mean(abs(data_out_15dbm).^2);
av_output_power_expected=1e-3*10^(av_output_power_array(6)/10);
diff=av_output_power_expected/av_output_power;%на сколько дбм изменить входной сигнал
data_out_15dbm=data_out_15dbm*sqrt(diff);
av_output_power=10*log10(mean(abs(data_out_15dbm).^2/1e-3));


%% объединение -5 0 2 3 4 и 5 и 10 дЅм data_out_min5dbm;
data_out=[   data_out_0dbm;  data_out_3dbm; data_out_7dbm; data_out_10dbm; data_out_13dbm;   data_out_15dbm  ];

end

% % % %% -5дЅм на входе
% % % load('inp_5dbm.DAT.mat');
% % % % load('0dbm.DAT.mat')
% % % % data_out_min5dbm=abs(simin.data);
% % % % av_output_power=mean(abs(data_out_min5dbm).^2);
% % % % av_output_power_expected=1e-3*10^(av_output_power_array(1)/10);
% % % % diff=av_output_power_expected/av_output_power;%на сколько дбм изменить входной сигнал
% % % % data_out_min5dbm=data_out_min5dbm*sqrt(diff);
% % % % av_output_power=10*log10(mean(abs(data_out_min5dbm).^2/1e-3));
% % % 
% % % %% 0дЅм на входе
% % % % load('inp_0dbm.DAT.mat')
% % % % load('0dbm.DAT.mat')
% % % data_out_0dbm=abs(simin.data);
% % % av_output_power=mean(abs(data_out_0dbm).^2);
% % % av_output_power_expected=1e-3*10^(av_output_power_array(1)/10);
% % % diff=av_output_power_expected/av_output_power;%на сколько дбм изменить входной сигнал
% % % data_out_0dbm=data_out_0dbm*sqrt(diff);
% % % av_output_power=10*log10(mean(abs(data_out_0dbm).^2/1e-3));
% % % 
% % % %% 2дЅм на входе
% % % % load('inp_3dbm.DAT.mat')
% % % % load('+3dbm.DAT.mat')
% % % data_out_2dbm=abs(simin.data);
% % % av_output_power=mean(abs(data_out_2dbm).^2);
% % % av_output_power_expected=1e-3*10^(av_output_power_array(2)/10);
% % % diff=av_output_power_expected/av_output_power;%на сколько дбм изменить входной сигнал
% % % data_out_2dbm=data_out_2dbm*sqrt(diff);
% % % av_output_power=10*log10(mean(abs(data_out_2dbm).^2/1e-3));
% % % 
% % % %% 3дЅм на входе
% % % % load('+3dbm.DAT.mat')
% % % % load('inp_3dbm.DAT.mat')
% % % data_out_3dbm=abs(simin.data);
% % % av_output_power=mean(abs(data_out_3dbm).^2);
% % % av_output_power_expected=1e-3*10^(av_output_power_array(3)/10);
% % % diff=av_output_power_expected/av_output_power;%на сколько дбм изменить входной сигнал
% % % data_out_3dbm=data_out_3dbm*sqrt(diff);
% % % av_output_power=10*log10(mean(abs(data_out_3dbm).^2/1e-3));
% % % 
% % % 
% % % %% 4дЅм на входе
% % % % load('inp_5dbm.DAT.mat')
% % % % load('+5dbm.DAT.mat')
% % % data_out_4dbm=abs(simin.data);
% % % av_output_power=mean(abs(data_out_4dbm).^2);
% % % av_output_power_expected=1e-3*10^(av_output_power_array(4)/10);
% % % diff=av_output_power_expected/av_output_power;%на сколько дбм изменить входной сигнал
% % % data_out_4dbm=data_out_4dbm*sqrt(diff);
% % % av_output_power=10*log10(mean(abs(data_out_4dbm).^2/1e-3));
% % % 
% % % 
% % % %% 5дЅм на входе
% % % % load('inp_5dbm.DAT.mat')
% % % % load('+5dbm.DAT.mat')
% % % data_out_5dbm=abs(simin.data);
% % % av_output_power=mean(abs(data_out_5dbm).^2);
% % % av_output_power_expected=1e-3*10^(av_output_power_array(5)/10);
% % % diff=av_output_power_expected/av_output_power;%на сколько дбм изменить входной сигнал
% % % data_out_5dbm=data_out_5dbm*sqrt(diff);
% % % av_output_power=10*log10(mean(abs(data_out_5dbm).^2/1e-3));
% % % 
% % % 
% % % %% 10дЅм на входе
% % % % load('inp_5dbm.DAT.mat')
% % % % load('+5dbm.DAT.mat')
% % % data_out_10dbm=abs(simin.data);
% % % av_output_power=mean(abs(data_out_10dbm).^2);
% % % av_output_power_expected=1e-3*10^(av_output_power_array(6)/10);
% % % diff=av_output_power_expected/av_output_power;%на сколько дбм изменить входной сигнал
% % % data_out_10dbm=data_out_10dbm*sqrt(diff);
% % % av_output_power=10*log10(mean(abs(data_out_10dbm).^2/1e-3));
