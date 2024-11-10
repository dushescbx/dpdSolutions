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
signal = spline_interpolation(signal, param);
%% timing, phase, freq shift
%%
[signal.yqDistFilt, param] = rx_rrc_filter(signal.yq, param);
%%
[ signal.rx_symbol ] = symbol_recovery( signal.yqDistFilt, 1,...
    param.sampsPerSym,...
    param.IF);
%%
figure; plot(real(signal.rx_symbol)-real(signal.x));
hold on;plot(imag(signal.rx_symbol)-imag(signal.x));
rmsVal = rms(signal.rx_symbol - signal.x);