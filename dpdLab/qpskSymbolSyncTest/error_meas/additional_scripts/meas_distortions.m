function signal = meas_distortions(signal, param)
if param.distortions_on
    figure;
    plot(2*signal.yr_int(1:param.sampsPerSym:end), '*');
    hold on
    plot(signal.x, 'o');
    plot(2*signal.yr_int_dist(1:param.sampsPerSym:end), 'x');
    rx_symb_dist = 2*signal.yr_int_dist(1:param.sampsPerSym:end);
    rx_symb = 2*signal.yr_int(1:param.sampsPerSym:end);
    % EVM %
    EVM = sqrt(sum((real(rx_symb_dist)-real(rx_symb)).^2 + ... %(1/length(rx_symb_dist))*
        (imag(rx_symb_dist)-imag(rx_symb)).^2)./sum(real(rx_symb).^2 + ...
        imag(rx_symb).^2))*100
    % MER dB
    MER = 10*log10(sum(real(rx_symb).^2 + ...
        imag(rx_symb).^2)./sum((real(rx_symb_dist)-real(rx_symb)).^2 + ...
        (imag(rx_symb_dist)-imag(rx_symb)).^2))
else
    figure;
    plot(real(2*signal.freq_phase_corrected_data)); %, '*');
    hold on
    plot(real(signal.x));  %, 'o'
    figure;
    plot(imag(2*signal.freq_phase_corrected_data)); %, '*');
    hold on
    plot(imag(signal.x));  %, 'o'
end