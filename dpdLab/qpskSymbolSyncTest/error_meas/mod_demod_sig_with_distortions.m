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
[param, signal] = data_gen_and_params();
[signal, param] = tx_rrc_filter(param, signal);
signal = spline_interpolation(signal, param);
[signal, param] = iq_modulation(signal, param);
signal = iq_mod_distortions(signal, param);
signal = iq_demod(signal, param);
[signal, param] = rx_rrc_filter(signal, param);
%% частотная и фазовая синхронизация
[signal.freq_phase_corrected_data, angle_shift] = freq_phase_correction(signal.yr_int(1:param.sampsPerSym:end), signal.x);

% signal.freq_phase_corrected_data = nonlinear_phase_correction_NDA(signal.yr_int(1:param.sampsPerSym:end), signal.yr_int_1(1:param.sampsPerSym:end), param.M_NDA);
% signal = meas_distortions(signal, param);
% [signal.x_dist_theory] = iq_dist_theory(signal.x,param);

figure;
plot(signal.freq_phase_corrected_data(16:end), '*');
title('corr data');
% hold on
% plot(2*signal.x_dist_theory, 's');