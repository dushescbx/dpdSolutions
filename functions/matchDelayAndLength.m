function [dOut, dOutRef] = matchDelayAndLength...
    (dIn, dRef, delay)

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
end