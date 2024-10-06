% no = norm(x)/sqrt(length(x));
% test = sqrt(sum(abs(x).^2)/length(x));
PARP_test = 20*log10(max(abs(x))/sqrt(sum(abs(x).^2)/L));
PAPR = 20*log10(max(abs(x))*sqrt(length(x))/norm(x)); 
 