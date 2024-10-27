  
    %% хглепемхе тюгнбшу хяйюфемхи
    for i=1:1:length(current_dbm_ar_for_ampl_char)
        %% 1 мю бунде
        data_in=1;
        %% люяьрюахпнбюмхе б яннрберярбхх я лнымнярэч
        av_input_power=mean(abs(data_in).^2);
        av_input_power_expected=1e-3*10^(current_dbm_ar_for_ampl_char(i)/10);
        diff=av_input_power_expected/av_input_power;%МЮ ЯЙНКЭЙН ДАЛ ХГЛЕМХРЭ БУНДМНИ ЯХЦМЮК
        data_in=data_in*sqrt(diff);
        av_input_power=10*log10(mean(abs(data_in).^2/1e-3))
        %% цемепхпсел TIMESERIES
        sim('amplifier_angle_meas_data_gen.slx');
        %% оняшкюел яхцмюк мю сяхкхрекэ
        sim('amplifier_angle_meas.slx');
        %% явхршбюел бундмсч х бшундмсч лнымнярх х сцнк
        data_in_ar_power(i)=mean(abs(data_in.data)).^2;
        data_out_ar_power(i)=mean(abs(data_out)).^2;
        data_in_ar_angle(i)=mean(angle(data_in.data))*180/pi;
        data_out_ar_angle(i)=mean(angle(data_out))*180/pi;
    end
    figure;
    %% онярпнемхе цпютхйю гюбхяхлнярх бундмни лнымнярх х хяйюфемхъ сцкю
    plot(10*log10(data_in_ar_power/1e-3),data_out_ar_angle);
    grid on;
    grid minor;
    title(['уЮПЮЙРЕПХЯРХЙЮ СЯХКХРЕКЪ'],'FontName','Arial Cyr');
    xlabel('P_Б_У , dBm','FontName','Arial Cyr');
    ylabel('сЦНК , цПЮДСЯШ ','FontName','Arial Cyr');