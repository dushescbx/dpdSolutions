function data_out=data_out_form(av_output_power_array)

%% 0��� �� �����
load('File0.DAT.mat');
data_out_0dbm=simin.data;
av_output_power=mean(abs(data_out_0dbm).^2);
av_output_power_expected=1e-3*10^(av_output_power_array(1)/10);
diff=av_output_power_expected/av_output_power;%�� ������� ��� �������� ������� ������
data_out_0dbm=data_out_0dbm*sqrt(diff);
av_output_power=10*log10(mean(abs(data_out_0dbm).^2/1e-3));

%% 3��� �� �����
load('File0_003.DAT.mat');
data_out_3dbm=simin.data;
av_output_power=mean(abs(data_out_3dbm).^2);
av_output_power_expected=1e-3*10^(av_output_power_array(2)/10);
diff=av_output_power_expected/av_output_power;%�� ������� ��� �������� ������� ������
data_out_3dbm=data_out_3dbm*sqrt(diff);
av_output_power=10*log10(mean(abs(data_out_3dbm).^2/1e-3));

%% 7��� �� �����
load('File0_007.DAT.mat');
data_out_7dbm=simin.data;
av_output_power=mean(abs(data_out_7dbm).^2);
av_output_power_expected=1e-3*10^(av_output_power_array(3)/10);
diff=av_output_power_expected/av_output_power;%�� ������� ��� �������� ������� ������
data_out_7dbm=data_out_7dbm*sqrt(diff);
av_output_power=10*log10(mean(abs(data_out_7dbm).^2/1e-3));

%% 10��� �� �����
load('File0_010.DAT.mat');
data_out_10dbm=simin.data;
av_output_power=mean(abs(data_out_10dbm).^2);
av_output_power_expected=1e-3*10^(av_output_power_array(4)/10);
diff=av_output_power_expected/av_output_power;%�� ������� ��� �������� ������� ������
data_out_10dbm=data_out_10dbm*sqrt(diff);
av_output_power=10*log10(mean(abs(data_out_10dbm).^2/1e-3));


%% 13��� �� �����
load('File0_013.DAT.mat');
data_out_13dbm=simin.data;
av_output_power=mean(abs(data_out_13dbm).^2);
av_output_power_expected=1e-3*10^(av_output_power_array(5)/10);
diff=av_output_power_expected/av_output_power;%�� ������� ��� �������� ������� ������
data_out_13dbm=data_out_13dbm*sqrt(diff);
av_output_power=10*log10(mean(abs(data_out_13dbm).^2/1e-3));


%% 15��� �� �����
load('File0_015.DAT.mat');
data_out_15dbm=simin.data;
av_output_power=mean(abs(data_out_15dbm).^2);
av_output_power_expected=1e-3*10^(av_output_power_array(6)/10);
diff=av_output_power_expected/av_output_power;%�� ������� ��� �������� ������� ������
data_out_15dbm=data_out_15dbm*sqrt(diff);
av_output_power=10*log10(mean(abs(data_out_15dbm).^2/1e-3));


%% ����������� -5 0 2 3 4 � 5 � 10 ��� data_out_min5dbm;
data_out=[   data_out_0dbm;  data_out_3dbm; data_out_7dbm; data_out_10dbm; data_out_13dbm;   data_out_15dbm  ];

end

% % % %% -5��� �� �����
% % % load('inp_5dbm.DAT.mat');
% % % % load('0dbm.DAT.mat')
% % % % data_out_min5dbm=abs(simin.data);
% % % % av_output_power=mean(abs(data_out_min5dbm).^2);
% % % % av_output_power_expected=1e-3*10^(av_output_power_array(1)/10);
% % % % diff=av_output_power_expected/av_output_power;%�� ������� ��� �������� ������� ������
% % % % data_out_min5dbm=data_out_min5dbm*sqrt(diff);
% % % % av_output_power=10*log10(mean(abs(data_out_min5dbm).^2/1e-3));
% % % 
% % % %% 0��� �� �����
% % % % load('inp_0dbm.DAT.mat')
% % % % load('0dbm.DAT.mat')
% % % data_out_0dbm=abs(simin.data);
% % % av_output_power=mean(abs(data_out_0dbm).^2);
% % % av_output_power_expected=1e-3*10^(av_output_power_array(1)/10);
% % % diff=av_output_power_expected/av_output_power;%�� ������� ��� �������� ������� ������
% % % data_out_0dbm=data_out_0dbm*sqrt(diff);
% % % av_output_power=10*log10(mean(abs(data_out_0dbm).^2/1e-3));
% % % 
% % % %% 2��� �� �����
% % % % load('inp_3dbm.DAT.mat')
% % % % load('+3dbm.DAT.mat')
% % % data_out_2dbm=abs(simin.data);
% % % av_output_power=mean(abs(data_out_2dbm).^2);
% % % av_output_power_expected=1e-3*10^(av_output_power_array(2)/10);
% % % diff=av_output_power_expected/av_output_power;%�� ������� ��� �������� ������� ������
% % % data_out_2dbm=data_out_2dbm*sqrt(diff);
% % % av_output_power=10*log10(mean(abs(data_out_2dbm).^2/1e-3));
% % % 
% % % %% 3��� �� �����
% % % % load('+3dbm.DAT.mat')
% % % % load('inp_3dbm.DAT.mat')
% % % data_out_3dbm=abs(simin.data);
% % % av_output_power=mean(abs(data_out_3dbm).^2);
% % % av_output_power_expected=1e-3*10^(av_output_power_array(3)/10);
% % % diff=av_output_power_expected/av_output_power;%�� ������� ��� �������� ������� ������
% % % data_out_3dbm=data_out_3dbm*sqrt(diff);
% % % av_output_power=10*log10(mean(abs(data_out_3dbm).^2/1e-3));
% % % 
% % % 
% % % %% 4��� �� �����
% % % % load('inp_5dbm.DAT.mat')
% % % % load('+5dbm.DAT.mat')
% % % data_out_4dbm=abs(simin.data);
% % % av_output_power=mean(abs(data_out_4dbm).^2);
% % % av_output_power_expected=1e-3*10^(av_output_power_array(4)/10);
% % % diff=av_output_power_expected/av_output_power;%�� ������� ��� �������� ������� ������
% % % data_out_4dbm=data_out_4dbm*sqrt(diff);
% % % av_output_power=10*log10(mean(abs(data_out_4dbm).^2/1e-3));
% % % 
% % % 
% % % %% 5��� �� �����
% % % % load('inp_5dbm.DAT.mat')
% % % % load('+5dbm.DAT.mat')
% % % data_out_5dbm=abs(simin.data);
% % % av_output_power=mean(abs(data_out_5dbm).^2);
% % % av_output_power_expected=1e-3*10^(av_output_power_array(5)/10);
% % % diff=av_output_power_expected/av_output_power;%�� ������� ��� �������� ������� ������
% % % data_out_5dbm=data_out_5dbm*sqrt(diff);
% % % av_output_power=10*log10(mean(abs(data_out_5dbm).^2/1e-3));
% % % 
% % % 
% % % %% 10��� �� �����
% % % % load('inp_5dbm.DAT.mat')
% % % % load('+5dbm.DAT.mat')
% % % data_out_10dbm=abs(simin.data);
% % % av_output_power=mean(abs(data_out_10dbm).^2);
% % % av_output_power_expected=1e-3*10^(av_output_power_array(6)/10);
% % % diff=av_output_power_expected/av_output_power;%�� ������� ��� �������� ������� ������
% % % data_out_10dbm=data_out_10dbm*sqrt(diff);
% % % av_output_power=10*log10(mean(abs(data_out_10dbm).^2/1e-3));
