function [results, ofs] = PAMeasLoad(dataFileName)

  load(dataFileName,"results","sampleRate","overSamplingRate","testSignal","numFrames");

results.sampleRate = sampleRate;
results.overSamplingRate = overSamplingRate;
results.testSignal = testSignal;
results.numFrames = numFrames;
ofs = overSamplingRate;
results.InputWaveformdBm  = mag2db(abs(results.InputWaveform)) + 30 - 20;
results.OutputWaveformdBm  = mag2db(abs(results.OutputWaveform)) + 30 - 20;
results.InPower = abs(results.InputWaveform).^2;
results.ReferencePower = abs(results.OutputWaveform).^2;
results.PhaseShift = mod((angle(results.OutputWaveform) -  ...
    angle(results.InputWaveform)), 2*pi)*180/pi;
results.PhaseShift(results.PhaseShift > 180) = ...
    results.PhaseShift(results.PhaseShift > 180) - 360;
% figure; plot(