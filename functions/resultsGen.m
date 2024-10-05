function [results, param] = resultsGen(param, ...
    modOut_interp, noisyLinOut)

results.InputWaveform = modOut_interp;
results.OutputWaveform = noisyLinOut;
results.InputWaveformdBm  = mag2db(abs(results.InputWaveform)) ...
    + 30 - pow2db(param.PAModel.RefImp);
results.OutputWaveformdBm  = mag2db(abs(results.OutputWaveform)) ...
    + 30 - pow2db(param.PAModel.RefImp);
results.sampleRate = 1;
results.overSamplingRate = 1;
results.numFrames = 1;
if param.PAModel.signalSel == 1
    results.testSignal = 'QAM';
else
    results.testSignal = 'Tones';
end
param.PAModel.bw = results.overSamplingRate;
results.MeasuredAMToAM = (abs(results.OutputWaveform).^2 ...
./abs(results.InputWaveform).^2);
results.ReferencePower = abs(results.OutputWaveform).^2;
results.PhaseShift = mod((angle(results.OutputWaveform) -  ...
    angle(results.InputWaveform)), 2*pi)*180/pi;
results.PhaseShift(results.PhaseShift > 180) = ...
    results.PhaseShift(results.PhaseShift > 180) - 360;
results.InPower = abs(results.InputWaveform).^2;