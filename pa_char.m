%%
clear all
close all
clc
rng(1)
if exist('functions','dir')
    p = genpath('functions');
    addpath(p);
end
if exist('dpdLab','dir')
    p = genpath('dpdLab');
    addpath(p);
end

%% model params
[param] = Params();
%% test signal gen
% [txWaveform, param] = TestSignalGen(param);
%% PA in/out data
[results, param] = PAInOutData(param.dataFileName, ...
    param.MatPAModel, param, 1);

%% PA model LUT (no memory)
results.inOutTable = GainVsInPowAndTableGen(...
    results.OutputWaveform,...
    results.InputWaveform, param.PAModel.RefImp, 0);

%% pa memoryless model
[results.OutputWaveformFitMemless, results.pa] ...
    = PAMemlessModel(results.inOutTable, results.InputWaveform, ...
    results.OutputWaveform, results.sampleRate,...
    param.PAModel.RefImp, ...
    0);
%% dpd test lut
% close all
[OutputWaveformAfterDPDPALut,...
 OutputWaveformAfterDPDLut,...
    inOutTableDPD] = ...
    DPDModelEstLut(param, results, 1);	
% results.OutputWaveformFitMemless = results.OutputWaveform;
%% memory/cross-term memory model
[results.fitCoefMatMem, results.OutputWaveformFitMem, sa] = ...
    PAModelEst(param, results.InputWaveform, ...
    results.OutputWaveform, results.sampleRate, ...
    results.testSignal, 0, [0]);
	
%% DPD test
%% DPD test
close all
[OutputWaveformAfterDPDPA, OutputWaveformAfterDPD] = ...
    DPDModelEst(param, results.InputWaveform, ...
    results.OutputWaveform, results.fitCoefMatMem, 1);
%%
[results.InputWaveformdBmDPDPA,...
    results.OutputWaveformdBmDPDPA, ...
    results.PhaseShiftDPDPA] =...
    AMAM_AMPM_gen(results.InputWaveform, ...
    OutputWaveformAfterDPDPA, param.PAModel.RefImp);
[results.InputWaveformdBm,...
    results.OutputWaveformdBm, ...
    results.PhaseShift] =...
    AMAM_AMPM_gen(results.InputWaveform, ...
    results.OutputWaveform, param.PAModel.RefImp);
[results.InputWaveformdBmModel,...
    results.OutputWaveformdBmModel, ...
    results.PhaseShiftModel] =...
    AMAM_AMPM_gen(results.InputWaveform, ...
    results.OutputWaveformFitMem, param.PAModel.RefImp);
[results.InputWaveformdBmDPD,...
    results.OutputWaveformdBmDPD, ...
    results.PhaseShiftDPD] =...
    AMAM_AMPM_gen(results.InputWaveform, ...
    OutputWaveformAfterDPD, param.PAModel.RefImp);

%%
if 1
    close all
    figure;
    plot(results.InputWaveformdBmDPDPA,...
    results.OutputWaveformdBmDPDPA, 'x')
    % plot(results.InputWaveformdBmModel,...
    % results.OutputWaveformdBmModel, 'x')
    %   plot(results.InputWaveformdBmDPD,...
    % results.OutputWaveformdBmDPD, 'x')  
    grid on
    hold on;
    plot(results.InputWaveformdBm, results.OutputWaveformdBm, '.');
    xlabel('Input Power (dBm)')
    ylabel('Output Power (dBm)')
    title('Output vs Input Power LUT')
    figure;
    plot(results.InputWaveformdBmDPDPA, results.PhaseShiftDPDPA, 'x')
    % plot(results.InputWaveformdBmModel, results.PhaseShiftModel, 'x')
        % plot(results.InputWaveformdBmDPD, results.PhaseShiftDPD, 'x');
    grid on
    hold on;
    plot(results.InputWaveformdBm, results.PhaseShift, '.')
    xlabel('Input Power (dBm)')
    ylabel('Output phase (deg)')
    title('Output phase vs Input Power LUT')
end
%%
%% demod
load('dpdLab/meas/modOut.mat');
demodResult = demodSignals(results.InputWaveform,...
    results.OutputWaveform, OutputWaveformAfterDPDPA,...
    modOut, param, OutputWaveformAfterDPD);
%%
figure;
spectrumPlot(1, results.OutputWaveform, 1);
hold on
spectrumPlot(1, OutputWaveformAfterDPDPA, 1);
% spectrumPlot(1, results.OutputWaveform, 1);
legend('no dpd', 'dpd')
% legend('dpd', 'no dpd')

demodResultLut = demodSignals(results.InputWaveform,...
    results.OutputWaveform, OutputWaveformAfterDPDPALut,...
    modOut, param, OutputWaveformAfterDPDLut);
%%
figure;
spectrumPlot(1, results.OutputWaveform, 1);
hold on
spectrumPlot(1, OutputWaveformAfterDPDPALut, 1);








% legend('dpd', 'no dpd')
%% save data to dpd model
% SaveDataToDpd(results.InputWaveform, ...
%     results.numFrames);
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