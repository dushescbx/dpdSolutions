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
% figure;
% spectrumPlot(1, signal.yq); hold on;
RMS = zeros(1, param.test.iterN);
delta_f = zeros(1, param.test.iterN);
delpa_phi = zeros(1, param.test.iterN);
delayVec = zeros(1, param.test.iterN);
offset_timeAR = zeros(1, param.test.iterN);
RMS = zeros(1, param.test.iterN);
for i = 1 : param.test.iterN

    % delta_f(i) = param.test.delta_f(i);
    delta_f(i) = param.test.delta_f(param.test.k1(i));
    delpa_phi(i) = param.test.delpa_phi(param.test.k2(i));
    delayVec(i) = param.test.delayVec(param.test.k3(i));
    % delayVec(i) = param.test.delayVec(i);
    % delayVec(i) = 0.2;
    %% timing, phase, freq shift
    signal.yqDist = phase_freq_timing_offset(signal.yq, delta_f(i), ...
        delpa_phi(i), delayVec(i));
        %% частотная синхронизация
    [angle_shiftTest(i), ...
        delta_f_est_with_fftTest(i), delta_f_estTest(i)] =...
        freq_phase_correction(signal.yqDist, signal.yq);
    %% freq shift
    signal.yqDistFreq =...
        phase_freq_timing_offset(signal.yqDist, -0*delta_f(i), ...
        0, 0);
    %% Rx filter
    [signal.yqDistFilt, param] = rx_rrc_filter(signal.yqDistFreq, param);
    % spectrumPlot(1, signal.yqDistFilt)
    %% symbol timing sync
    [ signal.rx_symbol, offset_time ] = ...
        symbol_recoveryCorr( signal.yqDistFilt, ...
        1, param.sampsPerSym, 1, signal.x, ...
        1, -delayVec(i)/param.sampsPerSym/param.IF);
        offset_timeAR(i) = offset_time;
%% 


    %% shift finder
    [ signal.dOutShiftFinder, signal.xShifted, delay ] = ...
        shiftFinder( signal.rx_symbol, ...
        signal.x);
    delay
    %% частотная и фазовая синхронизация
    [angle_shift(i), ...
        ~, ~] =...
        freq_phase_correction(signal.dOutShiftFinder, signal.xShifted);

    signal.freq_phase_corrected_dataTest =...
        phase_freq_timing_offset(signal.dOutShiftFinder, 0, ...
        -delpa_phi(i), 0);
    %%
    figure; plot(real(signal.freq_phase_corrected_dataTest)); hold on;
    plot(real(signal.xShifted));
    RMS(i) = rms(signal.freq_phase_corrected_dataTest - signal.xShifted);
    % plot(real(signal.x));
    % RMS(i) = rms(signal.freq_phase_corrected_dataTest - signal.x);
end
%% RMS
figure; plot(RMS);
%% angle
figure; plot(delpa_phi); hold on;
plot(angle_shift); plot(angle_shiftTest);
legend('ref', 'symb', 'samples')
%% freq
figure; plot(delta_f); hold on;
% plot(delta_f_est_with_fft); plot(delta_f_est);
plot(delta_f_est_with_fftTest); plot(delta_f_estTest);
legend('ref', 'samplesFFT', 'samples'); %, 'symbFFT', 'symb'
%% timing
figure; plot(delayVec); hold on;
% plot(delta_f_est_with_fft); plot(delta_f_est);
plot(-offset_timeAR*param.sampsPerSym*param.IF);