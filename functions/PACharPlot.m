function PACharPlot(paOutput,paOutputFit,sampleRate)

Ts = 1/sampleRate;
numDataPts = length(paOutput);
figure;
plot((1:numDataPts)*Ts, abs(paOutput), 'o-', ...
  (1:numDataPts)*Ts, abs(paOutputFit), '.-')
xlabel('Time (s)')
ylabel('Voltage (V)')
% xlim([100 400]/sampleRate)
legend('Actual','Estimated','Location','northeast')
title('Comparison of Actual and Estimated Output Signals')
grid on
