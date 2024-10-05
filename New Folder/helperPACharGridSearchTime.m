function rmsError = helperPACharGridSearchTime(paInput,paOutput,modType,osf)
%helperPACharGridSearchTime Grid search in time domain
%   E = helperPACharGridSearchTime(PIN,POUT,MODEL,OSF) performs a grid
%   search over memory length and polynomial degree for PA model, MODEL, to
%   minimize the percent RMS error of the magnitude of the fitted PA
%   output. PIN and POUT are the input and output waveforms of the PA. OSF
%   is the oversampling factor. E is the weighted percent RMS values matrix
%   of size 8xOSF. The rows correspond to memory length from 1 to 8,
%   while columns correspond to polynomial degree from 1 to OSF.
%
%   See also PowerAmplifierCharacterizationExample.

%   Copyright 2020 The MathWorks, Inc.

numDataPts = length(paInput);
halfDataPts = round(numDataPts/2);
paInputTrain = paInput(1:halfDataPts);
paOutputTrain = paOutput(1:halfDataPts);

rmsError = zeros(8,osf);
for memLen = 1:8
  parfor degLen = 1:osf
    warnState = warning('off','MATLAB:rankDeficientMatrix');
    restoreWArningState = onCleanup(@()warning(warnState));
    
    fitCoefMat = helperPACharMemPolyModel('coefficientFinder',             ...
      paInputTrain,paOutputTrain,memLen,degLen,modType);
    
    [errSig] = helperPACharMemPolyModel('errorMeasure', ...
      paInput, paOutput, fitCoefMat, modType);
    
    rmsError(memLen,degLen) = errSig;
  end
end

figure
contourf(rmsError)
grid on
colorbar
xlabel('Polynomial Degree')
ylabel('Memory Length')
title('Error')
end