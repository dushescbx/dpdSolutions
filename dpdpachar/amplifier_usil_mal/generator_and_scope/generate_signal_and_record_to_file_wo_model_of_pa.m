%% ÏĞÅÄÛÑÊÀÆÅÍÈß ÂÛÊËŞ×ÅÍÛ
DPD_on_off=false;
%% ÓÑÈËÈÒÅËÜ ÏÎÄÊËŞ×ÅÍ
PA_ON=false;
%% ÒÅÑÒÈĞÓÅÌÛÅ ÑÎÇÂÅÇÄÈß


%% ÑÁĞÎÑ ÃÅÍÅĞÀÒÎĞÀ È ÀÍÀËÈÇÀÒÎĞÀ
% generator.RawIO.Write(char('*RST'));
% scope.RawIO.Write(char('*RST'));

%% ÏĞÅÎÁĞÀÇÓÅÌ 1 0 Â TRUE FALSE
if DPD_on_off==1
    dpd_or_not_dpd_text='True';
else
    dpd_or_not_dpd_text='False';
end
%% ÓÆÅ ÁÛËÎ ÂÑÏËÛÂÀŞÙÅÅ ÎÊÍÎ
quest_dlg_ind=0;

for PA_ON = [ true ]% false
    %% ÏĞÅÎÁĞÀÇÓÅÌ 1 0 Â TRUE FALSE
    if PA_ON==1
        PA_ON_text='True';
    else
        PA_ON_text='False';
    end
    % % %     shag_tcikla_power=2;% øàã èçìåíåíèÿ ìîùíîñòè
    % % %     current_dbm_ar=0:shag_tcikla_power:10
    for l = 1:1:length(APSK_ar)
        f=1;
        
        %% ÑÎÇÄÀÅÌ ÔÀÉË ÄËß ÇÀÏÈÑÈ ÇÍÀ×ÅÍÈÉ ÌÎÙÍÎÑÒÈ
        fid_outp=fopen(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts_wo_model\output_input_signals\_output_power_arr_' ...
            num2str(APSK_ar(l))  'APSK_pa_on_=' PA_ON_text '_dpd_on='  dpd_or_not_dpd_text   '.txt'],'w');
        k=1;
        
        
        
        
        clear scpi_comms_for_scope_ar scpi_comms_for_generator_ar;
        %% ÃÅÍÅĞÈĞÓÅÌ ÊÎÌÀÍÄÛ ÄËß ÃÅÍÅĞÀÒÎĞÀ È ÀÍÀËÈÇÀÒÎĞÀ
        scpi_comms_for_scope_ar=scpi_coms_for_scope_settings(APSK_ar(l));
        scpi_comms_for_generator_ar=scpi_coms_for_generator_settings(APSK_ar(l));
        
        %% ÏÎÑÛËÀÅÌ ÊÎÌÀÍÄÛ ÍÀ ÃÅÍÅĞÀÒÎĞ
        for i=1:1:length(scpi_comms_for_generator_ar)
            generator.RawIO.Write(char(scpi_comms_for_generator_ar(i)));
            disp((scpi_comms_for_generator_ar(i)));
        end
        %% ÏÎÑÛËÀÅÌ ÊÎÌÀÍÄÛ ÍÀ ÀÍÀËÈÇÀÒÎĞ
        for i=1:1:length(scpi_comms_for_scope_ar)
            scope.RawIO.Write(char(scpi_comms_for_scope_ar(i)));
            disp(char(scpi_comms_for_scope_ar(i)));
        end
        
        
        
        
        
        clear scpi_comms_for_scope_ar scpi_comms_for_generator_ar output_array;
        
        %% ÏÎÑÛËÀÅÌ ÑÈÃÍÀË ĞÀÇÍÎÉ ÌÎÙÍÎÑÒÈ
        shag_tcikla_power=1;% øàã èçìåíåíèÿ ìîùíîñòè
        c0=complex(1,1)*init_coef;
        for iter=1:30
            for current_dbm=15:shag_tcikla_power:15
                current_dbm_ar(k)=current_dbm;
                k=k+1;
                
                %% ÌÅÑÒÎ ÑÎÕĞÀÍÅÍÈß ÔÀÉËÎÂ ÑÎÇÂÅÇÄÈÉ Ñ ÀÍÀËÈÇÀÒÎĞÀ
                save_file_name = strcat("'C:\Temp\_"  , num2str(APSK_ar(l)) , "APSK" , num2str(current_dbm) , "dbm_DPD_on=" , dpd_or_not_dpd_text , "_pa_on=" , PA_ON_text);
                
                %% ÃÅÍÅĞÈĞÓÅÌ ÊÎÌÀÍÄÛ ÄËß ÃÅÍÅĞÀÒÎĞÀ È ÀÍÀËÈÇÀÒÎĞÀ
                scpi_comms_for_scope_ar=scpi_coms_for_scope_variable(save_file_name);
                scpi_comms_for_generator_ar=scpi_coms_for_generator_variable(current_dbm);
                
                %% ÏÎÑÛËÀÅÌ ÊÎÌÀÍÄÛ ÍÀ ÃÅÍÅĞÀÒÎĞ
                for i=1:1:length(scpi_comms_for_generator_ar)
                    generator.RawIO.Write(char(scpi_comms_for_generator_ar(i)));
                    disp((scpi_comms_for_generator_ar(i)));
                end
                %% ÏÎÑÛËÀÅÌ ÊÎÌÀÍÄÛ ÍÀ ÀÍÀËÈÇÀÒÎĞ
                for i=1:1:length(scpi_comms_for_scope_ar)
                    pause(0.1)
                    scope.RawIO.Write(char(scpi_comms_for_scope_ar(i)));
                    %% ÅÑËÈ Â ÊÎÌÀÍÄÅ
                    if contains(scpi_comms_for_scope_ar(i),'?')
                        output_array=str2double(string(char(scope.RawIO.ReadString())))
                        
                    end
                    disp(char(scpi_comms_for_scope_ar(i)));
                end
                %% ñ÷èòûâàíèå ñîçâåçäèé èç àíàëèçàòîğà
                status=copyfile(['\\FSW26-104146\Temp\_' num2str(APSK_ar(l)) 'APSK' num2str(current_dbm) 'dbm_DPD_on=' dpd_or_not_dpd_text '_pa_on=' PA_ON_text '.JPEG'],...
                    ['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts_wo_model\output_input_signals\_' num2str(APSK_ar(l)) 'APSK' num2str(current_dbm) 'dbm_DPD_on=' dpd_or_not_dpd_text '_pa_on=' PA_ON_text '.jpeg']);
                status=copyfile(['\\FSW26-104146\Temp\_' num2str(APSK_ar(l)) 'APSK' num2str(current_dbm) 'dbm_DPD_on=' dpd_or_not_dpd_text '_pa_on=' PA_ON_text '_raw.dat'],...
                    ['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts_wo_model\output_input_signals\_' num2str(APSK_ar(l)) 'APSK' num2str(current_dbm) 'dbm_DPD_on=' dpd_or_not_dpd_text '_pa_on=' PA_ON_text '_raw.dat']);
                status=copyfile(['\\FSW26-104146\Temp\_' num2str(APSK_ar(l)) 'APSK' num2str(current_dbm) 'dbm_DPD_on=' dpd_or_not_dpd_text '_pa_on=' PA_ON_text '_trace.dat'],...
                    ['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts_wo_model\output_input_signals\_' num2str(APSK_ar(l)) 'APSK' num2str(current_dbm) 'dbm_DPD_on=' dpd_or_not_dpd_text '_pa_on=' PA_ON_text '_trace.dat']);
                status=copyfile(['\\FSW26-104146\Temp\_' num2str(APSK_ar(l)) 'APSK' num2str(current_dbm) 'dbm_DPD_on=' dpd_or_not_dpd_text '_pa_on=' PA_ON_text '_iq.iq.tar'],...
                    ['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts_wo_model\output_input_signals\_' num2str(APSK_ar(l)) 'APSK' num2str(current_dbm) 'dbm_DPD_on=' dpd_or_not_dpd_text '_pa_on=' PA_ON_text '_iq.iq.tar']);
                %% ÏĞÅÎÁĞÀÇÎÂÀÍÈÅ DAT â MAT
                conv_pames_FSW_dat(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts_wo_model\output_input_signals\_' num2str(APSK_ar(l)) ...
                    'APSK' num2str(current_dbm) 'dbm_DPD_on=' dpd_or_not_dpd_text '_pa_on=' PA_ON_text '_raw.dat'])
                %% ÏĞÅÎÁĞÀÇÎÂÀÍÈÅ DAT â MAT
                conv_pames_FSW_dat(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts_wo_model\output_input_signals\_' num2str(APSK_ar(l)) ...
                    'APSK' num2str(current_dbm) 'dbm_DPD_on=' dpd_or_not_dpd_text '_pa_on=' PA_ON_text '_trace.dat'])
                iq_data=load_iq_tar_file(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\_' num2str(APSK_ar(l)) 'APSK' num2str(current_dbm) 'dbm_DPD_on=' dpd_or_not_dpd_text '_pa_on=' PA_ON_text '_iq.iq.tar']);
                save(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts_wo_model\output_input_signals\_' num2str(APSK_ar(l)) 'APSK' num2str(current_dbm) 'dbm_DPD_on=' dpd_or_not_dpd_text '_pa_on=' PA_ON_text '_iq.mat'],'iq_data');
                f=f+1;
            end
            %% ÇÀÏÈÑÜ Â ÔÀÉË ÂÛÕÎÄÍÛÕ ÇÍÀ×ÅÍÈÉ ÌÎÙÍÎÑÒÈ
            fprintf(fid_outp,'%+2.4f\n',output_array);
            fclose(fid_outp);
            %% ÏĞÅÎÁĞÀÇÎÂÀÍÈÅ TXT Â MAT
            conv_data_from_FSW(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts_wo_model\output_input_signals\_output_power_arr_' ...
                num2str(APSK_ar(l))  'APSK_pa_on_=' PA_ON_text '_dpd_on='  dpd_or_not_dpd_text   '.txt']);
            %% ÑÎÇÄÀÅÌ ÔÀÉË ÄËß ÇÀÏÈÑÈ ÂÕÎÄÍÎÉ ÌÎÙÍÎÑÒÈ
            fid_inp=fopen(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts_wo_model\output_input_signals\_input_power_arr_' ...
                num2str(APSK_ar(l))  'APSK_pa_on_=' PA_ON_text '_dpd_on='  dpd_or_not_dpd_text   '.txt'],'w');
            fprintf(fid_inp,'%+2.4f\n',current_dbm_ar);
            fclose(fid_inp);
            input_ar=load(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts_wo_model\output_input_signals\_input_power_arr_'...
                num2str(APSK_ar(l)) 'APSK_pa_on_=True_dpd_on=False.txt.mat']);
            output_ar=load(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts_wo_model\output_input_signals\_output_power_arr_'...
                num2str(APSK_ar(l)) 'APSK_pa_on_=True_dpd_on=False.txt.mat']);
            %% ÏĞÅÎÁĞÀÇÎÂÀÍÈÅ TXT Â MAT
            conv_data_from_FSW(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts_wo_model\output_input_signals\_input_power_arr_' ...
                num2str(APSK_ar(l))  'APSK_pa_on_=' PA_ON_text '_dpd_on='  dpd_or_not_dpd_text   '.txt']);
            
            
            
            load(['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier_usil_mal\' num2str(APSK_ar(l)) 'APSK_ref_symb_timeseries.mat']);
            data_in_ADD=ref_sym1.data(1:40000);
            %% ÌÀÑØÒÀÁÈĞÓÅÌ Â ÑÎÎÒÂÅÒÑÒÂÈÈ Ñ ÂÕÎÄÍÎÉ ÌÎÙÍÎÑÒÜŞ
            av_input_power=mean(abs(data_in_ADD).^2);
            av_input_power_expected=1e-3*10^((current_dbm)/10);
            diff=av_input_power_expected/av_input_power;%íà ñêîëüêî äáì èçìåíèòü âõîäíîé ñèãíàë
            data_in_ADD=data_in_ADD*sqrt(diff);
            av_input_power=10*log10(mean(abs(data_in_ADD).^2/1e-3));
            simin=timeseries(data_in_ADD,ref_sym1.time(1:40000));
            scatterplot(simin.data);
            
            
            %% ÇÀÃĞÓÆÀÅÌ ñèìâîëû Ñ×ÈÒÀÍÍÛÅ ÈÇ ÀÍÀËÈÇÀÒÎĞÀ
            load(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts_wo_model\output_input_signals\_' num2str(APSK_ar(l)) 'APSK'  num2str(current_dbm) 'dbm_DPD_on=False_pa_on=True_trace.dat.mat'])
            data_out_ADD=simin.data;
            length_of_data=length(data_out_ADD);
            
            %% ÌÀÑØÒÀÁÈĞÓÅÌ Â ÑÎÎÒÂÅÒÑÒÂÈÈ Ñ ÂÛÕÎÄÍÎÉ ÌÎÙÍÎÑÒÜŞ
            av_output_power=mean(abs(data_out_ADD).^2);
            av_output_power_expected=1e-3*10^(output_array/10);
            diff=av_output_power_expected/av_output_power;%íà ñêîëüêî äáì èçìåíèòü âõîäíîé ñèãíàë
            simin.data=data_out_ADD*sqrt(diff);
            av_output_power=10*log10(mean(abs(data_out_ADD).^2/1e-3));
            pa_out=timeseries(simin.data,simin.time);
            scatterplot(pa_out.data);
            sim('dpd_static_verify_wo_model_of_pa.slx');
        c0=coef_of_dpd(:,1,end);
        
        
        
         %% ÑÎÕĞÀÍÅÍÈÅ ÏĞÅÄÛÑÊÀÆÅÍÍÛÕ ÑÈÌÂÎËÎÂ
        sym_after_dpd_save=sym_after_dpd1(length(sym_after_dpd1)/2:length(sym_after_dpd1)-1);
        save(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts_wo_model\output_input_signals\_sym_after_dpd_av_pow=' num2str(current_dbm) '_' num2str(APSK_ar(l)) '_APSK.mat'],'sym_after_dpd_save');
        %% ÑÎÇÄÀÅÌ MAT ÔÀÉË Ñ I Q fc, äëÿ êîíâåğòàöèè mat â wv ôîğìàò
        I=real(sym_after_dpd_save);
        Q=imag(sym_after_dpd_save);
        fc=1e8;
        save(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts_wo_model\output_input_signals\_' num2str(APSK_ar(ap)) 'APSK_sym_after_dpd_av_pow=' num2str(current_dbm) '.mat'],'I','Q','fc');
        scatterplot(sym_after_dpd1)
        filename=['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts_wo_model\output_input_signals\_' num2str(APSK_ar(ap)) 'APSK_sym_after_dpd_av_pow=' num2str(current_dbm) '.mat'];
        Convert_Mat2Wv_function(filename);
        ftp_connect_and_download_to_gen(APSK_ar(l),false,current_dbm);

        
        
        
        
        end
        %% ÑÎÇÄÀÅÌ ÄÈÀËÎÃÎÂÎÅ ÎÊÍÎ
        %     if quest_dlg_ind==0
        %         quest_dlg_ind=1;
        %         promptMessage = sprintf('Ïîäêëş÷èòå óñèëèòåëü');
        %         button = questdlg(promptMessage,'','Ïğîäîëæèòü?','Äà');
        %     end
    end
end
%% ÑÁĞÎÑ ÃÅÍÅĞÀÒÎĞÀ È ÀÍÀËÈÇÀÒÎĞÀ
generator.RawIO.Write(char('*RST'));
scope.RawIO.Write(char('*RST'));
generator.Clear();
scope.Clear();
