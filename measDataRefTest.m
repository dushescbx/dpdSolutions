x = results.InputWaveform;
x = x./max(x);
y = results.OutputWaveform;
y = y./max(y);
figure; plot(real(x));
hold on; plot(real(y));

figure; plot(20*log10(abs(fft(x))));
hold on; plot(20*log10(abs(fft(y))));