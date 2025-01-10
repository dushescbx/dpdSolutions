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
%% memory/cross-term memory model
[results.fitCoefMatMem, results.OutputWaveformFitMem, sa] = ...
    PAModelEst(param, results.InputWaveform, ...
    results.OutputWaveform, results.sampleRate, ...
    results.testSignal, 0, [0]);

%% DPD test
% close all
[OutputWaveformAfterDPDPA, OutputWaveformAfterDPD] = ...
    DPDModelEst(param, results.InputWaveform, ...
    results.OutputWaveform, results.fitCoefMatMem, 1);
%
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
    results.PhaseShiftModel] =...
    AMAM_AMPM_gen(results.InputWaveform, ...
    OutputWaveformAfterDPD, param.PAModel.RefImp);

%%
if 1
    close all
    figure;
    % plot(results.InputWaveformdBmDPDPA,...
    % results.OutputWaveformdBmDPDPA, 'x')
    plot(results.InputWaveformdBmModel,...
    results.OutputWaveformdBmModel, 'x')
    
    grid on
    hold on;
    plot(results.InputWaveformdBm, results.OutputWaveformdBm, '.');
    xlabel('Input Power (dBm)')
    ylabel('Output Power (dBm)')
    title('Output vs Input Power LUT')
    figure;
    % plot(results.InputWaveformdBmDPDPA, results.PhaseShiftDPDPA, 'x')
    plot(results.InputWaveformdBmModel, results.PhaseShiftModel, 'x')
    
    grid on
    hold on;
    plot(results.InputWaveformdBm, results.PhaseShift, '.')
    xlabel('Input Power (dBm)')
    ylabel('Output phase (deg)')
    title('Output phase vs Input Power LUT')
end
%%
% %% demod
% load('dpdLab/meas/modOut.mat');
% demodResult = demodSignals(results.InputWaveform,...
%     results.OutputWaveform, OutputWaveformAfterDPDPA,...
%     modOut, param, OutputWaveformAfterDPD);
% %%
% figure;
% spectrumPlot(1, results.OutputWaveform, 1);
% hold on
% spectrumPlot(1, OutputWaveformAfterDPDPA, 1);
% % spectrumPlot(1, results.OutputWaveform, 1);
% legend('no dpd', 'dpd')
% % legend('dpd', 'no dpd')