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
figure;spectrumPlot(1, signal.x);
signal.yqDist = phase_freq_timing_offset(signal.x, param.delta_f, ...
    param.delpa_phi, param.delayVec);
figure; plot(real(signal.yqDist)); hold on; plot(imag(signal.yqDist));
figure; spectrumPlot(1, signal.yqDist);
