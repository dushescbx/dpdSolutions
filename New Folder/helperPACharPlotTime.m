function helperPACharPlotTime(paOutput,paOutputFit,sampleRate)
%helperPACharPlotResults Plot PA characterization results
%   E = helperPACharPlotResults(POUT,POUTFIT,TYPE,R) plots the magnitude of
%   the measured PA output, POUT, and the estimated PA output, POUTFIT, in
%   time, when TYPE is 'time'. R is the sample rate.
%
%   See also PowerAmplifierCharacterizationExample.

%   Copyright 2020 The MathWorks, Inc.

Ts = 1/sampleRate;
numDataPts = length(paOutput);
plot((1:numDataPts)*Ts, abs(paOutput), 'o-', ...
  (1:numDataPts)*Ts, abs(paOutputFit), '.-')
xlabel('Time (s)')
ylabel('Voltage (V)')
xlim([100 400]/sampleRate)
legend('Actual','Estimated','Location','northeast')
title('Comparison of Actual and Estimated Output Signals')
grid on
