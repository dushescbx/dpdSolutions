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
pindBm = [19:1:19];
for i = 1:length(pindBm)
    param.PAModel.pindBm = pindBm(i);
%% PA in/out data
[results, param] = PAInOutData(param.dataFileName, ...
    param.MatPAModel, param, 0);
%% plot input spectrum, AM/AM, gain vs inp pow
results.inOutTable = GainVsInPowAndTableGen(...
    results.OutputWaveform,...
    results.InputWaveform, param.PAModel.RefImp, 0);

%% pa memoryless model
[results.OutputWaveformFitMemless, results.pa] ...
    = PAMemlessModel(results.inOutTable, results.InputWaveform, ...
    results.OutputWaveform, results.sampleRate,...
    param.PAModel.RefImp, ...
    0);
%% DPD test
%% dpd test lut
% close all
[OutputWaveformAfterDPDPA, OutputWaveformAfterDPD,...
    inOutTableDPD] = ...
    DPDModelEstLut(param, results, 1);
%%
%% demod
load('dpdLab/meas/modOut.mat');
demodResult(i) = demodSignals(results.InputWaveform,...
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
end