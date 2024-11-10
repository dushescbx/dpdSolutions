function d_out =...
    phase_freq_timing_offset(d_in,...
    delta_f,delpa_phi,delayVec)
%%
t = 0 : length(d_in) - 1;
t = reshape(t, [], 1);
d_in = reshape(d_in, [], 1);
%% сдвиг частоты и фазы
ind = (1:1:length(d_in)).';
exp_freq_shift=exp(2*pi*1i*delta_f*ind + 1i*delpa_phi);
% exp_freq_shift=exp(2*pi*1i*delta_f*ind/length(ind) + 1i*delpa_phi);
phase_freq_offset_sig_out = d_in.*exp_freq_shift;
%% формируем временную задержку
d_out = spline(t, phase_freq_offset_sig_out, t + delayVec);
% d_out = (fract_del(phase_freq_offset_sig_out, ));
end