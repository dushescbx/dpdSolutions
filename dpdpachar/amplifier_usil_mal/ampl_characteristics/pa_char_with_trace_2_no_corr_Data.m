%% ÌÎÄÅËÜ Ñ ÑÈÌÂÎËÀÌÈ(ÏÎÑËÅ ÔÈËÜÒĞÀ)
% close all

data_in=zeros(0,0);
data_out=zeros(0,0);
data_out_from_model=zeros(0,0);
data_out_from_scope=zeros(0,0);
data_offset_range = 400;
for i=1:1:length(input_ar.d)
    
    %% çàãğóçêà âõîäíûõ äàííûõ
    
    %% ÏÎÄÀÅÌ ÍÀ ÂÕÎÄ ÈÄÅÀËÜÍÛÅ ñèìâîëû
    load([dir '\amplifier_usil_mal\' num2str(APSK_ar(f)) 'APSK_ref_symb_timeseries.mat']);
    %      load(['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier_usil_mal\' num2str(APSK_ar(f)) 'APSK_ref_symb_timeseries.mat']);
    data_in_ADD=ref_sym_symbols.data(1:ARBitrary_TRIGger_SLENgth);
    %         scatterplot(data_in_ADD);
    data_in_ADD = tx_filter(data_in_ADD(:));
    data_in_ADD=scale_power(data_in_ADD,input_ar.d,i);
    
    
    
    
    %% îáúåäèíåíèå ÂÕÎÄÍÛÕ ÑÎÇÂÅÇÄÈÉ ĞÀÇÍÎÉ ÌÎÙÍÎÑÒÈ;
    
    data_in=[data_in; data_in_ADD(18 + data_offset_range : 1.5e4)];
    
    %% ÇÀÃĞÓÆÀÅÌ ñèìâîëû Ñ×ÈÒÀÍÍÛÅ ÈÇ ÀÍÀËÈÇÀÒÎĞÀ
    load([dir '\ampl_scripts\output_input_signals\_' num2str(APSK_ar(f)) 'APSK'  num2str(input_ar.d(i)) 'dbm_DPD_on=False_pa_on=True_trace.dat.mat'])
    %     load([dir '\ampl_scripts\output_input_signals\_' num2str(APSK_ar(f)) 'APSK'  num2str(input_ar.d(i)) 'dbm_DPD_on=False_pa_on=True_trace.dat.mat'])
    
    %      load(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\_' num2str(APSK_ar(f)) 'APSK'  num2str(input_ar.d(i)) 'dbm_DPD_on=False_pa_on=True_trace.dat.mat'])
    
    data_out_ADD=simin.data(6:end);
    %     scatterplot(simin.data);
    %     title('trace data');
    %% ÌÀÑØÒÀÁÈĞÓÅÌ Â ÑÎÎÒÂÅÒÑÒÂÈÈ Ñ ÂÛÕÎÄÍÎÉ ÌÎÙÍÎÑÒÜŞ
    data_out_ADD = tx_filter(data_out_ADD(:));
    data_out_ADD=scale_power(data_out_ADD(18 + data_offset_range : 1.5e4),output_ar.d,i);
    
    %% îáúåäèíåíèå ìàññèâîâ âûõîäíûõ äàííûõ
    data_out=[ data_out(:); data_out_ADD ];
    %         scatterplot(data_out_ADD);
    
    %     figure;
    %     plot(real(data_in));
    %     hold on
    %     plot(real(data_out));
    
end

%% ïîñòğîåíèå âğåìåííûõ ãğàôèêîâ è ñïåêòğà
% plot_time_graph_and_spectrum(data_in,data_out);

data_out_from_scope=data_out;
%% ÏÎËÓ×ÅÍÈÅ ÊÎİÔÔÈÖÈÅÍÒÎÂ ÄËß ÌÎÄÅËÈ ÓÑÈËÈÒÅËß
a_coef = fit_memory_poly_model(data_in(1:length(data_out)),data_out,PAmemory,PAorder,'MemPoly')
save(['a_coef_' num2str(APSK_ar(f)) 'APSK.mat'],'a_coef');


%% ÌÎÄÅËÈĞÎÂÀÍÈÅ ÓÑÈËÈÒÅËß ÏĞÈ ÏÎÌÎÙÈ ÌÎÄÅËÈ ÂÎËÜÒÅĞĞÀ Ñ a_coef
shag=current_dbm_ar(2)-current_dbm_ar(1);
current_dbm_ar_for_ampl_char=[current_dbm_ar(1:end) ];%current_dbm_ar(end)+shag current_dbm_ar(end)+2*shag current_dbm_ar(end)+3*shag current_dbm_ar(end)+4*shag
data_in_from_model=zeros(0,0);
data_out_from_model=zeros(0,0);

for i=1:1:length(current_dbm_ar_for_ampl_char)
    load(['a_coef_' num2str(APSK_ar(f)) 'APSK.mat'],'a_coef');
    clear simin
    %% ÇÀÃĞÓÆÀÅÌ ÈÄÅÀËÜÍÛÅ ñèìâîëû
    load([dir '\amplifier_usil_mal\' num2str(APSK_ar(f)) 'APSK_ref_symb_timeseries.mat']);
    %     load(['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier_usil_mal\' num2str(APSK_ar(f)) 'APSK_ref_symb_timeseries.mat']);
    
    simin.time=(0:ARBitrary_TRIGger_SLENgth*4-1)';
    simin.data=ref_sym_symbols.data(1:ARBitrary_TRIGger_SLENgth);
    %% ÌÀÑØÒÀÁÈĞÓÅÌ ÏÎÄ ÇÀÄÀÍÍÓŞ ÌÎÙÍÎÑÒÜ
    simin.data = tx_filter(simin.data(:));
    simin.data=scale_power(simin.data(18 + data_offset_range : 1.5e4),current_dbm_ar_for_ampl_char,i);
    simin=timeseries(simin.data,simin.time(1:length(simin.data)));
    sim('MP_model.slx');
    
    %% ÇÀÏÈÑÛÂÀÅÌ ÂÕÎÄÍÓŞ È ÂÛÕÎÄÍÓŞ ÌÎÙÍÎÑÒÜ Â ÌÀÑÑÈÂ
    data_in_ar_power_after_filt_iq(i)=10*log10(mean(abs(simin.data).^2)/1e-3);
    data_out_ar_power_after_filt_iq(i)=10*log10(mean(abs(out_sig_wo_dpd_wo_filt(1:length(simin.data)).^2)/1e-3));
    %% îáúåäèíåíèå ìàññèâîâ âûõîäíûõ äàííûõ
    data_in_from_model=[data_in_from_model(:); simin.data];
    data_out_from_model=[ data_out_from_model(:); out_sig_wo_dpd_wo_filt(1:length(simin.data)) ];
    
%     figure;
%     plot(real(simin.data));
%     hold on
%     plot(real(out_sig_wo_dpd_wo_filt(1:length(simin.data))));
end
% plot_time_graph_and_spectrum(data_in_from_model,data_out_from_model);
compare_constellations(data_out_from_model,data_out);
figure;
plot(real(data_out_from_model));
hold on
plot(real(data_out));


figure;
plot(data_in_ar_power_after_filt_iq,data_out_ar_power_after_filt_iq);
hold on
plot(input_ar.d,output_ar.d);
legend('model','meas');