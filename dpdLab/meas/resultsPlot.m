%figure; plot(10*log10(abs(fft(x))));
%figure; plot(10*log10(abs(fft(y))));
%x1 = x(15e3:15.5e3);
%y1 = y(15e3:15.5e3);
%close all
%figure; plot(real(x1));
%figure; plot(real(y1));
figure; plot(abs(xcorr(x1,x1)))
figure; plot(real(xcorr(x1,x1)))
hold on; plot(imag(xcorr(x1,x1)))