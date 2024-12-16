function [out, coef] = equalPower(ref, in)
powerRef = mean(abs(ref.^2));
powerIn = mean(abs(in.^2));
coef = powerRef/powerIn;
out = sqrt(coef) * in;
end