function rmsError = helperPACharRMSFreq(paOutput, paOutputFit)
%helperPACharRMSFreq Weighted percent RMS error in frequency domain
%   E = helperPACharRMSFreq(POUT,POUTFIT) calculates the percent RMS error
%   of the magnitude of the fitted PA output. POUT and POUTFIT are the
%   measured PA output and estimated PA output waveforms.
%
%   See also PowerAmplifierCharacterizationExample.

%   Copyright 2020 The MathWorks, Inc.

paOutputFrames = reshape(paOutput,length(paOutput)/16,16);
paOutputFitFrames = reshape(paOutputFit,length(paOutputFit)/16,16);
spectrumEst = dsp.SpectrumEstimator('FFTLengthSource','Property','FFTLength',4096);
spectrumEst.SpectrumType = 'Power';
spectrumEst.SpectralAverages = 16;
for p=1:16
  sp = spectrumEst([paOutputFrames(:,p) paOutputFitFrames(:,p)]);
end
refMag = abs(sp(:,1));
err = abs(diff(sp')')./refMag;
weights = 1./(1:length(sp)/2)';
weights = [weights; flipud(weights)];
rmsError = rms(err.*sqrt(weights))*100;
end
