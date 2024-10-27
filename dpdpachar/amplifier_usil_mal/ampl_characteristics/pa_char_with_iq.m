% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%% ÌÎÄÅËÜ Ñ îòñ÷åòàìè(äî ÔÈËÜÒĞÀ)


data_in=zeros(0,0);
data_out=zeros(0,0);
for i=1:1:length(input_ar.d)
    
    %% çàãğóçêà âõîäíûõ äàííûõ
    
    %% ÏÎÄÀÅÌ ÍÀ ÂÕÎÄ ÈÄÅÀËÜÍÛÅ îòñ÷åòû ïîñëå ïåğåäàşùåãî ôèëüòğà
    load(['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier_usil_mal\_' num2str(APSK_ar(f)) 'APSK_ref_symb_after_filter.mat']);
    data_in_ADD=ref_sym;
    %% ÌÀÑØÒÀÁÈĞÓÅÌ Â ÑÎÎÒÂÅÒÑÒÂÈÈ Ñ ÂÕÎÄÍÎÉ ÌÎÙÍÎÑÒÜŞ
    data_in_ADD=scale_power(data_in_ADD(18:4e4-3),input_ar.d,i);
    
    %         scatterplot(data_in_ADD);
    %% îáúåäèíåíèå ÂÕÎÄÍÛÕ ñèìâîëîâ IQ ĞÀÇÍÎÉ ÌÎÙÍÎÑÒÈ;
    
    data_in=[data_in; data_in_ADD];
    
    %% ÇÀÃĞÓÆÀÅÌ ñèìâîëû Ñ×ÈÒÀÍÍÛÅ ÈÇ ÀÍÀËÈÇÀÒÎĞÀ
    load(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\_' num2str(APSK_ar(f)) 'APSK'  num2str(input_ar.d(i)) 'dbm_DPD_on=False_pa_on=True_iq.mat']);
    data_out_ADD=iq_data;
    data_out_ADD=data_out_ADD((162:length(data_in_ADD)+161));
    %
    data_out_ADD = conv_unsync_iq_to_sync(APSK_ar(f), input_ar.d(i), data_out_ADD);

    data_out_ADD=scale_power(data_out_ADD,output_ar.d,i);
    
    %% îáúåäèíåíèå ìàññèâîâ âûõîäíûõ äàííûõ
    data_out = [ data_out(:); data_out_ADD ];
    data_out_from_scope = data_out;
    
    if (i==length(input_ar.d))
        scatterplot(data_in_ADD);
        scatterplot(data_out_ADD);
    end
    %% ñäâèã îòñ÷åòîâ
    %                 sdvig_otschetov(data_out_ADD(146:145+4e4));
end

figure;
plot(abs(xcorr(data_in,data_out)));

%% ïîñòğîåíèå âğåìåííûõ ãğàôèêîâ
plot_time_graph_and_spectrum(data_in,data_out);
%% ÏÎËÓ×ÅÍÈÅ ÊÎİÔÔÈÖÈÅÍÒÎÂ ÄËß ÌÎÄÅËÈ ÓÑÈËÈÒÅËß
a_coef = fit_memory_poly_model(data_in,data_out(1:length(data_in)),PAmemory,PAorder,'MemPoly')
save(['a_coef_' num2str(APSK_ar(f)) 'APSK_otscheti.mat'],'a_coef');


%% ÌÎÄÅËÈĞÎÂÀÍÈÅ ÓÑÈËÈÒÅËß ÏĞÈ ÏÎÌÎÙÈ ÌÎÄÅËÈ ÂÎËÜÒÅĞĞÀ Ñ a_coef
shag=input_ar.d(2)-input_ar.d(1);
current_dbm_ar_for_ampl_char=[input_ar.d(1:end) ];%current_dbm_ar(end)+shag current_dbm_ar(end)+2*shag current_dbm_ar(end)+3*shag current_dbm_ar(end)+4*shag
data_in_ar=zeros(0,0);
data_out=zeros(0,0);
for i=1:1:length(current_dbm_ar_for_ampl_char)
    load(['a_coef_' num2str(APSK_ar(f)) 'APSK_otscheti.mat'],'a_coef');
    
    clear simin
    %% ÇÀÃĞÓÆÀÅÌ ÈÄÅÀËÜÍÛÅ ñèìâîëû
    load(['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier_usil_mal\_' num2str(APSK_ar(f)) 'APSK_ref_symb_after_filter.mat']);
    simin.data=ref_sym(18:4e4-3,1);
    simin.time=0:length(simin.data)-1;
    
    %% ÌÀÑØÒÀÁÈĞÓÅÌ ÏÎÄ ÇÀÄÀÍÍÓŞ ÌÎÙÍÎÑÒÜ
    simin.data=scale_power(simin.data,current_dbm_ar_for_ampl_char,i);
    simin=timeseries(simin.data,simin.time);
    
    sim('dpd_static_verify_simin_data_no_filter.slx');
    %% ÇÀÏÈÑÛÂÀÅÌ ÂÕÎÄÍÓŞ È ÂÛÕÎÄÍÓŞ ÌÎÙÍÎÑÒÜ Â ÌÀÑÑÈÂ
    data_in_ar_power(i)=mean(abs(data_in(1:4e4))).^2;
    data_out_ar_power(i)=mean(abs(data_out_model(1:4e4))).^2;
    
    
    %% îáúåäèíåíèå ìàññèâîâ äàííûõ
    data_in_ar=[ data_in_ar(:); data_in(1:4e4)];
    data_out=[ data_out(:); data_out_model(1:4e4) ];
    scatterplot(out_sig_wo_dpd);
end
plot_time_graph_and_spectrum(data_in_ar,data_out);
%     run('iq_conv_test.m');
% compare_constellations(data_out_model,data_out_from_scope);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




