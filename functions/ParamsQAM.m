function [paramOut] = ParamsQAM(paramIn)
paramOut = paramIn; 
paramOut.PAModel.signalSel = 1; % test signal select 1 - QAM, 0 - sine
if paramOut.PAModel.signalSel == 1
    paramOut.PAModel.Fs = paramOut.PAModel.R * paramOut.PAModel.sps ...
        * paramOut.PAModel.interpFactor; % Sampling frequency
else
    paramOut.PAModel.sineOversamplingRate = 2*10;
    paramOut.PAModel.Fs = paramOut.PAModel.sineOversamplingRate * max(paramOut.PAModel.sineFreq);
end