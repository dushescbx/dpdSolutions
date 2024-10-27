function phase_freq_timing_offset_sig_out = phase_freq_timing_offset(phase_freq_timing_offset_sig_in,delta_f,delpa_phi,delayVec)
%% сдвиг частоты и фазы
ind = 1:1:length(phase_freq_timing_offset_sig_in);
exp_freq_shift=exp(-2*pi*1i*delta_f*ind/length(ind) + 1i*delpa_phi)';
phase_freq_offset_sig_out = phase_freq_timing_offset_sig_in.*exp_freq_shift;
%% формируем временную задержку
varDelay = dsp.VariableFractionalDelay;
phase_freq_timing_offset_sig_out = varDelay(phase_freq_offset_sig_out,delayVec);
end