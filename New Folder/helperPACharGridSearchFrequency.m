function rmsError = helperPACharGridSearchFrequency(paInput,paOutput,modType,osf)
%helperPACharGridSearchFrequency Grid search in frequency domain
%   E = helperPACharGridSearchFrequency(PIN,POUT,MODEL,OSF) performs a grid
%   search over memory length and polynomial degree for PA model, MODEL, to
%   minimize the weighted percent RMS error of the magnitude of the
%   spectrum of the fitted PA output. PIN and POUT are the input and output
%   waveforms of the PA. OSF is the oversampling factor. E is the weighted
%   percent RMS values matrix of size 8xOSF. The rows correspond to
%   memory length from 1 to 8, while columns correspond to polynomial
%   degree from 1 to OSF.
%
%   See also PowerAmplifierCharacterizationExample.

%   Copyright 2020 The MathWorks, Inc.

numDataPts = length(paInput);
halfDataPts = round(numDataPts/2);
paInputTrain = paInput(1:halfDataPts);
paOutputTrain = paOutput(1:halfDataPts);

paOutputFrames = reshape(paOutput,length(paOutput)/16,16);
spectrumEst = dsp.SpectrumEstimator;
spectrumEst.SpectrumType = 'Power';
spectrumEst.SpectralAverages = 16;
for p=1:16
  spOutput = spectrumEst(paOutputFrames(:,p));
end
refMag = abs(spOutput);

rmsError = zeros(8,osf);
for memLen = 1:8
  parfor degLen = 1:osf
    sp = 0;
    warnState = warning('off','MATLAB:rankDeficientMatrix');
    restoreWArningState = onCleanup(@()warning(warnState));
    
    spectrumEst = dsp.SpectrumEstimator;
    spectrumEst.SpectrumType = 'Power';
    spectrumEst.SpectralAverages = 16;
    
    fitCoefMat = helperPACharMemPolyModel('coefficientFinder',             ...
      paInputTrain,paOutputTrain,memLen,degLen,modType);

    paOutputFit = helperPACharMemPolyModel('signalGenerator', ...
      paInput, fitCoefMat, modType);
    
    paOutputFitFrames = reshape(paOutputFit,length(paOutputFit)/16,16);
    for p=1:16
      sp = spectrumEst(paOutputFitFrames(:,p));
    end
    
    err = abs(spOutput - sp)./refMag;
    weights = 1./(1:length(sp)/2)';
    weights = [weights; flipud(weights)];
    rmsError(memLen,degLen) = rms(err.*sqrt(weights))*100;
  end
end

figure
contourf(rmsError)
grid on
colorbar
xlabel('Polynomial Degree')
ylabel('Memory Length')
title('Percent RMS Error')
end