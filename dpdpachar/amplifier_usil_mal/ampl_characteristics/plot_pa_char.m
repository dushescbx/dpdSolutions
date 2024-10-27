          %% ГРАФИК ВЫХОДНОЙ МОЩНОСТИ В ЗАВИСИМОСТИ ОТ ВХОДНОЙ !!!ПО МОДЕЛИ!!! с символами
    figure(f1);
    plot(10*log10(data_in_ar_power_after_filt_iq/1e-3),10*log10(data_out_ar_power_after_filt_iq/1e-3),'-o');%
    hold on;
    grid on;
    
    %% ГРАФИК ВЫХОДНОЙ МОЩНОСТИ В ЗАВИСИМОСТИ ОТ ВХОДНОЙ !!!ПО МОДЕЛИ!!! с отсчетами
    plot(10*log10(data_in_ar_power/1e-3),10*log10(data_out_ar_power/1e-3),'-*');%
    hold on;
    grid on;
        %% ГРАФИК ВЫХОДНОЙ МОЩНОСТИ В ЗАВИСИМОСТИ ОТ ВХОДНОЙ !!!ПО ПОКАЗАНИЯМ ГЕНЕРАТОРА И АНАЛИЗАТОРА!!!

    plot(input_ar.d,output_ar.d);
 
    
    plot(10*log10(data_in_ar_power_after_filt/1e-3),10*log10(data_out_ar_power_after_filt/1e-3),'-o');%
    %% Строим характеристику усилителя
    grid on;
    grid minor;
    title(['Характеристика усилителя'],'FontName','Arial Cyr');
    xlabel('P_в_х , dBm','FontName','Arial Cyr');
    ylabel('P_в_ы_х , dBm','FontName','Arial Cyr');
    legend('kusochnaya char','char by volterra before filt символы','char by volterra after filt отсчеты','char by symbols from scope','char by model sine','char by sine meas from scope with marker', 'char by sine meas from scope with vsa');
    