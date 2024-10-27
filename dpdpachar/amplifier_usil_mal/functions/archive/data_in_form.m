%% загрузка входных данных

function data_in=data_in_form(offset)
%% 0 дЅм на входе
load('File0.DAT.mat');

data_in_0dbm=simin.data;
av_input_power=mean(abs(data_in_0dbm).^2);
av_input_power_expected=1e-3*10^((-0-offset)/10);
diff=av_input_power_expected/av_input_power;%на сколько дбм изменить входной сигнал
data_in_0dbm=data_in_0dbm*sqrt(diff);
av_input_power=10*log10(mean(abs(data_in_0dbm).^2/1e-3));


%% 3 дЅм на входе

data_in_3dbm=simin.data;
av_input_power=mean(abs(data_in_3dbm).^2);
av_input_power_expected=1e-3*10^((3-offset)/10);
diff=av_input_power_expected/av_input_power;%на сколько дбм изменить входной сигнал
data_in_3dbm=data_in_3dbm*sqrt(diff);
av_input_power=10*log10(mean(abs(data_in_3dbm).^2/1e-3));




%% 7 дЅм на входе

data_in_7dbm=simin.data;
av_input_power=mean(abs(data_in_7dbm).^2);
av_input_power_expected=1e-3*10^((7-offset)/10);
diff=av_input_power_expected/av_input_power;%на сколько дбм изменить входной сигнал
data_in_7dbm=data_in_7dbm*sqrt(diff);
av_input_power=10*log10(mean(abs(data_in_7dbm).^2/1e-3));


%% 10 дЅм на входе

data_in_10dbm=simin.data;
av_input_power=mean(abs(data_in_10dbm).^2);
av_input_power_expected=1e-3*10^((10-offset)/10);
diff=av_input_power_expected/av_input_power;%на сколько дбм изменить входной сигнал
data_in_10dbm=data_in_10dbm*sqrt(diff);
av_input_power=10*log10(mean(abs(data_in_10dbm).^2/1e-3));


%% 13 дЅм на входе

data_in_13dbm=simin.data;
av_input_power=mean(abs(data_in_13dbm).^2);
av_input_power_expected=1e-3*10^((13-offset)/10);
diff=av_input_power_expected/av_input_power;%на сколько дбм изменить входной сигнал
data_in_13dbm=data_in_13dbm*sqrt(diff);
av_input_power=10*log10(mean(abs(data_in_13dbm).^2/1e-3));

% 15 дЅм на входе

data_in_15dbm=simin.data;
av_input_power=mean(abs(data_in_15dbm).^2);
av_input_power_expected=1e-3*10^((15-offset)/10);
diff=av_input_power_expected/av_input_power;%на сколько дбм изменить входной сигнал
data_in_15dbm=data_in_15dbm*sqrt(diff);
av_input_power=10*log10(mean(abs(data_in_15dbm).^2/1e-3));




%% объединение 0 и 5 и 10 дЅм data_in_min5dbm;
data_in=[data_in_0dbm;  data_in_3dbm; data_in_7dbm; data_in_10dbm;data_in_13dbm;  data_in_15dbm;];%data_in_0dbm;data_in;data_in_2dbm; data_in_5dbm; data_in_0dbm;data_in_10dbm;

end


% % % %% -5 дЅм на входе
% % % load('inp_5dbm.DAT.mat');
% % % % load('inp_0dbm.DAT.mat')
% % % data_in_min5dbm=abs(simin.data);
% % % av_input_power=mean(abs(data_in_min5dbm).^2);
% % % av_input_power_expected=1e-3*10^((-5-offset)/10);
% % % diff=av_input_power_expected/av_input_power;%на сколько дбм изменить входной сигнал
% % % data_in_min5dbm=data_in_min5dbm*sqrt(diff);
% % % av_input_power=10*log10(mean(abs(data_in_min5dbm).^2/1e-3));
% % % 
% % % 
% % % %% 0 дЅм на входе
% % % % load('inp_0dbm.DAT.mat')
% % % % load('0dbm.DAT.mat')
% % % data_in_0dbm=abs(simin.data);
% % % av_input_power=mean(abs(data_in_0dbm).^2);
% % % av_input_power_expected=1e-3*10^((0-offset)/10);
% % % diff=av_input_power_expected/av_input_power;%на сколько дбм изменить входной сигнал
% % % data_in_0dbm=data_in_0dbm*sqrt(diff);
% % % av_input_power=10*log10(mean(abs(data_in_0dbm).^2/1e-3));
% % % 
% % % 
% % % 
% % % 
% % % %% 2 дЅм на входе
% % % % load('inp_3dbm.DAT.mat')
% % % % load('+3dbm.DAT.mat')
% % % data_in_2dbm=abs(simin.data);
% % % av_input_power=mean(abs(data_in_2dbm).^2);
% % % av_input_power_expected=1e-3*10^((2-offset)/10);
% % % diff=av_input_power_expected/av_input_power;%на сколько дбм изменить входной сигнал
% % % data_in_2dbm=data_in_2dbm*sqrt(diff);
% % % av_input_power=10*log10(mean(abs(data_in_2dbm).^2/1e-3));
% % % 
% % % 
% % % %% 3 дЅм на входе
% % % % load('inp_3dbm.DAT.mat')
% % % % load('+3dbm.DAT.mat')
% % % data_in_3dbm=abs(simin.data);
% % % av_input_power=mean(abs(data_in_3dbm).^2);
% % % av_input_power_expected=1e-3*10^((3-offset)/10);
% % % diff=av_input_power_expected/av_input_power;%на сколько дбм изменить входной сигнал
% % % data_in_3dbm=data_in_3dbm*sqrt(diff);
% % % av_input_power=10*log10(mean(abs(data_in_3dbm).^2/1e-3));
% % % 
% % % 
% % % %% 4 дЅм на входе
% % % % load('inp_5dbm.DAT.mat');
% % % % load('+5dbm.DAT.mat')
% % % data_in_4dbm=abs(simin.data);
% % % av_input_power=mean(abs(data_in_4dbm).^2);
% % % av_input_power_expected=1e-3*10^((4-offset)/10);
% % % diff=av_input_power_expected/av_input_power;%на сколько дбм изменить входной сигнал
% % % % diff_raz=sqrt(10^(diff/10)*1e-3);
% % % data_in_4dbm=data_in_4dbm*sqrt(diff);
% % % av_input_power=10*log10(mean(abs(data_in_4dbm).^2/1e-3));
% % % 
% % % % 5 дЅм на входе
% % % % load('inp_5dbm.DAT.mat');
% % % % load('+5dbm.DAT.mat')
% % % data_in_5dbm=abs(simin.data);
% % % av_input_power=mean(abs(data_in_5dbm).^2);
% % % av_input_power_expected=1e-3*10^((5-offset)/10);
% % % diff=av_input_power_expected/av_input_power;%на сколько дбм изменить входной сигнал
% % % % diff_raz=sqrt(10^(diff/10)*1e-3);
% % % data_in_5dbm=data_in_5dbm*sqrt(diff);
% % % av_input_power=10*log10(mean(abs(data_in_5dbm).^2/1e-3));
% % % 
% % % 
% % % 
% % % %% 10 дЅм на входе
% % % % load('inp_5dbm.DAT.mat')
% % % % load('+5dbm.DAT.mat')
% % % data_in_10dbm=abs(simin.data);
% % % av_input_power=mean(abs(data_in_10dbm).^2);
% % % av_input_power_expected=1e-3*10^((10-offset)/10);
% % % diff=av_input_power_expected/av_input_power;%на сколько дбм изменить входной сигнал
% % % data_in_10dbm=data_in_10dbm*sqrt(diff);
% % % av_input_power=10*log10(mean(abs(data_in_10dbm).^2/1e-3));
