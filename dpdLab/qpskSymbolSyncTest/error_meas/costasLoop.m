function [out, ...
    freqEst] = costasLoop(rx_symbol,...
    param, M, figEn)
phase = zeros(1, length(rx_symbol) + 1);
freq = zeros(1, length(rx_symbol) + 1);
error = zeros(1, length(rx_symbol) + 1);
out = zeros(length(rx_symbol), 1);
for i = 2 : length(rx_symbol) + 1
    out(i-1) = rx_symbol(i-1) * exp(-1i*phase(i-1));
    if (M == 1)
        error(i) = real(out(i-1)) * imag(out(i-1));
    elseif (M == 2)
        error(i) = sign(real(out(i-1)))*imag(out(i-1)) - sign(imag(out(i-1)))*real(out(i-1));
    end
    freq(i) = freq(i-1) + (param.beta * error(i));
    phase(i) = wrapTo2Pi(freq(i) + (param.alpha * error(i)));
end
%%
if figEn
    figure; plot(error);
    title('(error)')
    figure; plot(freq/(2*pi));
    title('(freq/(2*pi))')
    figure; plot(diff(freq/(2*pi)));
    title('diff(freq/(2*pi))')
end
secondDiffFreq = diff(diff(freq/(2*pi)));
Nav = 100; tol = 1e-10;
for i = 1 : length(secondDiffFreq) - Nav
    mean2ndDiff(i) = mean(secondDiffFreq(i : i + Nav));
end
indLock = find(abs(mean2ndDiff) < tol, 1) + Nav;
if ~isempty(indLock)
    freqEst = mean(diff(freq(indLock:end)/(2*pi)));
else
    freqEst = 0;
end
if figEn
    figure; plot(abs(mean2ndDiff));
    title('mean2ndDiff')
    figure; plot(secondDiffFreq);
    title('secondDiffFreq')
    figure; plot(phase);
    title('phase')
    
    figure; plot(real(out));
    hold on; plot(imag(out));
    title('out sig')
end

out = out(indLock : end);