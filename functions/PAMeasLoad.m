function [results, ofs] = PAMeasLoad(dataFileNameIn, dataFileNameOut, param)

load(dataFileNameIn);
load(dataFileNameOut);
results.InputWaveform = reshape(x, [], 1);
results.OutputWaveform = reshape(yCorr, [], 1);

[results.OutputWaveform, results.InputWaveform] ...
    = matchDelayAndLength...
    (results.OutputWaveform, ...
    results.InputWaveform, delay);
results.InputWaveformdBm  = mag2db(abs(results.InputWaveform)) ...
    + 30 - pow2db(param.PAModel.RefImp);
results.OutputWaveformdBm  = mag2db(abs(results.OutputWaveform)) ...
    + 30 - pow2db(param.PAModel.RefImp);
results.sampleRate = 1;
results.overSamplingRate = 1;
results.numFrames = 1;
results.MeasuredAMToAM = (abs(results.OutputWaveform).^2 ...
    ./abs(results.InputWaveform).^2);
results.ReferencePower = abs(results.OutputWaveform).^2;
results.PhaseShift = mod((angle(results.OutputWaveform) -  ...
    angle(results.InputWaveform)), 2*pi)*180/pi;
results.PhaseShift(results.PhaseShift > 180) = ...
    results.PhaseShift(results.PhaseShift > 180) - 360;
results.InPower = abs(results.InputWaveform).^2;
results.testSignal = 'QAM';

%%
figure;
[f, ydb] = spectrumPlot(1, results.OutputWaveform, 1);
% figure; plot(f(1:end-1), abs(diff(ydb)));