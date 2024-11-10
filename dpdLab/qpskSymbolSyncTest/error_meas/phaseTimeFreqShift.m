clear all
close all
%% add model parameters functions to path
if exist('additional_scripts','dir')
    p = genpath('additional_scripts');
    addpath(p);
end
if exist('sync_rab','dir')
    p = genpath('sync_rab');
    addpath(p);
end
%%
[param, signal] = data_gen_and_params();
%% spectrumPlot(Fs, x)
[signal, param] = tx_rrc_filter(param, signal);
%%
signal = spline_interpolation(signal, param);
%% timing, phase, freq shift
signal.yqDist = phase_freq_timing_offset(signal.yq, param.delta_f, ...
    param.delpa_phi, param.delayVec);
%%
[signal.yqDistFilt, param] = rx_rrc_filter(signal.yqDist, param);
%% частотная и фазовая синхронизация
[signal.freq_phase_corrected_data, angle_shift, ...
    delta_f_est_with_fft, delta_f_est] =...
    freq_phase_correction(signal.yqDistFilt, signal.x);
%%
[ signal.rx_symbol ] = symbol_recovery( signal.freq_phase_corrected_data, 1,...
    param.sampsPerSym,...
    param.IF);
% figure; plot(real(signal.rx_symbol)); hold on; plot(real(signal.yqDistFilt));
figure; plot(real(signal.rx_symbol)); hold on; plot(real(signal.x));
% compare(signal.rx_symbol, signal.x, '', ['' '']);