res = 50;
RMSinTest = 10*log10(mean(abs(x).^2/res));
RMSin = 10*log10( norm(x)^2/50/length(x));