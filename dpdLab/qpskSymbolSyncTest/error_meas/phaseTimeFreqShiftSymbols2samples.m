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

%% spectrumPlot(Fs, x)
[signal.yc, param] = tx_rrc_filter(param, signal.x);
%%
signal.yq = spline_interpolation(signal.yc, param.IF);
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
freqEst = zeros(1, param.test.iterN);
RMSsamp = zeros(1, param.test.iterN);
shiftInitEnd = 10;
for i = 1 : param.test.iterN
    
    delta_f(i) = param.test.delta_f(i);
    %     delta_f(i) = param.test.delta_f(param.test.k1(i));
    delpa_phi(i) = param.test.delpa_phi(param.test.k2(i));
    delayVec(i) = param.test.delayVec(param.test.k3(i));
    % delayVec(i) = param.test.delayVec(i);
    %         delayVec(i) = 0.5;
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
    [~, ... %signal.rx_symbolFreq_phase_corrected
        freqEst(i)] = costasLoop(signal.rx_symbol,...
        param.costasLoop, param.M, 0);
    signal.rx_symbolFreq_phase_corrected =...
        phase_freq_timing_offset(signal.rx_symbol, -1*freqEst(i), ...
        0, 0); %delpa_phi
%     figure;
%     plot(real(signal.rx_symbolFreq_phase_corrected))
%     hold on;
%     plot(real(signal.rx_symbol))
    %% shift finder
    [ signal.dOutShiftFinder, signal.xShifted, delay, phase ] = ...
        shiftFinder( signal.rx_symbolFreq_phase_corrected, ...
        signal.x, 0);
    delay
    signal.dOutShiftFinder = signal.dOutShiftFinder * exp(-1i*phase);
    %%
%     figure; plot(real(signal.dOutShiftFinder)); hold on;
%     plot(real(signal.xShifted));
    %      plot(real(signal.dOutShiftFinder));
    RMS(i) = rms((signal.xShifted(1 + shiftInitEnd : end - shiftInitEnd)...
        - signal.dOutShiftFinder(1 + shiftInitEnd : end - shiftInitEnd)...
        )./signal.xShifted(1 + shiftInitEnd : end - shiftInitEnd))*100;
    % plot(real(signal.x));
    % RMS(i) = rms(signal.freq_phase_corrected_dataTest - signal.x);
    
    %% recover samples timing, frequency and phase
    % frequency
    signal.yqDistFreqCorr =...
        phase_freq_timing_offset(signal.yqDist,  - (offsetFreqCoarse(i) + 1/(param.IF*param.sampsPerSym)*freqEst(i)), ...
        0, 0);
    %% timing
    [ signal.yqDistFreqTimigCorr, ~, ~ ] = ...
        symbol_recoveryCorr( signal.yqDistFreqCorr, ...
        1, 1, 1, signal.yqDistFreqCorr, ...
        1, offset_time*param.IF*param.sampsPerSym);
    %% phase
    signal.yqDistFreqTimigPhaseCorr = signal.yqDistFreqTimigCorr * exp(-1i*phase);
    %%
        [ signal.yqDistFreqTimigPhaseCorrShiftFinder, signal.yqShifted, delay, phase ] = ...
        shiftFinder( signal.yqDistFreqTimigPhaseCorr, ...
        signal.yq, 0);
    %%
    RMSsamp(i) = rms((signal.yqShifted(1 + shiftInitEnd : end - shiftInitEnd)...
        - signal.yqDistFreqTimigPhaseCorrShiftFinder(1 + shiftInitEnd : end - shiftInitEnd)...
        )./signal.yqShifted(1 + shiftInitEnd : end - shiftInitEnd))*100;
    
    figure;
    plot(real(signal.yqDistFreqTimigPhaseCorrShiftFinder));
    hold on;
    plot(real(signal.yqShifted));
end
%% RMS
figure; plot(RMS);
%%
figure; plot(RMSsamp);
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
figure; plot((delta_f - (offsetFreqCoarse + freqEst))./delta_f*100); hold on;
%%
figure; plot(delta_f); hold on; plot(offsetFreqCoarse + freqEst);...
    plot(offsetFreqCoarse); legend('ref', 'sum', 'coarse');
%% timing
figure; plot(delayVec); hold on;
% plot(delta_f_est_with_fft); plot(delta_f_est);
plot(-offset_timeAR*param.sampsPerSym*param.IF);
title('timing');

