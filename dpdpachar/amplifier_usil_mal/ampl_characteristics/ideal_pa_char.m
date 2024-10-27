   data_out_ar_power = output_ar.d;
   data_in_ar_power = input_ar.d;
    %% ÑÎÇÄÀÅÌ ÌÀÑÑÈÂ Ñ ïğèìåğíûì óñèëåíèåì óñèëèòåëÿ â äàííîé òî÷êå âõîäíîé ìîùíîñòè
    for i=1:1:length(data_out_ar_power)-1
        %     gain_koef(i)=(log10(data_out_ar_power(i+1))-log10(data_out_ar_power(i)))/(log10(data_in_ar_power(i+1))-log10(data_in_ar_power(i)));
        gain_koef=10*log10(data_out_ar_power./data_in_ar_power)/2;
    end
    %% ÑÒĞÎÈÌ ÈÄÅÀËÜÍÓŞ ËÈÍÈŞ ÓÑÈËÅÍÈß
    koef=(10*log10(data_out_ar_power(2)/1e-3)-10*log10(data_out_ar_power(1)/1e-3))/(10*log10(data_in_ar_power(2)/1e-3)-10*log10(data_in_ar_power(1)/1e-3));
    a0=data_out_ar_power(1)+koef*data_in_ar_power(1);
    data_out_ar_power_ideal=a0+koef*data_in_ar_power(3:end);
    %% ÃĞÀÔÈÊ ÈÄÅÀËÜÍÎÉ ËÈÍÈÈ ÓÑÈËÅÍÈß
    figure;
    plot(10*log10(data_in_ar_power(3:end)/1e-3),10*log10(data_out_ar_power_ideal/1e-3));