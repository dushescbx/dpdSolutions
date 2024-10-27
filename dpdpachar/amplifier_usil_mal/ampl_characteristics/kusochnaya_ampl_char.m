for f=1:1:length(APSK_ar)
    figure(f1);
    data_in_ar_power_for_plot=zeros(0,0);
    data_out_ar_power_for_plot=zeros(0,0);
    data_in=zeros(0,0);
    data_out=zeros(0,0);
    data_out_from_model=zeros(0,0);
    data_out_from_scope=zeros(0,0);
    data_offset_range = 400;
    shag_tcikla_power = 1;
    for k=1:1:length(input_ar.d)
        %% çàãğóçêà âõîäíûõ äàííûõ
        data_in=zeros(0,0);
        data_out=zeros(0,0);
        %% ÏÎÄÀÅÌ ÍÀ ÂÕÎÄ ÈÄÅÀËÜÍÛÅ ñèìâîëû
        load([dir '\amplifier_usil_mal\' num2str(APSK_ar(f)) 'APSK_ref_symb_timeseries.mat']);
        %      load(['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier_usil_mal\' num2str(APSK_ar(f)) 'APSK_ref_symb_timeseries.mat']);
        data_in_ADD=ref_sym_symbols.data(1:ARBitrary_TRIGger_SLENgth);
        %         scatterplot(data_in_ADD);
        data_in_ADD = tx_filter(data_in_ADD(:));
        data_in_ADD=scale_power(data_in_ADD,input_ar.d,k);
        
        
        
        
        %% îáúåäèíåíèå ÂÕÎÄÍÛÕ ÑÎÇÂÅÇÄÈÉ ĞÀÇÍÎÉ ÌÎÙÍÎÑÒÈ;
        
        data_in=[data_in; data_in_ADD(18 + data_offset_range : length(data_in_ADD))];
        
        %% ÇÀÃĞÓÆÀÅÌ ñèìâîëû Ñ×ÈÒÀÍÍÛÅ ÈÇ ÀÍÀËÈÇÀÒÎĞÀ
        load([dir '\ampl_scripts\output_input_signals\_' num2str(APSK_ar(f)) 'APSK'  num2str(input_ar.d(k)) 'dbm_DPD_on=False_pa_on=True_trace.dat.mat'])
        %     load([dir '\ampl_scripts\output_input_signals\_' num2str(APSK_ar(f)) 'APSK'  num2str(input_ar.d(i)) 'dbm_DPD_on=False_pa_on=True_trace.dat.mat'])
        
        %      load(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\_' num2str(APSK_ar(f)) 'APSK'  num2str(input_ar.d(i)) 'dbm_DPD_on=False_pa_on=True_trace.dat.mat'])
        
        data_out_ADD=simin.data(6:end);
        %     scatterplot(simin.data);
        %     title('trace data');
        %% ÌÀÑØÒÀÁÈĞÓÅÌ Â ÑÎÎÒÂÅÒÑÒÂÈÈ Ñ ÂÛÕÎÄÍÎÉ ÌÎÙÍÎÑÒÜŞ
        data_out_ADD = tx_filter(data_out_ADD(:));
        data_out_ADD=scale_power(data_out_ADD(18 + data_offset_range:length(data_in_ADD)),output_ar.d,k);
        
        %% îáúåäèíåíèå ìàññèâîâ âûõîäíûõ äàííûõ
        data_out=[ data_out(:); data_out_ADD ];
        %         scatterplot(data_out_ADD);
        
        
        %% ÏÎËÓ×ÅÍÈÅ ÊÎİÔÔÈÖÈÅÍÒÎÂ ÄËß ÌÎÄÅËÈ ÓÑÈËÈÒÅËß
        data_out_from_scope=data_out;
        a_coef = fit_memory_poly_model(data_in(1:length(data_out)),data_out,PAmemory,PAorder,'MemPoly');
        save(['a_coef_' num2str(APSK_ar(f)) 'APSK_kusochn.mat'],'a_coef');
        figure;
        plot(real(data_in));
        hold on
        plot(real(data_out));
        
        power_in_point_plus_minus_polovina=[ current_dbm_ar(k)-shag_tcikla_power/2 current_dbm_ar(k) current_dbm_ar(k)+shag_tcikla_power/2];
        clear data_in_ar_power data_out_ar_power
        for i=1:1:length(power_in_point_plus_minus_polovina)
            load(['a_coef_' num2str(APSK_ar(f)) 'APSK_kusochn.mat'],'a_coef');
            clear simin
            %% ÇÀÃĞÓÆÀÅÌ ÈÄÅÀËÜÍÛÅ ñèìâîëû
            load([dir '\amplifier_usil_mal\' num2str(APSK_ar(f)) 'APSK_ref_symb_timeseries.mat']);
            %     load(['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier_usil_mal\' num2str(APSK_ar(f)) 'APSK_ref_symb_timeseries.mat']);
            
            simin.time=(0:ARBitrary_TRIGger_SLENgth*4-1)';
            simin.data=ref_sym_symbols.data(1:ARBitrary_TRIGger_SLENgth);
            %% ÌÀÑØÒÀÁÈĞÓÅÌ ÏÎÄ ÇÀÄÀÍÍÓŞ ÌÎÙÍÎÑÒÜ
            simin.data = tx_filter(simin.data(:));
            simin.data=scale_power(simin.data(18 + data_offset_range:end),power_in_point_plus_minus_polovina,i);
            simin=timeseries(simin.data,simin.time(1:length(simin.data)));
            sim('MP_model.slx');
            %% ÇÀÏÈÑÛÂÀÅÌ ÂÕÎÄÍÓŞ È ÂÛÕÎÄÍÓŞ ÌÎÙÍÎÑÒÜ Â ÌÀÑÑÈÂ
            %             data_in_ar_power(i)=mean(abs(data_in)).^2;
            %             data_out_ar_power(i)=mean(abs(data_out)).^2;
            %
            
            data_out_ar_power(i)=mean(abs(out_sig_wo_dpd(11:end))).^2;
            data_in_ar_power(i)=mean(abs(simin.data(1:length(out_sig_wo_dpd)))).^2;
            
            figure;
            plot(real(out_sig_wo_dpd(11:end)));
            hold on
            plot(real(simin.data(1:length(out_sig_wo_dpd))));
        end
        data_in_ar_power_for_plot = [data_in_ar_power_for_plot(:) ; data_in_ar_power(:)];
        data_out_ar_power_for_plot = [data_out_ar_power_for_plot(:) ; data_out_ar_power(:)];
        %         plot(10*log10(data_in_ar_power/1e-3),10*log10(data_out_ar_power/1e-3),'-o');%
        %         hold on;
        
    end
    %     plot(input_ar.d,output_ar.d);
    hold on;
    plot(10*log10(data_in_ar_power_for_plot/1e-3),10*log10(data_out_ar_power_for_plot/1e-3),'-o');%
    
end