function [OutputWaveformAfterDPDPA, OutputWaveformAfterDPD] ...
    = DPDModelEst(param, InputWaveform, ...
    OutputWaveform, coef, figEn)

numDataPts = length(InputWaveform);
halfDataPts = round(numDataPts/2);

% OutputWaveformAfterPA = MemPolyModel('signalGenerator', ...
%     InputWaveform, coef, param.modType);
if param.MatPAModel
    dpdDataPoints = halfDataPts;
else
    dpdDataPoints = numDataPts;
end

% [OutputWaveformPowNorm, ~] = ...
%     equalPower(InputWaveform, OutputWaveform);
gainCoefAr = sqrt(db2pow(0));
for i = 1 : length(gainCoefAr)
    fitCoefDPDMem = MemPolyModel('coefficientFinder',...
        OutputWaveform(1:dpdDataPoints),...
        gainCoefAr(i)*InputWaveform(1:dpdDataPoints), ...
        param.memLen,param.degLen,param.modType);


    OutputWaveformAfterDPD = MemPolyModel('signalGenerator', ...
        InputWaveform, fitCoefDPDMem, param.modType);
    % [OutputWaveformAfterDPD, ~] = ...
    %     equalPower(InputWaveform, OutputWaveformAfterDPD);
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