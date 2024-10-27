function generate_signal_and_record_to_file(const, generator, scope)
%% ÑÁĞÎÑ ÃÅÍÅĞÀÒÎĞÀ È ÀÍÀËÈÇÀÒÎĞÀ
generator.RawIO.Write(char('*RST'));
scope.RawIO.Write(char('*RST'));
generator.Clear();
scope.Clear();
% ïğîâåğÿåì åñòü ëè ïàïêà äëÿ èçìåğåííûõ ñèãíàëîâ
if (exist(const.com.meas_sig_folder_name, 'dir') ~= 7)
    mkdir(const.com.meas_sig_folder_name);
end
if (exist(const.com.pa_meas_sig_folder_name, 'dir') ~= 7)
    mkdir(const.com.pa_meas_sig_folder_name);
end
%% öèêë äëÿ çàäàííûõ ñîçâåçäèé
for l = 1 : 1 : length(const.sig.APSK)
    
    %% ÑÎÇÄÀÅÌ ÔÀÉË ÄËß ÇÀÏÈÑÈ ÂÛÕÎÄÍÛÕ ÇÍÀ×ÅÍÈÉ ÌÎÙÍÎÑÒÈ è EVM
    fid_outp = fopen(strcat(const.com.pa_meas_sig_folder_name, const.com.output_pa_power_wo_dpd, ...
        num2str(const.sig.APSK(l)),  'APSK.txt'),'w');
    fid_outp_evm = fopen(strcat(const.com.pa_meas_sig_folder_name, const.com.output_EVM_wo_dpd, ...
        num2str(const.sig.APSK(l)),  'APSK.txt'),'w');
    clear scpi_comms_for_scope_ar scpi_comms_for_generator_ar;
    %% ÃÅÍÅĞÈĞÓÅÌ ÊÎÌÀÍÄÛ ÄËß ÃÅÍÅĞÀÒÎĞÀ È ÀÍÀËÈÇÀÒÎĞÀ
    scpi_comms_for_scope_ar = scpi_coms_for_scope_settings(const.sig.APSK(l), const);
    scpi_comms_for_generator_ar = scpi_coms_for_generator_settings(const.sig.APSK(l), const);
    
    %% ÏÎÑÛËÀÅÌ ÊÎÌÀÍÄÛ ÍÀ ÃÅÍÅĞÀÒÎĞ
    for i = 1 : 1 : length(scpi_comms_for_generator_ar)
        generator.RawIO.Write(char(scpi_comms_for_generator_ar(i)));
        disp((scpi_comms_for_generator_ar(i)));
    end
    %% ÏÎÑÛËÀÅÌ ÊÎÌÀÍÄÛ ÍÀ ÀÍÀËÈÇÀÒÎĞ
    for i = 1 : 1 : length(scpi_comms_for_scope_ar)
        scope.RawIO.Write(char(scpi_comms_for_scope_ar(i)));
        disp(char(scpi_comms_for_scope_ar(i)));
    end
    clear scpi_comms_for_scope_ar scpi_comms_for_generator_ar output_array;
    
    %% ÏÎÑÛËÀÅÌ ÑÈÃÍÀË ĞÀÇÍÎÉ ÌÎÙÍÎÑÒÈ
    
    f=1;
    for current_dbm = const.sig.in_power
        
        %% ÌÅÑÒÎ ÑÎÕĞÀÍÅÍÈß ÔÀÉËÎÂ ÑÎÇÂÅÇÄÈÉ Ñ ÀÍÀËÈÇÀÒÎĞÀ
        save_file_name = strcat("'", const.com.data_from_scope_folder_name(1), ...
            const.com.data_from_scope_folder_name(2), const.com.data_from_scope_folder_name(3), ...
            "_" , num2str(const.sig.APSK(l)) , "APSK" , num2str(current_dbm) , "dbm");
        save_file_name_sp_tr = strcat("'", const.com.data_from_scope_folder_name(1), ...
            const.com.data_from_scope_folder_name(2), const.com.data_from_scope_folder_name(3), ...
            "_", num2str(const.sig.APSK(l)), "APSK" , num2str(current_dbm), "dbm_spectrum_trace");
        
        %% ÃÅÍÅĞÈĞÓÅÌ ÊÎÌÀÍÄÛ ÄËß ÃÅÍÅĞÀÒÎĞÀ È ÀÍÀËÈÇÀÒÎĞÀ
        scpi_comms_for_scope_ar = scpi_coms_for_scope_variable(save_file_name, save_file_name_sp_tr, const);
        scpi_comms_for_generator_ar = scpi_coms_for_generator_variable(current_dbm);
        
        %% ÏÎÑÛËÀÅÌ ÊÎÌÀÍÄÛ ÍÀ ÃÅÍÅĞÀÒÎĞ
        for i = 1 : 1 : length(scpi_comms_for_generator_ar)
            generator.RawIO.Write(char(scpi_comms_for_generator_ar(i)));
            disp((scpi_comms_for_generator_ar(i)));
        end
        %% ÏÎÑÛËÀÅÌ ÊÎÌÀÍÄÛ ÍÀ ÀÍÀËÈÇÀÒÎĞ
        for i = 1 : 1 : length(scpi_comms_for_scope_ar)
            pause(0.1)
            scope.RawIO.Write(char(scpi_comms_for_scope_ar(i)));
            %% ÅÑËÈ Â ÊÎÌÀÍÄÅ
            if contains(scpi_comms_for_scope_ar(i),'MPOW?')
                output_array(f) = str2double(string(char(scope.RawIO.ReadString())));
            elseif contains(scpi_comms_for_scope_ar(i),'EVM?')
                output_evm_array(f) = str2double(string(char(scope.RawIO.ReadString())));
            end
            disp(char(scpi_comms_for_scope_ar(i)));
        end
        f = f + 1;
    end
    pause(1)
    status = copyfile(strcat('\\', const.scope.name, '\', const.com.data_from_scope_folder_name(2),...
        '\', const.com.pa_meas_sig_folder_name),...
        const.com.pa_meas_sig_folder_name );
    
    %% ÇÀÏÈÑÜ Â ÔÀÉË ÂÛÕÎÄÍÛÕ ÇÍÀ×ÅÍÈÉ ÌÎÙÍÎÑÒÈ
    fprintf(fid_outp,'%+2.4f\n',output_array);
    fclose(fid_outp);
    %% ÇÀÏÈÑÜ Â ÔÀÉË ÂÛÕÎÄÍÛÕ ÇÍÀ×ÅÍÈÉ EVM
    fprintf(fid_outp_evm,'%+2.4f\n',output_evm_array);
    fclose(fid_outp_evm);
    %% ÏĞÅÎÁĞÀÇÎÂÀÍÈÅ TXT Â MAT
    conv_data_from_FSW( char(strcat(const.com.pa_meas_sig_folder_name, const.com.output_pa_power_wo_dpd, ...
        num2str(const.sig.APSK(l)),  'APSK.txt')) );
        %% ÏĞÅÎÁĞÀÇÎÂÀÍÈÅ TXT Â MAT
    conv_data_from_FSW( char(strcat(const.com.pa_meas_sig_folder_name, const.com.output_EVM_wo_dpd, ...
        num2str(const.sig.APSK(l)),  'APSK.txt')) );
    %% ÑÎÇÄÀÅÌ ÔÀÉË ÄËß ÇÀÏÈÑÈ ÂÕÎÄÍÎÉ ÌÎÙÍÎÑÒÈ
    fid_inp = fopen( strcat(const.com.pa_meas_sig_folder_name, const.com.input_pa_power_wo_dpd, ...
        num2str(const.sig.APSK(l)), 'APSK.txt'), 'w');
    fprintf(fid_inp, '%+2.4f\n', const.sig.in_power);
    fclose(fid_inp);
    %% ÏĞÅÎÁĞÀÇÎÂÀÍÈÅ TXT Â MAT
    conv_data_from_FSW( char(strcat(const.com.pa_meas_sig_folder_name, const.com.input_pa_power_wo_dpd, ...
        num2str(const.sig.APSK(l)), 'APSK.txt')) );
    
    for current_dbm = const.sig.in_power
        %% ÏĞÅÎÁĞÀÇÎÂÀÍÈÅ DAT â MAT
        filename = char(strcat(const.com.pa_meas_sig_folder_name, '\_', num2str(const.sig.APSK(l)), ...
            'APSK', num2str(current_dbm), 'dbm'));
        conv_pames_FSW_dat([filename '_raw.dat']);
        conv_pames_FSW_dat([filename '_spectrum_trace.dat']);
        %% ÏĞÅÎÁĞÀÇÎÂÀÍÈÅ DAT â MAT
        conv_pames_FSW_dat([filename '_trace.dat'])
        iq_data = load_iq_tar_file([filename '_iq.iq.tar']);
        save([filename '_iq.mat'],'iq_data');
    end
    
end

%% ÑÁĞÎÑ ÃÅÍÅĞÀÒÎĞÀ È ÀÍÀËÈÇÀÒÎĞÀ
generator.RawIO.Write(char('*RST'));
scope.RawIO.Write(char('*RST'));
generator.Clear();
scope.Clear();
