function [f, ydb] = spectrumPlot(Fs, x, figEn)
% t = 0:1/Fs:1-1/Fs;
y = fft(x);
z = fftshift(y);
ly = length(y);
f = (-ly/2:ly/2-1)/ly*Fs;
ydb = mag2db(abs(z)/length(z));
if figEn
    plot(f, ydb)
    title("Double-Sided Amplitude Spectrum of x(t)")
    xlabel("Frequency (Hz)")
    ylabel("|y|")
    grid on
    grid minor
end
tol = 1e-6;
z(abs(z) < tol) = 0;

theta = angle(z);
% figure;
% stem(f,theta/pi)
% title("Phase Spectrum of x(t)")
% xlabel("Frequency (Hz)")
% ylabel("Phase/\pi")
% grid
end