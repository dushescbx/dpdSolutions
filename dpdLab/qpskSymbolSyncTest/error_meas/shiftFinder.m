function [ dOut, dOutRef, delay ] = ...
    shiftFinder( dIn, ...
    dRef)
% figure; plot(real(dIn)); hold on;
% plot(real(dRef));
[r, lags] = xcorr(dIn, dRef);
[~, i] = max(abs(r));
delay = lags(i);
if delay > 0
    dOut = dIn(1 + delay:end);
    dOutRef = dRef(1:end - delay);
else
    dOut = dIn(1:end + delay);
    dOutRef = dRef(1 - delay:end);
end
[minLen, ~] = min([length(dOut) length(dOutRef)]);
dOut = dOut(1:minLen);
dOutRef = dOutRef(1:minLen);
% figure; plot(lags, abs(r));
% figure; plot(real(dOut)); hold on;
% plot(real(dOutRef));
end
