for l = 1:1:length(APSK_ar)
    f=1;
    
    %% ÑÎÇÄÀÅÌ ÔÀÉË ÄËß ÇÀÏÈÑÈ ÇÍÀ×ÅÍÈÉ ÌÎÙÍÎÑÒÈ
    fid_outp=fopen(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\_output_power_arr_' ...
        num2str(APSK_ar(l))  'APSK_pa_on_=' PA_ON_text '_dpd_on='  dpd_or_not_dpd_text   '.txt'],'w');
    k=1;
    
    %% ÏÎÑÛËÀÅÌ ÑÈÃÍÀË ĞÀÇÍÎÉ ÌÎÙÍÎÑÒÈ
    shag_tcikla_power=1;% øàã èçìåíåíèÿ ìîùíîñòè
    for current_dbm=0:shag_tcikla_power:3
        current_dbm_ar(k)=current_dbm;
        k=k+1;
        
        %% ÌÅÑÒÎ ÑÎÕĞÀÍÅÍÈß ÔÀÉËÎÂ ÑÎÇÂÅÇÄÈÉ Ñ ÀÍÀËÈÇÀÒÎĞÀ
        save_file_name = strcat("'C:\Temp\_"  , num2str(APSK_ar(l)) , "APSK" , num2str(current_dbm) , "dbm_DPD_on=" , dpd_or_not_dpd_text , "_pa_on=" , PA_ON_text);
        
        %% ÃÅÍÅĞÈĞÓÅÌ ÊÎÌÀÍÄÛ ÄËß ÃÅÍÅĞÀÒÎĞÀ È ÀÍÀËÈÇÀÒÎĞÀ
        scpi_comms_for_scope_ar=scpi_coms_for_scope(save_file_name,APSK_ar(l));
        scpi_comms_for_generator_ar=scpi_coms_for_generator(save_file_name,APSK_ar(l),current_dbm);
        
        %% ÏÎÑÛËÀÅÌ ÊÎÌÀÍÄÛ ÍÀ ÃÅÍÅĞÀÒÎĞ
        for i=1:1:length(scpi_comms_for_generator_ar)
            generator.RawIO.Write(char(scpi_comms_for_generator_ar(i)));
            disp((scpi_comms_for_generator_ar(i)));
        end
        %% ÏÎÑÛËÀÅÌ ÊÎÌÀÍÄÛ ÍÀ ÀÍÀËÈÇÀÒÎĞ
        for i=1:1:length(scpi_comms_for_scope_ar)
            scope.RawIO.Write(char(scpi_comms_for_scope_ar(i)));
            %% ÅÑËÈ Â ÊÎÌÀÍÄÅ
            if contains(scpi_comms_for_scope_ar(i),'?')
                output_array(f)=str2double(string(char(scope.RawIO.ReadString())))
                
            end
            disp(char(scpi_comms_for_scope_ar(i)));
        end
        %% ñ÷èòûâàíèå ñîçâåçäèé èç àíàëèçàòîğà
        status=copyfile(['\\FSW26-104146\Temp\_' num2str(APSK_ar(l)) 'APSK' num2str(current_dbm) 'dbm_DPD_on=' dpd_or_not_dpd_text '_pa_on=' PA_ON_text '.dat'],...
            ['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\_' num2str(APSK_ar(l)) 'APSK' num2str(current_dbm) 'dbm_DPD_on=' dpd_or_not_dpd_text '_pa_on=' PA_ON_text '.jpeg']);
        status=copyfile(['\\FSW26-104146\Temp\_' num2str(APSK_ar(l)) 'APSK' num2str(current_dbm) 'dbm_DPD_on=' dpd_or_not_dpd_text '_pa_on=' PA_ON_text '.dat'],...
            ['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\_' num2str(APSK_ar(l)) 'APSK' num2str(current_dbm) 'dbm_DPD_on=' dpd_or_not_dpd_text '_pa_on=' PA_ON_text '.dat']);
        %% ÏĞÅÎÁĞÀÇÎÂÀÍÈÅ DAT â MAT
        conv_pames_FSW_dat(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\_' num2str(APSK_ar(l)) ...
            'APSK' num2str(current_dbm) 'dbm_DPD_on=' dpd_or_not_dpd_text '_pa_on=' PA_ON_text '.dat'])
        f=f+1;
    end
    %% ÇÀÏÈÑÜ Â ÔÀÉË ÂÛÕÎÄÍÛÕ ÇÍÀ×ÅÍÈÉ ÌÎÙÍÎÑÒÈ
    fprintf(fid_outp,'%+2.4f\n',output_array);
    fclose(fid_outp);
    %% ÏĞÅÎÁĞÀÇÎÂÀÍÈÅ TXT Â MAT
    conv_data_from_FSW(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\_output_power_arr_' ...
        num2str(APSK_ar(l))  'APSK_pa_on_=' PA_ON_text '_dpd_on='  dpd_or_not_dpd_text   '.txt']);
    %% ÑÎÇÄÀÅÌ ÔÀÉË ÄËß ÇÀÏÈÑÈ ÂÕÎÄÍÎÉ ÌÎÙÍÎÑÒÈ
    fid_inp=fopen(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\_input_power_arr_' ...
        num2str(APSK_ar(l))  'APSK_pa_on_=' PA_ON_text '_dpd_on='  dpd_or_not_dpd_text   '.txt'],'w');
    fprintf(fid_inp,'%+2.4f\n',current_dbm_ar);
    fclose(fid_inp);
    %% ÏĞÅÎÁĞÀÇÎÂÀÍÈÅ TXT Â MAT
    conv_data_from_FSW(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\_input_power_arr_' ...
        num2str(APSK_ar(l))  'APSK_pa_on_=' PA_ON_text '_dpd_on='  dpd_or_not_dpd_text   '.txt']);
end
%% ÑÎÇÄÀÅÌ ÄÈÀËÎÃÎÂÎÅ ÎÊÍÎ
%     if quest_dlg_ind==0
%         quest_dlg_ind=1;
%         promptMessage = sprintf('Ïîäêëş÷èòå óñèëèòåëü');
%         button = questdlg(promptMessage,'','Ïğîäîëæèòü?','Äà');
%     end
