function [yq] = InterpolateSigSpline...
    (txWaveform, overSamplingRate)

x = 0 : length(txWaveform) - 1;
y = txWaveform;
xq = 0 : 1/overSamplingRate : x(end);
yq = spline(x, y, xq);
