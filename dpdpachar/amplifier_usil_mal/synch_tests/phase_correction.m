close all
%% œŒƒ¿≈Ã Õ¿ ¬’Œƒ »ƒ≈¿À‹Õ€≈ ÒËÏ‚ÓÎ˚
f = 1;
load(['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier_usil_mal\' num2str(APSK_ar(f)) 'APSK_ref_symb_timeseries.mat']);
data_in_ADD_symb = ref_sym_symbols.data(1:ARBitrary_TRIGger_SLENgth);
                scatterplot(data_in_ADD_symb);
data_in_ADD_symb = scale_power(data_in_ADD_symb(:),input_ar.d,i);

angle = 59;
angle_rad = pi/180*angle;
demod_sym_after_filt_shift=data_in_ADD_symb(1:length(data_in_ADD_symb))...
    .*exp(1i*angle);
scatterplot(demod_sym_after_filt_shift);

% demod_sym_after_filt_shift=demod_sym_after_filt_shift(1:length(data_in_ADD_symb))...
%     .*exp(1i*pi/6);

% figure;
% plot(abs(xcorr(demod_sym_after_filt(1:length(data_in_ADD_symb)),data_in_ADD_symb)));
max_corr=180 - max(abs(xcorr(demod_sym_after_filt(1:length(data_in_ADD_symb)),data_in_ADD_symb)));
max_corr_rad=pi/180*max_corr;
% ar=abs(xcorr(data_in_ADD_symb,demod_sym_after_filt(1:length(data_in_ADD_symb))));



% 
% 
% mean(angle(demod_sym_after_filt(1:length(data_in_ADD_symb))))
% 
% figure;
demod_sym_after_filt_shift=demod_sym_after_filt_shift(1:length(data_in_ADD_symb)).*exp(1i*(-1)*max_corr_rad);
% plot(abs(xcorr(data_in_ADD_symb,demod_sym_after_filt_shift)));
% 
% 
% mean(angle(demod_sym_after_filt_shift))
% 
% scatterplot(data_in_ADD_symb);
scatterplot(demod_sym_after_filt_shift);
% scatterplot(demod_sym_after_filt);
% 
% figure;
% % plot(real(demod_sym_after_filt(1:4)));
% hold on;
% 
% % plot(abs(xcorr(data_in_ADD,data_out_ADD)));
% plot(abs(xcorr(data_in_ADD_symb,demod_sym_after_filt(1:length(data_in_ADD_symb)))));
% plot(abs(xcorr(data_in_ADD_symb,demod_sym_after_filt(1:length(data_in_ADD_symb)))));


