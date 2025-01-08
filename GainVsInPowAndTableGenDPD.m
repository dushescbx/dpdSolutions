 function inOutTable = GainVsInPowAndTableGenDPD(...
     OutputWaveform, InputWaveform, refImp, PAgain, figEn)

[InputWaveformdBm,...
    OutputWaveformdBm, ~] =...
    AMAM_AMPM_gen(InputWaveform, ...
    OutputWaveform, refImp);

if figEn
    figure;
    plot(InputWaveformdBm, OutputWaveformdBm, '.')
    grid on
    xlabel('Input Power (dBm)')
    ylabel('Output Power (dBm)')
    title('Output vs Input Power')
end
[N,edges,idx] = histcounts(InputWaveformdBm, 'BinWidth', 0.5); % 1

minInPowerdBm = min(InputWaveformdBm);% - 10; % 20
minIdx = find(edges < minInPowerdBm, 1, 'last');
tableLen = length(edges)-minIdx-1;
inOutTable = zeros(tableLen,3);
for p = minIdx+1:length(edges)-1
    inOutTable(p-minIdx,1) = mean(InputWaveformdBm(idx == p));   % Average input power for current bin
    inOutTable(p-minIdx,2) = mean(OutputWaveformdBm(idx == p));  % Average output power for current bin
    %   inOutTable(p-minIdx,3) = ...
    %       180/pi*mean(angle(OutputWaveform(idx == p))-angle(InputWaveform(idx == p)));  % Average phase shift for current bin
    inOutTable(p-minIdx,3) = 180/pi*mean(angle(OutputWaveform(idx == p)./InputWaveform(idx == p)));  % Average phase shift for current bin
end
%% NaN del
% input power
inOutTable(:, 1) = NaNReplace(inOutTable(:, 1), "InputPower", figEn);
% output power
inOutTable(:, 2) = NaNReplace(inOutTable(:, 2), "OutputPower", figEn);
% phase
inOutTable(:, 3) = NaNReplace(inOutTable(:, 3), "Phase", 0);
%% scale
inOutTable(:, 1) = inOutTable(:, 1) - PAgain;
% inOutTable(:, 2) = inOutTable(:, 2) + 100;
%% 
if figEn
    figure;
    plot(inOutTable(:,1), inOutTable(:,2), '.')
    grid on
    xlabel('Input Power (dBm)')
    ylabel('Output Power (dBm)')
    title('Output vs Input Power LUT')
    figure;
    plot(inOutTable(:,1), inOutTable(:,3), '.')
    grid on
    xlabel('Input Power (dBm)')
    ylabel('Output phase (deg)')
    title('Output phase vs Input Power LUT')
end