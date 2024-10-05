function [rmsError] ...
    = PACharGridSearchTime(...
    paInput,paOutput,modType,...
    param_GridSearch)
% osf = param_GridSearch.PolyLen;
memLenMax = param_GridSearch.MemLen;
degLenMax = param_GridSearch.PolyLen;
numDataPts = length(paInput);
halfDataPts = round(numDataPts/2);
paInputTrain = paInput(1:halfDataPts);
paOutputTrain = paOutput(1:halfDataPts);

rmsError = zeros(memLenMax,degLenMax);
for memLen = 1:memLenMax
    parfor degLen = 1:degLenMax
        warnState = warning('off','MATLAB:rankDeficientMatrix');
        restoreWArningState = onCleanup(@()warning(warnState));

        fitCoefMat = MemPolyModel('coefficientFinder',             ...
            paInputTrain,paOutputTrain,memLen,degLen,modType);

        [errSig] = MemPolyModel('errorMeasure', ...
            paInput, paOutput, fitCoefMat, modType);

        rmsError(memLen,degLen) = errSig;
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
title('Error')
end