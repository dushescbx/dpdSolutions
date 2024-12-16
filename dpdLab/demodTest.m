clear all
close all
%%
if exist('meas','dir')
    p = genpath('meas');
    addpath(p);
end
if exist('qpskSymbolSyncTest','dir')
    p = genpath('qpskSymbolSyncTest');
    addpath(p);
end
%% spectrum plot
load('meas/x.mat');
load('meas/modOut.mat');
% modOut = modOut./max(abs(modOut));
% modOut
load('paramsDemod.mat')
% figure; plot(y);
% figure;
% spectrumPlot(1, x, 1);
%% params
param.M = 2;
%% demod
pindBm = -35 : 5 : -10; %dB
for i = 1 : length(pindBm)
    load(['meas/y_pindBm=' num2str(pindBm(i)) '.mat']);
    % freq
%     figure;
%     spectrumPlot(1, y, 1);
    mX = mean(real(y));
    mY = mean(imag(y));
    y = complex(real(y) - mX, imag(y) - mY);
        mX = mean(real(y));
    mY = mean(imag(y));
%         figure;
%     spectrumPlot(1, y, 1);
%     figure;
%     plot(y, '*');
    
    [f, ydb] = spectrumPlot(1, (y.^(2^param.M)), 0);
    %%
    [M, I] = max(ydb);
    offsetFreqCoarse(i) = f(I)/2^param.M;
    % freq shift
    yFreq =...
        phase_freq_timing_offset(y, -1*offsetFreqCoarse(i), ...
        0, 0);
    %% decimate and filter
    % decimate signal
    [ yFreqDec ] = ...
        decimateSignal( yFreq, ...
        1, 1, paramsDemod.PAModel.interpFactor);
%     figure;
%     spectrumPlot(1, yFreqDec, 1);
    % Rx filter
    param.hfir = paramsDemod.PAModel.rctFilt3.coeffs.Numerator;
    param.Nsym = paramsDemod.PAModel.Nsym;
    param.sampsPerSym = paramsDemod.PAModel.sps;
    [yqDistFilt, param] = rx_rrc_filter(yFreqDec, param);
    %     yqDistFilt = yqDistFilt./max(abs(yqDistFilt));
    %% symbol timing synchronization
    [ rx_symbol, offset_time, rx_samples ] = ...
        symbol_recoveryCorr( yqDistFilt, ...
        1, param.sampsPerSym, 1, modOut, ...
        0, 0);
        %% costasLoop
paramCostasLoop.alpha = 0.132;
paramCostasLoop.beta = 0.00932;
paramCostasLoop.M = 2;
    [~, ... %signal.rx_symbolFreq_phase_corrected
        freqEst(i)] = costasLoop(rx_symbol,...
        paramCostasLoop, paramCostasLoop.M, 0);
    rx_symbolFreqCorr =...
        phase_freq_timing_offset(rx_symbol, -1*freqEst(i), ...
        0, 0); %delpa_phi
    %% shift finder
    [ dOutShiftFinder, xShifted, delay, phase ] = ...
        shiftFinder( rx_symbolFreqCorr, ...
        modOut, 0); delay
    %% phase correction
    dOutfreq_phase_corrected_data =...
        phase_freq_timing_offset(dOutShiftFinder, 0, ...
        -phase, 0);
    %% EVM
    offset = 10;
        [evm_rmsPaDemod(i)] = evm_measNew...
    (dOutfreq_phase_corrected_data(1+offset:end-offset),...
    modOut(1+offset:end-offset));
        %% recover samples timing, frequency and phase
    % frequency
    yFreqCorr =...
        phase_freq_timing_offset(y,  - (offsetFreqCoarse(i) + ...
        (offsetFreqCoarse(i) ~= 0)*(1/paramsDemod.PAModel.interpFactor*paramsDemod.PAModel.sps)*freqEst(i)), ...
        0, 0);
    %% timing
    [ yFreqTimigCorr, ~, ~ ] = ...
        symbol_recoveryCorr( yFreqCorr, ...
        1, 1, 1, yFreqCorr, ...
        1, 1*offset_time*paramsDemod.PAModel.interpFactor*paramsDemod.PAModel.sps);
    %% phase
    yFreqTimingPhaseCorr = yFreqTimigCorr * exp(-1i*phase);
    %%
        [ yqDistFreqTimigPhaseCorrShiftFinder, yqShifted, delay, phase ] = ...
        shiftFinder( yFreqTimingPhaseCorr, ...
        x, 0);
%         figure;
%     spectrumPlot(1, yqDistFreqTimigPhaseCorrShiftFinder, 1);
    %%
    offset = 100;
    [evm_rmsPa(i)] = evm_measNew...
    (yqDistFreqTimigPhaseCorrShiftFinder(1+offset:end-offset),...
    yqShifted(1+offset:end-offset));
yCorr = yqDistFreqTimigPhaseCorrShiftFinder;
save(['meas/yCorr_pindBm=' num2str(pindBm(i)) '.mat'], 'yCorr', 'delay');
    %% timing
out = demod(yCorr, modOut, paramsDemod);
figure;plot(out, '.');
    %%
%     RMSsamp(i) = rms((signal.yqShifted(1 + shiftInitEnd : end - shiftInitEnd)...
%         - signal.yqDistFreqTimigPhaseCorrShiftFinder(1 + shiftInitEnd : end - shiftInitEnd)...
%         )./signal.yqShifted(1 + shiftInitEnd : end - shiftInitEnd))*100;
%    
end