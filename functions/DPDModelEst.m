function [OutputWaveformAfterDPDPA, OutputWaveformAfterDPD] ...
    = DPDModelEst(param, InputWaveform, ...
    OutputWaveform, coef, figEn)

numDataPts = length(InputWaveform);
halfDataPts = round(numDataPts/2);

OutputWaveformAfterPA = MemPolyModel('signalGenerator', ...
    InputWaveform, coef, param.modType);
if param.MatPAModel
    dpdDataPoints = halfDataPts;
else
    dpdDataPoints = numDataPts;
end

[OutputWaveformPowNorm, coef] = ...
    equalPower(InputWaveform, OutputWaveform);
gainCoefAr = sqrt(db2pow(0));
for i = 1 : length(gainCoefAr)
fitCoefDPDMem = MemPolyModel('coefficientFinder',             ...
    OutputWaveformPowNorm(1:dpdDataPoints),gainCoefAr(i)*InputWaveform(1:dpdDataPoints), ...
    param.memLen,param.degLen,param.modType);


OutputWaveformAfterDPD(:, i) = MemPolyModel('signalGenerator', ...
    InputWaveform, fitCoefDPDMem, param.modType);
[OutputWaveformAfterDPD, coef] = ...
    equalPower(InputWaveform, OutputWaveformAfterDPD);
    % figure;
     % hold on;
    % spectrumPlot(1, OutputWaveformPowNorm(:, i), 1);
    figure;
      spectrumPlot(1, InputWaveform(:, i), 1);
      figure;
    spectrumPlot(1, OutputWaveformAfterDPD(:, i), 1);
  legend('output', 'input', 'dpd')
end

%%
if param.MatPAModel
    OutputWaveformAfterDPDPA = param.amplifier(OutputWaveformAfterDPD);
else
    OutputWaveformAfterDPDPA = [];
end

if figEn
    figure;
    spectrumPlot(1, OutputWaveform, 1);
    % hold on
    % figure;
    % spectrumPlot(1, OutputWaveformAfterDPDpowCorr, 1);
    figure;
    spectrumPlot(1, OutputWaveformAfterDPDPA, 1);
        figure;
    spectrumPlot(1, InputWaveform, 1);
end

% OutputWaveformAfterDPDPA = MemPolyModel('signalGenerator', ...
%     OutputWaveformAfterDPD, coef, param.modType);

% rmsErrorTimeMem = MemPolyModel('errorMeasure', ...
%     OutputWaveformAfterDPD, InputWaveform, coef, param.modType);
% disp(['Percent RMS error in time domain is ' num2str(rmsErrorTimeMem) '%'])
% figure; plot(OutputWaveformAfterDPD, '*');
% figure; plot(OutputWaveformAfterDPDPA, '.');
% figure; plot(OutputWaveformAfterPA, 'o');
% figure; plot(InputWaveform, 'x');

% figure;
% plot(real(OutputWaveformAfterDPDPA(param.memLen:end)));
% hold on
% plot(real(InputWaveform(param.memLen:end)));

% difference = mean(abs(OutputWaveformAfterDPDPA(param.memLen:end)...
%     -InputWaveform(param.memLen:end)))


% if figEn
%     PACharPlot(OutputWaveform, OutputWaveformFitMem, sampleRate)
%     PACharPlot(OutputWaveformFitMemSine, OutputWaveformFitMem, sampleRate)
%     PACharModelCompare(InputWaveform, OutputWaveform, OutputWaveformFitMem)
%
%     sa = SigSpectrum(...
%         [OutputWaveform...
%         OutputWaveformFitMem...
%         OutputWaveformFitMemSine ...
%         InputWaveform],...
%         sampleRate, testSignal, [], ...
%         {'Actual PA QAM Output', 'Memory Polynomial sine Output',...
%         'Memory Polynomial QAM Output', 'PA Input'}, 1, 1);
% else
%     sa = [];
% end