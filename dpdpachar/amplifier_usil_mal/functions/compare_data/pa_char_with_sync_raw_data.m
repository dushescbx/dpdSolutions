function pa_char_with_sync_raw_data(input_pow_ar, output_pow_ar, direct, APSK, figure_on, PAmemory, PAorder)
%% õàğàêòåğèçàöèÿ óñèëèòåëÿ ïğè ïîìîùè ñèíõğ. raw äàííûõ
data_in = zeros(0,0);
data_out = zeros(0,0);
data_out_from_model = zeros(0,0);
data_out_from_scope = zeros(0,0);
for i = 1 : 1 : length(input_pow_ar)
    
    %% ÇÀÃĞÓÆÀÅÌ ñèìâîëû Ñ×ÈÒÀÍÍÛÅ ÈÇ ÀÍÀËÈÇÀÒÎĞÀ è ñèíõğîíèçèğîâàííûå
    load([direct '\sync_dom\sync_data\symbol_synch_data_' num2str(APSK) 'APSK_Power='  num2str(input_pow_ar(i)) '_iq_sync_data.mat']);
    data_out_ADD = sync_data;
%     scatterplot(data_out_ADD);
    %% ïğîïóñêàåì ÷åğåç ïåğåäàşùèé ôèëüòğ
    data_out_ADD = tx_filter(data_out_ADD(:));
    %% ÌÀÑØÒÀÁÈĞÓÅÌ Â ÑÎÎÒÂÅÒÑÒÂÈÈ Ñ ÂÛÕÎÄÍÎÉ ÌÎÙÍÎÑÒÜŞ
    data_out_ADD = scale_power(data_out_ADD(18:end),output_pow_ar,i); 
    
    %% îáúåäèíåíèå ìàññèâîâ âûõîäíûõ äàííûõ
      
    %% çàãğóçêà âõîäíûõ äàííûõ
    %% ÏÎÄÀÅÌ ÍÀ ÂÕÎÄ ÈÄÅÀËÜÍÛÅ ñèìâîëû
    load([direct '\amplifier_usil_mal\' num2str(APSK) 'APSK_ref_symb_timeseries.mat']);
    data_in_ADD = ref_sym_symbols.data(1:length(data_out_ADD)/4+17);
%     scatterplot(data_in_ADD);
    %% ïğîïóñêàåì ÷åğåç ïåğåäàşùèé ôèëüòğ
    data_in_ADD = tx_filter(data_in_ADD(:));
    %% ÌÀÑØÒÀÁÈĞÓÅÌ Â ÑÎÎÒÂÅÒÑÒÂÈÈ Ñ ÂÛÕÎÄÍÎÉ ÌÎÙÍÎÑÒÜŞ
    data_in_ADD = scale_power(data_in_ADD, input_pow_ar, i);
    
    %% îáúåäèíåíèå ÂÕÎÄÍÛÕ ÑÎÇÂÅÇÄÈÉ ĞÀÇÍÎÉ ÌÎÙÍÎÑÒÈ;
    data_in = [data_in; data_in_ADD(18:length(data_out_ADD)+17)];
    
%     data_out_ADD = offset_find(data_out_ADD, data_in);
    data_out = [ data_out(:); data_out_ADD ];  
    scatterplot(data_out_ADD);
    title(['out coef pow=' num2str(input_pow_ar(i))]);
end
%% ïîñòğîåíèå âğåìåííûõ ãğàôèêîâ è ñïåêòğà
if (figure_on == 1)
    plot_time_graph_and_spectrum(data_in, data_out);
end


%% ÏÎËÓ×ÅÍÈÅ ÊÎİÔÔÈÖÈÅÍÒÎÂ ÄËß ÌÎÄÅËÈ ÓÑÈËÈÒÅËß
a_coef = fit_memory_poly_model(data_in(1:length(data_out)), data_out, PAmemory, PAorder, 'MemPoly')
save(['a_coef_sync_' num2str(APSK) 'APSK.mat'],'a_coef');

%% ÌÎÄÅËÈĞÎÂÀÍÈÅ ÓÑÈËÈÒÅËß ÏĞÈ ÏÎÌÎÙÈ ÌÎÄÅËÈ ÂÎËÜÒÅĞĞÀ Ñ a_coef
data_in_from_model = zeros(0,0);
data_out_from_model = zeros(0,0);

for i=1:1:length(input_pow_ar)
    %     load(['a_coef_' num2str(APSK_ar(f)) 'APSK.mat'],'a_coef');
    clear simin
    %% ÇÀÃĞÓÆÀÅÌ ÈÄÅÀËÜÍÛÅ ñèìâîëû
    load([direct '\amplifier_usil_mal\' num2str(APSK) 'APSK_ref_symb_timeseries.mat']);
%     scatterplot(ref_sym_symbols.data(1 : 9972));
    tx_filter_in(:) = ref_sym_symbols.data(1 : 9972);
    tx_filter_out = tx_filter(tx_filter_in.');
    simin.time = 0:length(tx_filter_out) - 1;
    simin.data = tx_filter_out;
    %% ÌÀÑØÒÀÁÈĞÓÅÌ ÏÎÄ ÇÀÄÀÍÍÓŞ ÌÎÙÍÎÑÒÜ
    simin.data = scale_power(simin.data(:),input_pow_ar,i);

    simin = timeseries(simin.data,simin.time);
    %% mem poly
    x = mem_poly_wo_ct(a_coef,PAmemory,PAorder,simin.data).';  
    sim('MP_model_for_sync_data.slx');
    
        scatterplot(x);
    title(['out model pow=' num2str(input_pow_ar(i))]);
%     x = offset_find(x, tx_filter_in)
    %% ÇÀÏÈÑÛÂÀÅÌ ÂÕÎÄÍÓŞ È ÂÛÕÎÄÍÓŞ ÌÎÙÍÎÑÒÜ Â ÌÀÑÑÈÂ
    data_in_ar_power_after_filt_iq(i)=10*log10(mean(abs(simin.data).^2)/1e-3);
    data_out_ar_power_after_filt_iq(i)=10*log10(mean(abs(out_sig_wo_dpd_wo_filt(11:length(simin.data)).^2)/1e-3));
    data_out_power(i)=10*log10(mean(abs(x(19:length(simin.data)).^2)/1e-3));
    %% îáúåäèíåíèå ìàññèâîâ âûõîäíûõ äàííûõ
%     data_in_from_model=[data_in_from_model(:); simin.data];
data_for_conv_in = simin.data(18:end);
data_for_conv_out = x(19:end);
min_len = min([ length(data_for_conv_in); length(data_for_conv_out)]);
    data_in_from_model=[data_in_from_model(:); data_for_conv_in(1:min_len)];
    data_out_from_model=[ data_out_from_model(:); data_for_conv_out(1:min_len) ];
%     for i = 1:4
    x_rx_filt = rx_filter(x(2:floor(length(x)/4)+2-1));
    scatterplot(x_rx_filt);
    title(['model out pow=' num2str(input_pow_ar(i))]);
%     end
%     data_out_from_model=[ data_out_from_model(:); out_sig_wo_dpd_wo_filt(1:length(simin.data)) ];

%     figure;
%     plot(abs(data_in_from_model));
%     hold on;
%     plot(abs(data_out_from_model));
%     title('abs');
%     legend('model');
%     figure;
%     plot(abs(data_in_from_model));
%     hold on;
%     plot(abs(data_out_from_model));
    
    %         data_in_ar_power(i)=mean(abs(simin.data)).^2;
    %         data_out_ar_power(i)=mean(abs(out_sig_wo_dpd(11:end))).^2;
end
% plot_time_graph_and_spectrum(data_in_from_model,data_out_from_model);
compare_constellations(data_out_from_model,data_out);

figure;
plot(data_in_ar_power_after_filt_iq,data_out_ar_power_after_filt_iq);
hold on
plot(input_pow_ar,output_pow_ar);
plot(data_in_ar_power_after_filt_iq,data_out_power);
legend('model','meas','my funct');