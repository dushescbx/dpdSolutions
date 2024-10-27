%% ÌÎÄÅËÜ Ñ ÑÈÌÂÎËÀÌÈ(ÏÎÑËÅ ÔÈËÜÒĞÀ)

run('download_power_arrays.m');
data_in=zeros(0,0);
data_out=zeros(0,0);
data_out_from_model=zeros(0,0);
data_out_from_scope=zeros(0,0);
for i=1:1:length(input_ar.d)
    
    %% çàãğóçêà âõîäíûõ äàííûõ
    
%     %% ÏÎÄÀÅÌ ÍÀ ÂÕÎÄ ÈÄÅÀËÜÍÛÅ ñèìâîëû
%     load(['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier_usil_mal\' num2str(APSK_ar(f)) 'APSK_ref_symb_timeseries.mat']);
%     data_in_ADD=ref_sym_symbols.data(1:ARBitrary_TRIGger_SLENgth);
%     %         scatterplot(data_in_ADD);
%     data_in_ADD=scale_power(data_in_ADD(:),input_ar.d,i);
%     
%  
%     %% îáúåäèíåíèå ÂÕÎÄÍÛÕ ÑÎÇÂÅÇÄÈÉ ĞÀÇÍÎÉ ÌÎÙÍÎÑÒÈ;
    
%     data_in=[data_in; data_in_ADD(1:length(data_in_ADD)-17)];
      %% çàãğóçêà âõîäíûõ äàííûõ
    
    %% ÏÎÄÀÅÌ ÍÀ ÂÕÎÄ ÈÄÅÀËÜÍÛÅ îòñ÷åòû ïîñëå ïåğåäàşùåãî ôèëüòğà
    load(['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier_usil_mal\_' num2str(APSK_ar(f)) 'APSK_ref_symb_after_filter.mat']);
    data_in_ADD=ref_sym;
    %% ÌÀÑØÒÀÁÈĞÓÅÌ Â ÑÎÎÒÂÅÒÑÒÂÈÈ Ñ ÂÕÎÄÍÎÉ ÌÎÙÍÎÑÒÜŞ
    data_in_ADD=scale_power(data_in_ADD,input_ar.d,i);
    
    %         scatterplot(data_in_ADD);
    %% îáúåäèíåíèå ÂÕÎÄÍÛÕ ñèìâîëîâ IQ ĞÀÇÍÎÉ ÌÎÙÍÎÑÒÈ;
    
    data_in=[data_in; data_in_ADD(18:4*ARBitrary_TRIGger_SLENgth)];
      
    

    
    %% ÇÀÃĞÓÆÀÅÌ ñèìâîëû Ñ×ÈÒÀÍÍÛÅ ÈÇ ÀÍÀËÈÇÀÒÎĞÀ
    load(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\_' num2str(APSK_ar(f)) 'APSK'  num2str(input_ar.d(i)) 'dbm_DPD_on=False_pa_on=True_raw.dat.mat'])
    data_out_ADD=simin.data;
%             scatterplot(simin.data);
    %% ÌÀÑØÒÀÁÈĞÓÅÌ Â ÑÎÎÒÂÅÒÑÒÂÈÈ Ñ ÂÛÕÎÄÍÎÉ ÌÎÙÍÎÑÒÜŞ
    data_out_ADD=scale_power(data_out_ADD(:),output_ar.d,i);
    
    %% îáúåäèíåíèå ìàññèâîâ âûõîäíûõ äàííûõ
    data_out=[ data_out(:); data_out_ADD(18:length(data_in_ADD)) ];
    %         scatterplot(data_out_ADD);
    
    
    
    
end

%% ïîñòğîåíèå âğåìåííûõ ãğàôèêîâ è ñïåêòğà
plot_time_graph_and_spectrum(data_in,data_out);

data_out_from_scope=data_out;
%% ÏÎËÓ×ÅÍÈÅ ÊÎİÔÔÈÖÈÅÍÒÎÂ ÄËß ÌÎÄÅËÈ ÓÑÈËÈÒÅËß
a_coef = fit_memory_poly_model(data_in(1:length(data_out)),data_out,PAmemory,PAorder,'MemPoly')
save(['a_coef_' num2str(APSK_ar(f)) 'APSK_raw.mat'],'a_coef');


%% ÌÎÄÅËÈĞÎÂÀÍÈÅ ÓÑÈËÈÒÅËß ÏĞÈ ÏÎÌÎÙÈ ÌÎÄÅËÈ ÂÎËÜÒÅĞĞÀ Ñ a_coef
shag=current_dbm_ar(2)-current_dbm_ar(1);
current_dbm_ar_for_ampl_char=[current_dbm_ar(1:end) ];%current_dbm_ar(end)+shag current_dbm_ar(end)+2*shag current_dbm_ar(end)+3*shag current_dbm_ar(end)+4*shag
data_in_from_model=zeros(0,0);
data_out_from_model=zeros(0,0);

for i=1:1:length(current_dbm_ar_for_ampl_char)
    load(['a_coef_' num2str(APSK_ar(f)) 'APSK_raw.mat'],'a_coef');
     clear simin
    %% ÇÀÃĞÓÆÀÅÌ ÈÄÅÀËÜÍÛÅ ñèìâîëû
    load(['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier_usil_mal\_' num2str(APSK_ar(f)) 'APSK_ref_symb_after_filter.mat']);
    simin.data=ref_sym(18:4e4-2,1);
    simin.time=0:length(simin.data)-1;
    
    %% ÌÀÑØÒÀÁÈĞÓÅÌ ÏÎÄ ÇÀÄÀÍÍÓŞ ÌÎÙÍÎÑÒÜ
    simin.data=scale_power(simin.data,current_dbm_ar_for_ampl_char,i);
    simin=timeseries(simin.data,simin.time);
    
    sim('dpd_static_verify_simin_data_no_filter.slx');
    %% ÇÀÏÈÑÛÂÀÅÌ ÂÕÎÄÍÓŞ È ÂÛÕÎÄÍÓŞ ÌÎÙÍÎÑÒÜ Â ÌÀÑÑÈÂ
    data_in_ar_power(i)=mean(abs(data_in)).^2;
    data_out_ar_power(i)=mean(abs(data_out_model)).^2;
    
    data_out_from_model=[ data_out_from_model(:); data_out_model(1:4*ARBitrary_TRIGger_SLENgth) ];
    data_in_from_model=[data_in_from_model; ref_sym(18:4e4-2,1)];
    %% îáúåäèíåíèå ìàññèâîâ äàííûõ
    data_in_ar=[ data_in_ar(:); data_in(1:4e4)];
    data_out=[ data_out(:); data_out_model(1:4e4) ];
end
    

plot_time_graph_and_spectrum(data_in_from_model,data_out_from_model);
compare_constellations(data_out_from_model,data_out);
%     data_out_from_model=data_out_from_model(11:end);
%     data_out_from_scope=data_out_from_scope(6:end);
