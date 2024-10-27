close all
clear all

SNR=15;                          % Signal-to-noise ratio
T =  0.1;                          % Symbol period
Tc = T/10;                       % Carrier period
deltaf = (3/360)/T;         % Frequency error
deltaT = 300e-6;             % Timing error
Tr = T*(1+deltaT);           % Receiver clock
alpha = 0.5;                     % Rolloff factor
b3 = [1/6 -1/2  1/2 -1/6];
b2 = [1/2 -1    1/2  0];
b1 = [1/3  1/2 -1    1/6];
b0 = [0    1    0    0];
warning off all


APSK_ar = 32;
f = 1;
i = 1;
ARBitrary_TRIGger_SLENgth = 1e4;
run('constant_for_model.m');
run('download_power_arrays.m');

start_of_data=21;

% for start_of_data=21:1:25

%% ÇÀÃĞÓÆÀÅÌ ñèìâîëû Ñ×ÈÒÀÍÍÛÅ ÈÇ ÀÍÀËÈÇÀÒÎĞÀ IQ
load(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\_' num2str(APSK_ar(f)) 'APSK'  num2str(input_ar.d(i)) 'dbm_DPD_on=False_pa_on=True_iq.mat']);
data_out_ADD=iq_data(start_of_data:4*4e4);
data_out_ADD=data_out_ADD(:);
% scatterplot(data_out_ADD);
% end
%
data_out_ADD=scale_power(data_out_ADD,output_ar.d,i);
load(['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier_usil_mal\_' num2str(APSK_ar(f)) 'APSK_ref_symb_after_filter.mat']);
data_in_ADD = ref_sym(start_of_data:4e4-3);
%% ÌÀÑØÒÀÁÈĞÓÅÌ Â ÑÎÎÒÂÅÒÑÒÂÈÈ Ñ ÂÕÎÄÍÎÉ ÌÎÙÍÎÑÒÜŞ
data_in_ADD = scale_power(data_in_ADD,input_ar.d,i);


%% ÏÎÄÀÅÌ ÍÀ ÂÕÎÄ ÈÄÅÀËÜÍÛÅ ñèìâîëû
load(['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier_usil_mal\' num2str(APSK_ar(f)) 'APSK_ref_symb_timeseries.mat']);
data_in_ADD_symb = ref_sym_symbols.data(1:ARBitrary_TRIGger_SLENgth);
scatterplot(data_in_ADD_symb);
data_in_ADD_symb = scale_power(data_in_ADD_symb(:),input_ar.d,i);







% fs = 25e6;
% freqComp = comm.CoarseFrequencyCompensator(...
%     'Modulation','8PSK', ...
%     'SampleRate',fs, ...
%      'FrequencyResolution',1);
% [compensatedData,estFreqOffset] = freqComp(data_out_ADD(1:10000));
% scatterplot(compensatedData);

simin.data = data_out_ADD;
simin.time = 0:1:length(data_out_ADD) - 1;
simin = timeseries(simin.data,simin.time);
sim('timing_sync_model.slx');

% scatterplot(demod_sym_after_corr(length(demod_sym_after_corr)*9/10:length(demod_sym_after_corr)));
% [rxSym,tError]=symbolSync(demod_sym_after_filt);
% scatterplot(rxSym);
% scatterplot(demod_sym_after_filt);
% % % % % % % % % % % % scatterplot(demod_sym_after_interp(5:4:end));
% figure;
% plot(imag(data_out_ADD));
% figure;
% plot(demod_sym_after_interp_imag);

start_sym = 0;
point_num = 25e3;
% for start_sym=0:1:3
for step_size = 0:0.025:1
    i = 1;
    yy_r = zeros(0,0);
    yy_r_fixed = zeros(0,0);
    yy_i = zeros(0,0);
    yy_i_fixed = zeros(0,0);
    x = 1:point_num;
    x_ar = 1:1:length(demod_sym_after_filt);
    xx_fixed_ar = x_ar + step_size;
    %     xx = 0:1+step_size:4+4*+step_size;
    xx_fixed = x(1:point_num) + step_size;
    %     for ka=1:1:length(demod_sym_after_filt)/point_num%-8
    %         yy_r_fixed(1+(ka-1)*point_num:1:point_num+(ka-1)*point_num) = spline(x,real(demod_sym_after_filt(1+start_sym+(ka-1)*point_num:1:point_num+start_sym+(ka-1)*point_num,1)),xx_fixed);
    %         yy_i_fixed(1+(ka-1)*point_num:1:point_num+(ka-1)*point_num) = spline(x,imag(demod_sym_after_filt(1+start_sym+(ka-1)*point_num:1:point_num+start_sym+(ka-1)*point_num,1)),xx_fixed);
    %     end
    yy_r=spline(x,real(demod_sym_after_filt(1:length(x))),xx_fixed);
    yy_i=spline(x,imag(demod_sym_after_filt(1:length(x))),xx_fixed);
    scatterplot(complex(yy_r(1:4:end),yy_i(1:4:end)));
    title(['fix step size=' num2str(step_size) ' start sym shift=' num2str(start_sym)]);
    
    
    i = i + 1;
end
% end










