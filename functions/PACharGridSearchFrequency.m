function rmsError = ...
    PACharGridSearchFrequency(...
    paInput,paOutput,modType,...
    param_GridSearch)

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

% osf = param_GridSearch.PolyLen;
memLenMax = param_GridSearch.MemLen;
degLenMax = param_GridSearch.PolyLen;
rmsError = zeros(memLenMax,degLenMax);

for memLen = 1:memLenMax
  parfor degLen = 1:degLenMax
    sp = 0;
    warnState = warning('off','MATLAB:rankDeficientMatrix');
    restoreWArningState = onCleanup(@()warning(warnState));
    
    spectrumEst = dsp.SpectrumEstimator;
    spectrumEst.SpectrumType = 'Power';
    spectrumEst.SpectralAverages = 16;
    
    fitCoefMat = MemPolyModel('coefficientFinder',             ...
      paInputTrain,paOutputTrain,memLen,degLen,modType);

    paOutputFit = MemPolyModel('signalGenerator', ...
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
% contourf(rmsError)
if (memLenMax > 1) && (degLenMax > 1)
    surf(rmsError);
else
    plot(1:degLenMax, rmsError)
end
grid on
colorbar
xlabel('Polynomial Degree')
ylabel('Memory Length')
title('Percent RMS Error')
end