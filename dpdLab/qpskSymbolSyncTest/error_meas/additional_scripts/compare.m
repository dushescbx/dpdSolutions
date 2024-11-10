function [BER] = compare(d1, d2, tit, leg)

len = min([length(d1) length(d2)]);
d1 = double(reshape(d1, [1, length(d1)]));
d1 = d1(1:len);
d2 = double(reshape(d2, [1, length(d2)]));
d2 = d2(1:len);
figure;
subplot(1,2,1);
plot(d1 - d2);
subplot(1,2,2);
plot(d1);
hold on
plot(d2);
title(tit);
legend(leg);

if isempty(nonzeros(d1-d2))
    disp([tit ' no errors']);
    BER = 0;
else
    BER = length(nonzeros(d1-d2))/length(d1)*100;
    disp([tit ' error: BER = ' num2str(length(nonzeros(d1-d2))/length(d1)*100) '%']);
end