function [ydbpaInInBand, ydbpaInOutBand] =...
    inOutBandPowerMeas(paIn, sps, interpFactor)
% figure;
[fpaIn, ydbpaIn] = spectrumPlot(1, paIn, 0);
inBandIndex = (fpaIn > ...
    -1/(2*sps*interpFactor)) &...
    (fpaIn < ...
    1/(2*sps*interpFactor));
ydbpaInInBand = mean(ydbpaIn(inBandIndex));
ydbpaInOutBand = mean(ydbpaIn(~inBandIndex));
% ACPR = ydbpaInInBand - ydbpaInOutBand;
% figure; plot(ydbpaInInBand);
% figure; plot(ydbpaInOutBand);
end