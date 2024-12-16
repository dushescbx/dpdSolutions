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

%%
% figure;
% [~, ~] = spectrumPlot(1, signal.x, 1);
signal.yq = spline_interpolation(signal.x, param.IF);
% figure;
% [~, ~] = spectrumPlot(1, signal.yq, 1);
% figure;
% spectrumPlot(1, signal.yq); hold on;
RMS = zeros(1, param.test.iterN);
delta_f = zeros(1, param.test.iterN);
delpa_phi = zeros(1, param.test.iterN);
delayVec = zeros(1, param.test.iterN);
offset_timeAR = zeros(1, param.test.iterN);
RMS = zeros(1, param.test.iterN);
for i = 1 : param.test.iterN

    delta_f(i) = param.test.delta_f(i);
%     delta_f(i) = param.test.delta_f(param.test.k1(i));
    delpa_phi(i) = param.test.delpa_phi(param.test.k2(i));
    delayVec(i) = param.test.delayVec(param.test.k3(i));
%     delayVec(i) = param.test.delayVec(i);
%     delayVec(i) = 0.2;
%% freq shift, phase, timing
    signal.xDist = timing_phase_freq_offset(signal.yq, delta_f(i), ...
        delpa_phi(i), delayVec(i));
        %% частотная синхронизация
[f, ydb] = spectrumPlot(1, (signal.xDist.^(2^param.M)), 0);
[M, I] = max(ydb);
offsetFreqCoarse(i) = f(I)/2^param.M;
    %% freq shift
        signal.xDistFreqCorr =... %%%%%%%%%% *0 -0*offsetFreqCoarse(i)
            phase_freq_timing_offset(signal.xDist, -1*offsetFreqCoarse(i), ...
            0, 0);
    %% symbol timing sync
    [ signal.rx_symbol, offset_time ] = ...
        symbol_recoveryCorr( signal.xDistFreqCorr, ...
        1, 1, param.IF, signal.x, ...
        0, -delayVec(i));
        offset_timeAR(i) = offset_time;
%% 
    %% shift finder
    [ signal.dOutShiftFinder, signal.xShifted, delay, phase ] = ...
        shiftFinder( signal.rx_symbol, ...
        signal.x, 0);
% signal.dOutShiftFinder = signal.rx_symbol;
% signal.xShifted = signal.x(1:length(signal.dOutShiftFinder));
%     delay
    %% частотная и фазовая синхронизация
    [angle_shift(i), ...
        delta_f_est_with_fftTest(i), ...
        delta_f_estTest(i)] =...
        freq_phase_correction(signal.dOutShiftFinder, signal.xShifted);
    signal.freq_phase_corrected_dataTest =...
        phase_freq_timing_offset(signal.dOutShiftFinder, -1*delta_f_estTest(i), ...
        -angle_shift(i), 0);

    %%
    figure; plot(real(signal.freq_phase_corrected_dataTest)); hold on;
    plot(real(signal.xShifted));
    RMS(i) = rms(signal.freq_phase_corrected_dataTest - signal.xShifted);

end
%% RMS
figure; plot(RMS);
%% angle
figure; plot(delpa_phi); hold on;
plot(angle_shift);
legend('ref', 'symb')
%% freq
figure; plot(delta_f); hold on;
% plot(delta_f_est_with_fft); plot(delta_f_est);
plot(delta_f_est_with_fftTest); plot(delta_f_estTest);
legend('ref', 'samplesFFT', 'samples'); %, 'symbFFT', 'symb'
%% timing
figure; plot(delayVec); hold on;
% plot(delta_f_est_with_fft); plot(delta_f_est);
plot(-offset_timeAR);