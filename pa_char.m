%%
clear all
close all
clc
rng(1)
if exist('functions','dir')
    p = genpath('functions');
    addpath(p);
end

%% model params
remoteMeas = 1;
[param] = Params();
%% test signal gen
% [txWaveform, param] = TestSignalGen(param);
%% PA in/out data
[results, param] = PAInOutData(param.dataFileName, ...
    param.MatPAModel, param, 1);
%% remote
if remoteMeas
    x = results.InputWaveform;
    res = 50;
    pindBm = -10; %dBm
    pin = 10.^((pindBm-30)/10); % dBm2Watts
    x = x./max(x)*sqrt(pin*res);
    RMSin = 10*log10(mean(abs(x).^2/res)) + 30;
    save('x.mat', 'x');
end
%% plot input spectrum, AM/AM, gain vs inp pow
saInput = SigSpectrum(results.InputWaveform,...
    results.sampleRate, results.testSignal, ...
    param.PAModel.bw, [], 0, 1);
results.inOutTable = GainVsInPowAndTableGen(...
    results.InputWaveformdBm,...
    results.OutputWaveformdBm, results.OutputWaveform,...
    results.InputWaveform, 1);
% pa memoryless model
[results.OutputWaveformFitMemless, results.pa] ...
    = PAMemlessModel(results.inOutTable, results.InputWaveform, ...
    results.OutputWaveform, results.sampleRate,...
    param.PAModel.RefImp, ...
    1);
% results.OutputWaveformFitMemless = results.OutputWaveform;
%% memory/cross-term memory model
[results.fitCoefMatMem, results.OutputWaveformFitMem, sa] = ...
    PAModelEst(param, results.InputWaveform, ...
    results.OutputWaveform, results.sampleRate, ...
    results.testSignal, 0, [0]);
%% AM/AM, AM/PM plots
fig_en = 1;
if fig_en
    AMAMplot(results.ReferencePower,...
        results.InPower, ...
        results.OutputWaveformFitMemless, ...
        results.OutputWaveformFitMem, ...
        param.PAModel.RefImp);
    AMPMplot(results.PhaseShift,...
        results.InPower, results.InputWaveform, ...
        results.OutputWaveformFitMemless, ...
        results.OutputWaveformFitMem, ...
        param.PAModel.RefImp);
    figure; plot(results.OutputWaveformFitMemless, '.');
    figure; plot(results.OutputWaveformFitMem, '.');
end
%% DPD test
close all
DPDModelEst(param, results.InputWaveform, ...
    results.OutputWaveform, results.fitCoefMatMem);
%% save data to dpd model
SaveDataToDpd(results.InputWaveform, ...
    results.numFrames);
%% grid search to find opt vals
[rmsErrorTime, rmsErrorFreq] =...
    GridSearch(results.InputWaveform, ...
    results.OutputWaveform, param.modType, ...
    param.GridSearch);
%% approx qam by sine wave
if param.swapSignals
    if param.PAModel.signalSel ~= 1
        [paramQAM] = ParamsQAM(param);
        [resultsQAM, paramQAM] = PAInOutData(paramQAM.dataFileName, ...
            paramQAM.MatPAModel, paramQAM, 0);
        rmsErrorTimeMem = MemPolyModel('errorMeasure', ...
            resultsQAM.InputWaveform, resultsQAM.OutputWaveform, ...
            results.fitCoefMatMem, param.modType);
        disp(['Percent RMS error in time domain is '...
            num2str(rmsErrorTimeMem) '%'])
        %% memory/cross-term memory model
        [resultsQAM.fitCoefMatMem, resultsQAM.OutputWaveformFitMem, sa] = ...
            PAModelEst(paramQAM, resultsQAM.InputWaveform, ...
            resultsQAM.OutputWaveform, resultsQAM.sampleRate, ...
            resultsQAM.testSignal, 1,...
            results.fitCoefMatMem);
        % r = [ results.OutputWaveformFitMem; zeros(...
        %     length(resultsQAM.OutputWaveform)-length(results.OutputWaveformFitMem),...
        %     1)];
        % r = resultsQAM.OutputWaveformFitMem(1:...
        %     length(results.OutputWaveform));
        % sa = SigSpectrum(...
        %         [results.OutputWaveformFitMem],...
        %         results.sampleRate, resultsQAM.testSignal, [], ...
        %         {'Actual PA sine Output'}, 1, 1);
        %
    end
end