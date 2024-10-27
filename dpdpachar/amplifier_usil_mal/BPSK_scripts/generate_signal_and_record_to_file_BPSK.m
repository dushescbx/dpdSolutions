f=1;
%% ÑÎÇÄÀÅÌ ÔÀÉË ÄËß ÇÀÏÈÑÈ ÇÍÀ×ÅÍÈÉ ÌÎÙÍÎÑÒÈ
fid_outp=fopen([directory '\ampl_scripts\output_input_signals\_output_power_arr_BPSK.txt'],'w');
k=1;
clear scpi_comms_for_scope_ar scpi_comms_for_generator_ar;
%% ÃÅÍÅĞÈĞÓÅÌ ÊÎÌÀÍÄÛ ÄËß ÃÅÍÅĞÀÒÎĞÀ È ÀÍÀËÈÇÀÒÎĞÀ
scpi_comms_for_scope_ar=scpi_coms_for_scope_settings_BPSK(2);
scpi_comms_for_generator_ar=scpi_coms_for_generator_sine_meas_BPSK_const(2);

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
for current_dbm=7:shag_tcikla_power:20
    
    current_dbm_ar(k)=current_dbm;
    k=k+1;
    
    %% ÌÅÑÒÎ ÑÎÕĞÀÍÅÍÈß ÔÀÉËÎÂ ÑÎÇÂÅÇÄÈÉ Ñ ÀÍÀËÈÇÀÒÎĞÀ
    save_file_name = strcat("'C:\Temp\_sine_meas_pa_char_power=" , num2str(current_dbm));
    
    %% ÃÅÍÅĞÈĞÓÅÌ ÊÎÌÀÍÄÛ ÄËß ÃÅÍÅĞÀÒÎĞÀ È ÀÍÀËÈÇÀÒÎĞÀ
    scpi_comms_for_scope_ar=scpi_coms_for_scope_variable_BPSK(save_file_name);
    scpi_comms_for_generator_ar=scpi_coms_for_generator_sine_meas_BPSK_var(current_dbm);
    
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
            output_array(f)=str2double(string(char(scope.RawIO.ReadString())))
            
        end
        disp(char(scpi_comms_for_scope_ar(i)));
    end
    %% ñ÷èòûâàíèå ñîçâåçäèé èç àíàëèçàòîğà
    status=copyfile(['\\FSW26-104146\Temp\_sine_meas_pa_char_power=' num2str(current_dbm) '.JPEG'],...
        [directory '\ampl_scripts\output_input_signals\_BPSK_pow=' num2str(current_dbm) '.jpeg']);
    status=copyfile(['\\FSW26-104146\Temp\_sine_meas_pa_char_power=' num2str(current_dbm) '_raw.dat'],...
        [directory '\ampl_scripts\output_input_signals\_BPSK_pow=' num2str(current_dbm) '_raw.dat']);
        status=copyfile(['\\FSW26-104146\Temp\_sine_meas_pa_char_power=' num2str(current_dbm) '_raw.dat'],...
        [directory '\ampl_scripts\output_input_signals\_BPSK_pow=' num2str(current_dbm) '_trace.dat']);
    status=copyfile(['\\FSW26-104146\Temp\_sine_meas_pa_char_power=' num2str(current_dbm) '_iq.iq.tar'],...
        [directory '\ampl_scripts\output_input_signals\_BPSK_pow=' num2str(current_dbm) '_iq.iq.tar']);
    %% ÏĞÅÎÁĞÀÇÎÂÀÍÈÅ DAT â MAT
    conv_pames_FSW_dat([directory '\ampl_scripts\output_input_signals\_BPSK_pow=' num2str(current_dbm) '_raw.dat']);
    conv_pames_FSW_dat([directory '\ampl_scripts\output_input_signals\_BPSK_pow=' num2str(current_dbm) '_trace.dat']);
%% iq tar
    iq_data=load_iq_tar_file([directory '\ampl_scripts\output_input_signals\_BPSK_pow=' num2str(current_dbm) '_iq.iq.tar']);
    save([directory '\ampl_scripts\output_input_signals\_BPSK_pow=' num2str(current_dbm) '_iq.mat'],'iq_data');
    f=f+1;
%     scatterplot(iq_data);
end
%% ÇÀÏÈÑÜ Â ÔÀÉË ÂÛÕÎÄÍÛÕ ÇÍÀ×ÅÍÈÉ ÌÎÙÍÎÑÒÈ
fprintf(fid_outp,'%+2.4f\n',output_array);
fclose(fid_outp);
%% ÏĞÅÎÁĞÀÇÎÂÀÍÈÅ TXT Â MAT
conv_data_from_FSW([directory '\ampl_scripts\output_input_signals\_output_power_arr_BPSK.txt']);
%% ÑÎÇÄÀÅÌ ÔÀÉË ÄËß ÇÀÏÈÑÈ ÂÕÎÄÍÎÉ ÌÎÙÍÎÑÒÈ
fid_inp=fopen([directory '\ampl_scripts\output_input_signals\_input_power_arr_BPSK.txt'],'w');
fprintf(fid_inp,'%+2.4f\n',current_dbm_ar);
fclose(fid_inp);
%% ÏĞÅÎÁĞÀÇÎÂÀÍÈÅ TXT Â MAT
conv_data_from_FSW([directory '\ampl_scripts\output_input_signals\_input_power_arr_BPSK.txt']);

%% ÑÁĞÎÑ ÃÅÍÅĞÀÒÎĞÀ È ÀÍÀËÈÇÀÒÎĞÀ
generator.RawIO.Write(char('*RST'));
scope.RawIO.Write(char('*RST'));
generator.Clear();
scope.Clear();
