f=1;
%% ������� ���� ��� ������ �������� ��������
fid_outp=fopen([directory '\ampl_scripts\output_input_signals\_output_power_arr_BPSK.txt'],'w');
k=1;
clear scpi_comms_for_scope_ar scpi_comms_for_generator_ar;
%% ���������� ������� ��� ���������� � �����������
scpi_comms_for_scope_ar=scpi_coms_for_scope_settings_BPSK(2);
scpi_comms_for_generator_ar=scpi_coms_for_generator_sine_meas_BPSK_const(2);

%% �������� ������� �� ���������
for i=1:1:length(scpi_comms_for_generator_ar)
    generator.RawIO.Write(char(scpi_comms_for_generator_ar(i)));
    disp((scpi_comms_for_generator_ar(i)));
end
%% �������� ������� �� ����������
for i=1:1:length(scpi_comms_for_scope_ar)
    scope.RawIO.Write(char(scpi_comms_for_scope_ar(i)));
    disp(char(scpi_comms_for_scope_ar(i)));
end
clear scpi_comms_for_scope_ar scpi_comms_for_generator_ar output_array;
%% �������� ������ ������ ��������
shag_tcikla_power=1;% ��� ��������� ��������
for current_dbm=7:shag_tcikla_power:20
    
    current_dbm_ar(k)=current_dbm;
    k=k+1;
    
    %% ����� ���������� ������ ��������� � �����������
    save_file_name = strcat("'C:\Temp\_sine_meas_pa_char_power=" , num2str(current_dbm));
    
    %% ���������� ������� ��� ���������� � �����������
    scpi_comms_for_scope_ar=scpi_coms_for_scope_variable_BPSK(save_file_name);
    scpi_comms_for_generator_ar=scpi_coms_for_generator_sine_meas_BPSK_var(current_dbm);
    
    %% �������� ������� �� ���������
    for i=1:1:length(scpi_comms_for_generator_ar)
        generator.RawIO.Write(char(scpi_comms_for_generator_ar(i)));
        disp((scpi_comms_for_generator_ar(i)));
    end
    %% �������� ������� �� ����������
    for i=1:1:length(scpi_comms_for_scope_ar)
        pause(0.1)
        scope.RawIO.Write(char(scpi_comms_for_scope_ar(i)));
        %% ���� � �������
        if contains(scpi_comms_for_scope_ar(i),'?')
            output_array(f)=str2double(string(char(scope.RawIO.ReadString())))
            
        end
        disp(char(scpi_comms_for_scope_ar(i)));
    end
    %% ���������� ��������� �� �����������
    status=copyfile(['\\FSW26-104146\Temp\_sine_meas_pa_char_power=' num2str(current_dbm) '.JPEG'],...
        [directory '\ampl_scripts\output_input_signals\_BPSK_pow=' num2str(current_dbm) '.jpeg']);
    status=copyfile(['\\FSW26-104146\Temp\_sine_meas_pa_char_power=' num2str(current_dbm) '_raw.dat'],...
        [directory '\ampl_scripts\output_input_signals\_BPSK_pow=' num2str(current_dbm) '_raw.dat']);
        status=copyfile(['\\FSW26-104146\Temp\_sine_meas_pa_char_power=' num2str(current_dbm) '_raw.dat'],...
        [directory '\ampl_scripts\output_input_signals\_BPSK_pow=' num2str(current_dbm) '_trace.dat']);
    status=copyfile(['\\FSW26-104146\Temp\_sine_meas_pa_char_power=' num2str(current_dbm) '_iq.iq.tar'],...
        [directory '\ampl_scripts\output_input_signals\_BPSK_pow=' num2str(current_dbm) '_iq.iq.tar']);
    %% �������������� DAT � MAT
    conv_pames_FSW_dat([directory '\ampl_scripts\output_input_signals\_BPSK_pow=' num2str(current_dbm) '_raw.dat']);
    conv_pames_FSW_dat([directory '\ampl_scripts\output_input_signals\_BPSK_pow=' num2str(current_dbm) '_trace.dat']);
%% iq tar
    iq_data=load_iq_tar_file([directory '\ampl_scripts\output_input_signals\_BPSK_pow=' num2str(current_dbm) '_iq.iq.tar']);
    save([directory '\ampl_scripts\output_input_signals\_BPSK_pow=' num2str(current_dbm) '_iq.mat'],'iq_data');
    f=f+1;
%     scatterplot(iq_data);
end
%% ������ � ���� �������� �������� ��������
fprintf(fid_outp,'%+2.4f\n',output_array);
fclose(fid_outp);
%% �������������� TXT � MAT
conv_data_from_FSW([directory '\ampl_scripts\output_input_signals\_output_power_arr_BPSK.txt']);
%% ������� ���� ��� ������ ������� ��������
fid_inp=fopen([directory '\ampl_scripts\output_input_signals\_input_power_arr_BPSK.txt'],'w');
fprintf(fid_inp,'%+2.4f\n',current_dbm_ar);
fclose(fid_inp);
%% �������������� TXT � MAT
conv_data_from_FSW([directory '\ampl_scripts\output_input_signals\_input_power_arr_BPSK.txt']);

%% ����� ���������� � �����������
generator.RawIO.Write(char('*RST'));
scope.RawIO.Write(char('*RST'));
generator.Clear();
scope.Clear();
