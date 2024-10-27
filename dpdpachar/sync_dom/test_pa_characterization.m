clear all
close all
%% ������ ���������
M = [4 8 20];
radii = [0.3 0.7 1.2];
modOrder = sum(M);
data_length = 1e4;
% x = randi([0 modOrder-1],data_length,1);
% data_in = apskmod(x,M,radii);
load('data_in_mat.mat');
data_in = data_in_mat(1:data_length);

%% ������ ��������
power_ar = -30 : 5 : 30;
%% ������ ���������
ampl_saleh = comm.MemorylessNonlinearity('Method','Saleh model');
%% ������ �������
%% ���������� ������
txfilter = comm.RaisedCosineTransmitFilter('FilterSpanInSymbols', 10, 'OutputSamplesPerSymbol', 4);
%% ����������� ������
rxfilter = comm.RaisedCosineReceiveFilter('InputSamplesPerSymbol',4, ...
    'DecimationFactor',4);
scatterplot(data_in);
tx_filt_out = txfilter(data_in);
rx_filt_out = rxfilter(tx_filt_out);
scatterplot(rx_filt_out);

data_out_power = zeros(1,length(power_ar));
data_out_angle = zeros(1,length(power_ar));
for i = 1 : length(power_ar)
    
    %% ���������� ������
    tx_filt_out = txfilter(data_in);
    %% ������������ ������
    tx_filt_out(:,i) = scale_power(tx_filt_out, power_ar, i);
    %% ���������� ����� ���������
    ampl_out(:,i) = ampl_saleh(tx_filt_out(:,i));
    %% ��������� �������� ��������
    data_out_power(i)=10*log10(mean(abs(ampl_out(:,i)).^2)/1e-3);
    %% ��������� ������� ���������
    data_out_angle(i) = phase_offset(ampl_out(:,i), tx_filt_out(:,i));
    %% ����������� ������
    rx_filt_out = rxfilter(ampl_out(:,i));
    scatterplot(rx_filt_out);
    title( [ 'rx filter out power =' num2str(power_ar(i)) ] );
    
end

%% ������ ���������
%% ��������� ������������� ��� ������ ���������
PAmemory = 5;
PAorder = 5;
ampl_out = ampl_out.';
tx_filt_out = tx_filt_out.';
a_coef = fit_memory_poly_model(tx_filt_out(:), ampl_out(:), PAmemory, PAorder, 'MemPoly')
save(['a_coef_sync_' num2str(APSK) 'APSK.mat'],'a_coef');


plot_AMAM_AMPM(data_out_power, data_out_power, power_ar, ...
    power_ar, data_out_angle, data_out_angle, 1, 1, 1)

