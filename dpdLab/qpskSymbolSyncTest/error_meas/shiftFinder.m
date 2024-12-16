function [ dOut, dOutRef, delay, phase ] = ...
    shiftFinder( dIn, ...
    dRef, figEn)
if figEn
    figure; plot(real(dIn)); hold on;
    plot(real(dRef));
end
[r, lags] = xcorr(dIn, dRef);
[~, i] = max(abs(r));
delay = lags(i);
phase = angle(r(i));

[dOut, dOutRef] = matchDelayAndLength...
    (dIn, dRef, delay);

if figEn
    figure; plot(lags, abs(r));
    figure; plot(real(dOut)); hold on;
    plot(real(dOutRef));
end
end
