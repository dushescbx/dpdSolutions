function [PAInputSignal, ...
    PAInputSignalFiltered, params] = ...
    sine_gen(amplifier, ...
    pindBm, DataLen, params,...
    PAModel, fig_en)
if params.SineinitPhaseSel == 0
    init_phase = 2*pi*rand(length(params.sineFreq), 1);
else
    init_phase = 0;
end
t = 0 : 1/params.Fs : (DataLen-1)/params.Fs;
PAInputSignal_init = sum(cos(2*pi.*params.sineFreq*t + init_phase) ...
    + 1i*sin(2*pi.*params.sineFreq*t + init_phase), 1); %
if PAModel == 1
    PAInputSignalFiltered = filter(params.Filter.num, ...
        params.Filter.den, ...
        PAInputSignal_init);
    PAInputSignal_powFiltered = mean(abs(PAInputSignalFiltered).^2);
    PAInputSignalFiltered_norm = 1/sqrt(PAInputSignal_powFiltered) * PAInputSignalFiltered;
    pin = 10.^((pindBm-30)/10); % dBm2Watts
    PAInputSignalFiltered = PAInputSignalFiltered_norm*sqrt(pin*amplifier.ReferenceImpedance);
else
    PAInputSignalFiltered = [];
end
PAInputSignal_pow = mean(abs(PAInputSignal_init).^2);
PAInputSignal_norm = 1/sqrt(PAInputSignal_pow) * PAInputSignal_init;
pin = 10.^((pindBm-30)/10); % dBm2Watts
PAInputSignal = PAInputSignal_norm*sqrt(pin*amplifier.ReferenceImpedance);
PAInputSignal_powdBm = 10*log10(mean(abs(PAInputSignal).^2 ...
    /amplifier.ReferenceImpedance))+30;
if fig_en
    figure;
    plot((PAInputSignal_norm));
    xlabel('I')
    ylabel('Q')
    title('PAInputSignal norm');
    figure;
    plot(real(PAInputSignal_norm));
    xlabel('samples (n)')
    ylabel('Mag (V)')
    hold on
    plot(imag(PAInputSignal_norm));
    xlabel('samples (n)')
    ylabel('Mag (V)')
    title('PAInputSignal norm');
    figure;
    plot(abs(fft(PAInputSignal)));
    xlabel('samples (n)')
    ylabel('abs(fft(x))')
    title('PAInputSignal norm');
end
end