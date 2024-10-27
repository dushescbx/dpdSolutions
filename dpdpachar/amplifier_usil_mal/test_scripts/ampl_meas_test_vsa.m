for l = 1:1:length(APSK_ar)
    f=1;
    
    %% ������� ���� ��� ������ �������� ��������
    fid_outp=fopen(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\_output_power_arr_' ...
        num2str(APSK_ar(l))  'APSK_pa_on_=' PA_ON_text '_dpd_on='  dpd_or_not_dpd_text   '.txt'],'w');
    k=1;
    
    %% �������� ������ ������ ��������
    shag_tcikla_power=1;% ��� ��������� ��������
    for current_dbm=0:shag_tcikla_power:3
        current_dbm_ar(k)=current_dbm;
        k=k+1;
        
        %% ����� ���������� ������ ��������� � �����������
        save_file_name = strcat("'C:\Temp\_"  , num2str(APSK_ar(l)) , "APSK" , num2str(current_dbm) , "dbm_DPD_on=" , dpd_or_not_dpd_text , "_pa_on=" , PA_ON_text);
        
        %% ���������� ������� ��� ���������� � �����������
        scpi_comms_for_scope_ar=scpi_coms_for_scope(save_file_name,APSK_ar(l));
        scpi_comms_for_generator_ar=scpi_coms_for_generator(save_file_name,APSK_ar(l),current_dbm);
        
        %% �������� ������� �� ���������
        for i=1:1:length(scpi_comms_for_generator_ar)
            generator.RawIO.Write(char(scpi_comms_for_generator_ar(i)));
            disp((scpi_comms_for_generator_ar(i)));
        end
        %% �������� ������� �� ����������
        for i=1:1:length(scpi_comms_for_scope_ar)
            scope.RawIO.Write(char(scpi_comms_for_scope_ar(i)));
            %% ���� � �������
            if contains(scpi_comms_for_scope_ar(i),'?')
                output_array(f)=str2double(string(char(scope.RawIO.ReadString())))
                
            end
            disp(char(scpi_comms_for_scope_ar(i)));
        end
        %% ���������� ��������� �� �����������
        status=copyfile(['\\FSW26-104146\Temp\_' num2str(APSK_ar(l)) 'APSK' num2str(current_dbm) 'dbm_DPD_on=' dpd_or_not_dpd_text '_pa_on=' PA_ON_text '.dat'],...
            ['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\_' num2str(APSK_ar(l)) 'APSK' num2str(current_dbm) 'dbm_DPD_on=' dpd_or_not_dpd_text '_pa_on=' PA_ON_text '.jpeg']);
        status=copyfile(['\\FSW26-104146\Temp\_' num2str(APSK_ar(l)) 'APSK' num2str(current_dbm) 'dbm_DPD_on=' dpd_or_not_dpd_text '_pa_on=' PA_ON_text '.dat'],...
            ['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\_' num2str(APSK_ar(l)) 'APSK' num2str(current_dbm) 'dbm_DPD_on=' dpd_or_not_dpd_text '_pa_on=' PA_ON_text '.dat']);
        %% �������������� DAT � MAT
        conv_pames_FSW_dat(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\_' num2str(APSK_ar(l)) ...
            'APSK' num2str(current_dbm) 'dbm_DPD_on=' dpd_or_not_dpd_text '_pa_on=' PA_ON_text '.dat'])
        f=f+1;
    end
    %% ������ � ���� �������� �������� ��������
    fprintf(fid_outp,'%+2.4f\n',output_array);
    fclose(fid_outp);
    %% �������������� TXT � MAT
    conv_data_from_FSW(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\_output_power_arr_' ...
        num2str(APSK_ar(l))  'APSK_pa_on_=' PA_ON_text '_dpd_on='  dpd_or_not_dpd_text   '.txt']);
    %% ������� ���� ��� ������ ������� ��������
    fid_inp=fopen(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\_input_power_arr_' ...
        num2str(APSK_ar(l))  'APSK_pa_on_=' PA_ON_text '_dpd_on='  dpd_or_not_dpd_text   '.txt'],'w');
    fprintf(fid_inp,'%+2.4f\n',current_dbm_ar);
    fclose(fid_inp);
    %% �������������� TXT � MAT
    conv_data_from_FSW(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\_input_power_arr_' ...
        num2str(APSK_ar(l))  'APSK_pa_on_=' PA_ON_text '_dpd_on='  dpd_or_not_dpd_text   '.txt']);
end
%% ������� ���������� ����
%     if quest_dlg_ind==0
%         quest_dlg_ind=1;
%         promptMessage = sprintf('���������� ���������');
%         button = questdlg(promptMessage,'','����������?','��');
%     end
