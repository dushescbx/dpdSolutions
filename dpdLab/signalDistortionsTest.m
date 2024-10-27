clear all
close all
clc
load('x.mat');
% load('y.mat');

x = x./max(x);
figure; plot(x);
ref_data = x;
Fs = 1;
% figure; spectrumPlot(Fs, x);
%%
delta_f = 0; %0.01*length(x); %0.1*length(x);% ; %; %0.1*length(x)
delpa_phi = pi/16; %pi/8; %;
delayVec = [0];
figure_on = 1;
%%
phase_freq_offset_sig_out = phase_freq_timing_offset(x, delta_f, ...
    delpa_phi, delayVec);
% hold on; spectrumPlot(Fs, phase_freq_offset_sig_out);
hold on; plot(phase_freq_offset_sig_out);
%%
% dec_factor = 1;
% rx_filter_out = rx_filter(phase_freq_offset_sig_out, dec_factor);
rx_filter_out = phase_freq_offset_sig_out;
%%
%% íàõîäèì ôàçîâûé è ÷àñòîòíûé ñäâèã
% % % [freq_phase_corrected_data, est_freq, est_phase] =...
% % %     freq_phase_correction(rx_filter_out, ref_data, figure_on);
% % %  errorFreq = delta_f - est_freq
% % %  errorPhase = delpa_phi - est_phase
%%
[d_out, timeOffset] = timingSynchronize(rx_filter_out,...
    x, 1);
% d_out = freq_phase_corrected_data;
%% 
figure; plot(real(x) - real(d_out)); hold on
plot(imag(x) - imag(d_out));
