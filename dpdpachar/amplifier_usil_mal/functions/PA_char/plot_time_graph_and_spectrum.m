function plot_time_graph_and_spectrum(data_in,data_out)
        %% построение временных графиков
        
        figure;
        plot(real(data_in));
        hold on;
        plot(real(data_out));
        legend("real data in","real data out");
        
        figure;
        plot(imag(data_in));
        hold on;
        plot(imag(data_out));
        legend("imag data in","imag data out");
       
        %%  построение спектра
        figure;
        plot(20*log10(abs(fft(data_in))));
        hold on;
        plot(20*log10(abs(fft(data_out))));
        legend("spectrum of data in","spectrum of data out");
end