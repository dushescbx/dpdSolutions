    %% ÌÎÄÅËÜ Ñ ÑÈÍÓÑÎÈÄÎÉ(ÏÎÑËÅ ÔÈËÜÒĞÀ)
    
    
    data_in=zeros(0,0);
    data_out=zeros(0,0);
    data_out_from_model=zeros(0,0);
    data_out_from_scope=zeros(0,0);
    for i=1:1:length(input_ar.d)
        
        
        
        
        %         save(['a_coef_' num2str(APSK_ar(f)) 'APSK.mat'],'a_coef');
        
        
        %% ÌÎÄÅËÈĞÎÂÀÍÈÅ ÓÑÈËÈÒÅËß ÏĞÈ ÏÎÌÎÙÈ ÌÎÄÅËÈ ÂÎËÜÒÅĞĞÀ Ñ a_coef
        shag=current_dbm_ar(2)-current_dbm_ar(1);
        current_dbm_ar_for_ampl_char=[current_dbm_ar(1:end) ];%current_dbm_ar(end)+shag current_dbm_ar(end)+2*shag current_dbm_ar(end)+3*shag current_dbm_ar(end)+4*shag
        data_in=zeros(0,0);
        data_out=zeros(0,0);
        
        for l=1:1:length(current_dbm_ar_for_ampl_char)
            %             load(['a_coef_' num2str(APSK_ar(f)) 'APSK.mat'],'a_coef');
            load(['a_coef_' num2str(APSK_ar(f)) 'APSK_otscheti.mat'],'a_coef');
            clear simin
            %% ÇÀÃĞÓÆÀÅÌ ÈÄÅÀËÜÍÛÅ ñèìâîëû
            simin.time=0:1:100000-1;
            simin.data(1:100000,1)=complex(1,0);          
            simin.data=scale_power(simin.data,current_dbm_ar_for_ampl_char,l);
            
            sim('dpd_static_verify_01_04_find_opt_volterra_simin_data_sine.slx');
            %% ÇÀÏÈÑÛÂÀÅÌ ÂÕÎÄÍÓŞ È ÂÛÕÎÄÍÓŞ ÌÎÙÍÎÑÒÜ Â ÌÀÑÑÈÂ
            
            data_in_ar_power_after_filt(l)=mean(abs(simin.data)).^2;
            data_out_ar_power_after_filt(l)=mean(abs(out_sig_wo_dpd(11:length_of_data+11-6))).^2;
            %% îáúåäèíåíèå ìàññèâîâ âûõîäíûõ äàííûõ
            data_out_from_model=[ data_out_from_model(:); out_sig_wo_dpd(11:length_of_data+11-6) ];
            
            
            
            %         data_in_ar_power(i)=mean(abs(simin.data)).^2;
            %         data_out_ar_power(i)=mean(abs(out_sig_wo_dpd(11:end))).^2;
        end
        
    end
    