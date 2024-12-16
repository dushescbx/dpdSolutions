clear all
close all
rng(0);
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
%% signal shift
param.test.delayVal = 3;
signal.xDelayed = signal.x(1+param.test.delayVal:end);
%% spectrumPlot(Fs, x)
[signal.yc, param] = tx_rrc_filter(param, signal.xDelayed);
[signal.ycNoDelay, param] = tx_rrc_filter(param, signal.x);
param.test.delayVal = 25;
signal.ycDelayed = signal.yc(1+param.test.delayVal:end);
%%
signal.yq = spline_interpolation(signal.ycDelayed, param.IF);
signal.yqNoDelay = spline_interpolation(signal.ycNoDelay, param.IF);
%%
% figure;
% spectrumPlot(1, signal.yq); hold on;
RMS = zeros(1, param.test.iterN);
delta_f = zeros(1, param.test.iterN);
delpa_phi = zeros(1, param.test.iterN);
delayVec = zeros(1, param.test.iterN);
offset_timeAR = zeros(1, param.test.iterN);
offsetFreqCoarse = zeros(1, param.test.iterN);
freq_shiftTestSymbFFT = zeros(1, param.test.iterN);
freq_shiftTestSymb = zeros(1, param.test.iterN);
freq_shiftFFT = zeros(1, param.test.iterN);
freq_shift = zeros(1, param.test.iterN);

shiftInitEnd = 10;
for i = 1 : param.test.iterN
    
        delta_f(i) = param.test.delta_f(i);
%     delta_f(i) = param.test.delta_f(param.test.k1(i));
    delpa_phi(i) = param.test.delpa_phi(param.test.k2(i));
    delayVec(i) = param.test.delayVec(param.test.k3(i));
    % delayVec(i) = param.test.delayVec(i);
    %     delayVec(i) = 0.2;
    %% timing, phase, freq shift

    signal.yqDist =...
        timing_phase_freq_offset(signal.yq, delta_f(i), ...
        delpa_phi(i), delayVec(i));

    %% частотная синхронизация
% figure; plot(real(signal.yqDist), '-*');
% figure; spectrumPlot(1, signal.yqDist);
% figure; plot(signal.yqDist.^2, '*');
% figure; spectrumPlot(1, signal.yqDist.^2);
% figure; plot((signal.yqDist.^2).^2, '*'); figure; 
[f, ydb] = spectrumPlot(1, (signal.yqDist.^(2^param.M)), 0);
%%
[M, I] = max(ydb);
offsetFreqCoarse(i) = f(I)/2^param.M;
% offsetFreqCoarse(i) = offsetFreqCoarse(i)*0.99;
    %% freq shift
        signal.yqDistFreq =...
            phase_freq_timing_offset(signal.yqDist, -1*offsetFreqCoarse(i), ...
            0, 0);
%         figure; plot(real(signal.yqDistFreq), '-*');
 %% decimate signal
    [ signal.yqDistFreqDec] = ...
        decimateSignal( signal.yqDistFreq, ...
        1, 1, param.IF);
    %% Rx filter
    [signal.yqDistFilt, param] = rx_rrc_filter(signal.yqDistFreqDec, param);
    %% symbol timing sync
    [ signal.rx_symbol, offset_time, signal.rx_samples ] = ...
        symbol_recoveryCorr( signal.yqDistFilt, ...
        1, param.sampsPerSym, 1, signal.x, ...
        0, 0);
    offset_timeAR(i) = offset_time;
    %% частотная и фазовая синхронизация
%     [angle_shiftTestSymb(i), ...
%         freq_shiftTestSymbFFT(i), freq_shiftTestSymb(i)] =...
%         freq_phase_correction(signal.dOutShiftFinder, signal.xShifted);
%     [angle_shift(i), ...
%         freq_shiftFFT(i), freq_shift(i)] =...
%         freq_phase_correction(signal.rx_samplesShiftFinder, signal.ycShifted);
% %     figure; spectrumPlot(1, (signal.ycShifted).^4);
%     signal.freq_phase_corrected_dataTest =...
%         phase_freq_timing_offset(signal.dOutShiftFinder, 0, ...
%         -angle_shift(i), -freq_shift(i)); %delpa_phi
    [signal.rx_symbolFreq_phase_corrected, ...
    freqEst] = costasLoop(signal.rx_symbol,...
    param.costasLoop, param.M, 0);
    %% shift finder
     [ signal.dOutShiftFinder, signal.xShifted, delay, phase ] = ...
        shiftFinder( signal.rx_symbolFreq_phase_corrected, ...
        signal.x, 0);
    delay
    signal.dOutShiftFinder = signal.dOutShiftFinder * exp(-1i*phase);
    %%
    figure; plot(real(signal.dOutShiftFinder)); hold on;
    plot(real(signal.xShifted));
%      plot(real(signal.dOutShiftFinder));
    RMS(i) = rms((signal.xShifted(1 + shiftInitEnd : end - shiftInitEnd)...
        - signal.dOutShiftFinder(1 + shiftInitEnd : end - shiftInitEnd)...
        )./signal.xShifted(1 + shiftInitEnd : end - shiftInitEnd))*100;
    % plot(real(signal.x));
    % RMS(i) = rms(signal.freq_phase_corrected_dataTest - signal.x);
end
%% RMS
figure; plot(RMS);
%% angle
% figure; plot(delpa_phi); hold on;
% plot(angle_shift);% plot(angle_shiftTest);
% plot(angle_shiftTestSymb);
% legend('ref', 'samplesInterpolated', 'samples', 'symb');
% title('angle');
%% freq
figure; plot(delta_f); hold on;
plot(offsetFreqCoarse);
% plot(delta_f_est_with_fft); plot(delta_f_est);
% plot(delta_f_est_with_fftTest); plot(delta_f_estTest);
% legend('ref', 'samplesFFT', 'samples'); %, 'symbFFT', 'symb'
legend('ref', 'coarse'); 
title('freq');
%%
figure; plot((delta_f - offsetFreqCoarse)./delta_f*100); hold on;
%% timing
figure; plot(delayVec); hold on;
% plot(delta_f_est_with_fft); plot(delta_f_est);
plot(-offset_timeAR*param.sampsPerSym*param.IF);
title('timing');