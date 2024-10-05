function PACharModelCompare(paInput,paOutput,paOutputFit)

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
figure;
plot(paInputPowerdBm, paGain, 'o', ...
  paInputPowerdBm, paGainFit, '.')
xlabel('Input Power (dBm)')
ylabel('Power Gain (dB)')
legend('Actual Gain','Estimated Gain','Location','northeast')
title('Comparison of Actual and Estimated Gain')
grid on
