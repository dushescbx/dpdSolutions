 function [txWaveform, SR] = InterpolateSig(txWaveform, overSamplingRate, filterLength, SR)

lowpassfilter = firpm(filterLength, [0 8/70 10/70 1], [1 1 0 0]);
firInterp = dsp.FIRInterpolator(overSamplingRate, lowpassfilter);
txWaveform = firInterp([txWaveform; zeros(filterLength/overSamplingRate/2,1)]);
txWaveform = txWaveform((filterLength/2)+1:end,1);      % Remove transients
txWaveform = txWaveform/max(abs(txWaveform));   % Normalize the waveform
SR = SR * overSamplingRate;
