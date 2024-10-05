function helperPACharPlotGain(paInput,paOutput,paOutputFit)
%helperPACharPlotGain Plot PA characterization results for gain
%   E = helperPACharPlotGain(PIN,POUT,POUTFIT) plots the gain based
%   on the measured PA output, POUT, and the estimated PA output, POUTFIT,
%   and PA input, PIN.
%
%   See also PowerAmplifierCharacterizationExample.

%   Copyright 2020 The MathWorks, Inc.

% +30 for W to mW, -20 for 50 Ohm
paInputPowerdBm = mag2db(abs(paInput)) + 30 - 20;
paOutputPowerdBm = mag2db(abs(paOutput)) + 30 - 20;
paOutputPowerFitdBm = mag2db(abs(paOutputFit)) + 30 - 20;
inputPowerRange = 20;
idxToDiscard = paInputPowerdBm < (max(paInputPowerdBm)-inputPowerRange);
paInputPowerdBm(idxToDiscard) = [];
paOutputPowerdBm(idxToDiscard) = [];
paOutputPowerFitdBm(idxToDiscard) = [];

paGain = paOutputPowerdBm - paInputPowerdBm;
paGainFit = paOutputPowerFitdBm - paInputPowerdBm;
plot(paInputPowerdBm, paGain, 'o', ...
  paInputPowerdBm, paGainFit, '.')
xlabel('Input Power (dBm)')
ylabel('Power Gain (dB)')
legend('Actual Gain','Estimated Gain','Location','northeast')
title('Comparison of Actual and Estimated Gain')
grid on
