%% distortions of IQ modulation
function signal = iq_mod_distortions(signal, param)
if param.distortions_on
    signal.IQ_mod_signal_dist = signal.IQ_mod_signal + 0.01*(signal.IQ_mod_signal.^3);
end
%% формируем временную задержку
% varDelay = dsp.VariableFractionalDelay;
% phase_freq_timing_offset_sig_out = varDelay(phase_freq_offset_sig_out,delayVec);
