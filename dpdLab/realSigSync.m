clear all
close all
clc
load('x.mat');
load('y.mat');

x = x./max(x);
y = y./max(y);
% figure; plot(x);
% hold on; plot(y);
ref_data = x;
Fs = 1;
% figure; spectrumPlot(Fs, x);
% %%
% hold on; spectrumPlot(Fs, y);
%%
for delta_phi = 0 : pi/4 : 2*pi
    d_out = phase_freq_timing_offset(y, 0, ...
        delta_phi, 0);
    % [freq_phase_corrected_data, est_freq, est_phase] =...
    %     freq_phase_correction(y, ref_data, 1);
    % [d_out, timeOffset] = timingSynchronize(freq_phase_corrected_data,...
    %     x, 1);
    % d_out = freq_phase_corrected_data;
    %%
    % figure; plot(real(x));hold on;
    % plot(real(d_out));
    figure; plot(x); hold on; plot(d_out);
    % plot(imag(x) - imag(d_out));
end