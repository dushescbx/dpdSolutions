close all
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








% % % % %% ÇÀÃĞÓÆÀÅÌ ñèìâîëû Ñ×ÈÒÀÍÍÛÅ ÈÇ ÀÍÀËÈÇÀÒÎĞÀ RAW
% % % % load(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\_' num2str(APSK_ar(f)) 'APSK'  num2str(input_ar.d(i)) 'dbm_DPD_on=False_pa_on=True_raw.dat.mat'])
% % % % data_out_ADD = simin.data(start_of_data:4e4-3);
% % % % %             scatterplot(simin.data);
% % % % %% ÌÀÑØÒÀÁÈĞÓÅÌ Â ÑÎÎÒÂÅÒÑÒÂÈÈ Ñ ÂÛÕÎÄÍÎÉ ÌÎÙÍÎÑÒÜŞ
% % % % data_out_ADD = scale_power(data_out_ADD(:),output_ar.d,i);
% % % % %
%     x = 1:length(data_out_ADD);
%     y_r = real(data_out_ADD);
%     y_i = imag(data_out_ADD);
%     xx = 1:0.25:length(data_out_ADD);
%     yy_r = spline(x,y_r,xx);
%     yy_i = spline(x,y_i,xx);
%     plot(x,y,'o',xx,yy,'x');
%     scatterplot(complex(yy_r(1:4:end),yy_i(1:4:end)));
% % %
% %
% sps = 4;
% symbolSync = comm.SymbolSynchronizer(...
%     'TimingErrorDetector','Mueller-Muller (decision-directed)', ...
%     'SamplesPerSymbol', sps);
clear simin
simin.data = data_out_ADD;
simin.time = 0:length(simin.data)-1;
simin = timeseries(simin.data,simin.time);

sim('timing_sync_model.slx');




%

% [rxSym,tError]=symbolSync(demod_sym_after_filt);
% scatterplot(rxSym);
% scatterplot(demod_sym_after_filt);
% % % % % % % % % % % % scatterplot(demod_sym_after_interp(5:4:end));
% figure;
% plot(imag(data_out_ADD));
% figure;
% plot(demod_sym_after_interp_imag);

start_sym = 0;
point_num = 4;
% for start_sym=0:1:3
for step_size = -0.3:0.1:0.3
    i = 1;
    yy_r = zeros(0,0);
    yy_r_fixed = zeros(0,0);
    yy_i = zeros(0,0);
    yy_i_fixed = zeros(0,0);
    x = 1:point_num;
    x_ar = 1:1:length(demod_sym_after_filt);
    xx_fixed_ar = x_ar + step_size;
    %     xx = 0:1+step_size:4+4*+step_size;
    xx_fixed = x + step_size;
    for ka=1:1:length(demod_sym_after_filt)/point_num%-8
        yy_r_fixed(1+(ka-1)*point_num:1:point_num+(ka-1)*point_num) = spline(x,real(demod_sym_after_filt(1+start_sym+(ka-1)*point_num:1:point_num+start_sym+(ka-1)*point_num,1)),xx_fixed);
        yy_i_fixed(1+(ka-1)*point_num:1:point_num+(ka-1)*point_num) = spline(x,imag(demod_sym_after_filt(1+start_sym+(ka-1)*point_num:1:point_num+start_sym+(ka-1)*point_num,1)),xx_fixed);
        % % % % % % %
        % % % % % % %             yy_r_fixed(1+(ka-1)*4:1:4+(ka-1)*4) = spline(x_ar(1+start_sym+(ka-1)*4:1:4+start_sym+(ka-1)*4),real(demod_sym_after_filt(1+start_sym+(ka-1)*4:1:4+start_sym+(ka-1)*4,1)),xx_fixed_ar(1+start_sym+(ka-1)*4:1:4+start_sym+(ka-1)*4));
        % % % % % % %             yy_i_fixed(1+(ka-1)*4:1:4+(ka-1)*4) = spline(x_ar(1+start_sym+(ka-1)*4:1:4+start_sym+(ka-1)*4),imag(demod_sym_after_filt(1+start_sym+(ka-1)*4:1:4+start_sym+(ka-1)*4,1)),xx_fixed_ar(1+start_sym+(ka-1)*4:1:4+start_sym+(ka-1)*4));
        % % % % % % %
        % % % % % % %             yy_r(1+(ka-1)*4:1:4+(ka-1)*4) = spline(x,real(demod_sym_after_filt(1+start_sym+(ka-1)*4:1:4+start_sym+(ka-1)*4,1)),xx(2:end));
        % % % % % % %             yy_i(1+(ka-1)*4:1:4+(ka-1)*4) = spline(x,imag(demod_sym_after_filt(1+start_sym+(ka-1)*4:1:4+start_sym+(ka-1)*4,1)),xx(2:end));
        
    end
    scatterplot(complex(yy_r_fixed,yy_i_fixed));
    title(['fix step size=' num2str(step_size) ' start sym shift=' num2str(start_sym)]);
    % scatterplot(complex(yy_r,yy_i));
    % title('var step size');
    % scatterplot(demod_sym_after_filt);
    % title('original');
    % close all
    % EVM(i)=evm_meas(data_in_ADD,complex(yy_r_fixed,yy_i_fixed));
% % % % % % %     figure;
% % % % % % %     plot(xx_fixed_ar(1:length(yy_r_fixed)),yy_r_fixed,'o');
% % % % % % %     hold on;
% % % % % % %     grid on;
% % % % % % %     grid minor;
% % % % % % %     plot(x_ar,real(demod_sym_after_filt),'x');
% % % % % % %     plot(x_ar,real(demod_sym_after_filt));
% % % % % % %     plot(xx_fixed_ar(1:length(yy_r_fixed)),yy_r_fixed);
% % % % % % %     legend('shifted','original','orig line','shift line');
    i = i + 1;
end
% end







% figure;
% plot(abs(xcorr(data_in_ADD_symb,demod_sym_after_filt(1:length(data_in_ADD_symb)))));
% max(abs(xcorr(data_in_ADD_symb,demod_sym_after_filt(1:length(data_in_ADD_symb)))));
% 
% 
% mean(angle(demod_sym_after_filt(1:length(data_in_ADD_symb))))
% 
% figure;
% demod_sym_after_filt_shift=demod_sym_after_filt(1:length(data_in_ADD_symb)).*exp(1i*max(abs(xcorr(data_in_ADD_symb,demod_sym_after_filt(1:length(data_in_ADD_symb))))));
% plot(abs(xcorr(data_in_ADD_symb,demod_sym_after_filt_shift)));
% 
% 
% mean(angle(demod_sym_after_filt_shift))
% 
% scatterplot(data_in_ADD_symb);
% scatterplot(demod_sym_after_filt_shift);
% scatterplot(demod_sym_after_filt);
% 
% figure;
% % plot(real(demod_sym_after_filt(1:4)));
% hold on;
% 
% % plot(abs(xcorr(data_in_ADD,data_out_ADD)));
% plot(abs(xcorr(data_in_ADD_symb,demod_sym_after_filt(1:length(data_in_ADD_symb)))));
% plot(abs(xcorr(data_in_ADD_symb,demod_sym_after_filt(1:length(data_in_ADD_symb)))));







