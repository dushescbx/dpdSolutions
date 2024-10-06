function yOut = splitFFT(nAr, Y, figEn)
Y = reshape(Y, 1, []);
yOut = zeros(length(nAr) - 1, length(Y));
for i = 1:length(nAr)-1
    y1 = Y(nAr(i):nAr(i+1));
    if i > 1
        y1 = [zeros(1, nAr(i)-1) y1 ];
    end
    y1 = [y1 zeros(1, length(Y) - length(y1))];
    % y1 = [y1 y1(end-1:-1:2)];
    yOut (i, :) = y1;
    if figEn        
        subplot(1, length(nAr), i);
        plot(abs(Y), '-*');
        hold on; plot(abs(y1), '-x');
        xlabel('n (sample)');
        ylabel('fft(x)');
    end
end
end