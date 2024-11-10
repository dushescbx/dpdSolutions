%% IQ demodulation
function signal = iq_demod(signal, param)
sin_demod_IQ = sin(signal.tx_int*param.f_iq*2*pi+param.phase_offset);
cos_demod_IQ = cos(signal.tx_int*param.f_iq*2*pi+param.phase_offset);
if param.distortions_on
    I_demod_signal_dist = signal.IQ_mod_signal_dist .* cos_demod_IQ; % distorted IQ sig
    Q_demod_signal_dist = signal.IQ_mod_signal_dist .* (-1*sin_demod_IQ);
    signal.rx_signal_dist = complex(I_demod_signal_dist, Q_demod_signal_dist).';
end
I_demod_signal = real(signal.IQ_mod_signal) .* cos_demod_IQ; % ref IQ sig
Q_demod_signal = real(signal.IQ_mod_signal) .* (-1*sin_demod_IQ);
I_demod_signal_1 = imag(signal.IQ_mod_signal) .* sin_demod_IQ; % ref IQ sig
Q_demod_signal_1 = imag(signal.IQ_mod_signal) .* cos_demod_IQ;
signal.rx_signal = complex(I_demod_signal, Q_demod_signal).';
signal.rx_signal_1 = complex(I_demod_signal_1, Q_demod_signal_1).';
% % Plot data.
% figure;
% stem(signal.tx, imag(signal.x), 'kx'); hold on;
% % Plot filtered data.
% plot(signal.to, imag(signal.yc), 'm-');% plot(tx_int, imag(yq));
% plot(signal.tx_int, imag(signal.rx_signal));hold off;
% % Set axes and labels.
% xlabel('Time (ms)'); ylabel('Amplitude');
% legend('Transmitted Data','Sqrt. Raised Cosine','Sqrt. Raised Cosine interp','Location','southeast')
