
try
    assemblyCheck = NET.addAssembly('Ivi.Visa');
catch
    error('Error loading .NET assembly Ivi.Visa');
end

%% ПОДКЛЮЧАЕМСЯ, ЕСЛИ ЕЩЕ НЕ ПОДКЛЮЧИЛИСЬ
exist isconnected
if ans==0
    scope = Ivi.Visa.GlobalResourceManager.Open('TCPIP0::10.105.31.74::inst0::INSTR');
    scope.Clear();
    generator = Ivi.Visa.GlobalResourceManager.Open('TCPIP0::10.105.31.60::inst0::INSTR');
    generator.Clear();
    isconnected=1;
end


% Linefeed as termination character for reading is necessary for the raw SOCKET and Serial connection
scope.TerminationCharacter = 10;
scope.TerminationCharacterEnabled = 1;


DPD_on=[true,false];
PA_ON=true;
k=1;

for l = 1:1:length(APSK_ar)
    for ji=1:1:length(DPD_on)
        
        %% ПРЕОБРАЗУЕМ boolean в String
        if DPD_on(ji)==1
            dpd_or_not_dpd_text='True';
        else
            dpd_or_not_dpd_text='False';
        end
        if PA_ON==1
            PA_ON_text='True';
        else
            PA_ON_text='False';
        end
        
        %% Создаем файл, где будем хранить EVM и мощность
        fid=fopen(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\in_pow_out_pow_evm_array_' ...
            num2str(APSK_ar(l)) 'APSK_PA_ON=' PA_ON_text '_dpd_on=' dpd_or_not_dpd_text '.txt'],'wt');
        
        %% Изменяем мощность
        for ka=1:1:length(current_dbm_ar)
            %% имя сохраняемого файла
            save_file_name = strcat("'C:\Temp\_"  , num2str(APSK_ar(l)) , "APSK" , num2str(current_dbm_ar(ka)) , "dbm_DPD_on=" , num2str(DPD_on(ji)) , "_input=" , PA_ON_text, "'");
            %% формируем массив команд для анализатора
            scpi_comms_for_scope_ar=scpi_coms_for_scope_for_evm_and_pow_compare(save_file_name,APSK_ar(l));
            %% формируем массив команд для генератора
            
            scpi_comms_for_generator_ar=scpi_coms_for_generator_for_evm_and_pow_compare(save_file_name,APSK_ar(l),current_dbm_ar(ka),DPD_on(ji));
            
            %% ПОСЫЛАЕМ КОМАНДЫ НА ГЕНЕРАТОР
            for i=1:1:length(scpi_comms_for_generator_ar)
                generator.RawIO.Write(char(scpi_comms_for_generator_ar(i)));
                disp((scpi_comms_for_generator_ar(i)));
            end
            %% посылаем команды на анализатор
            for ind=1:1:length(scpi_comms_for_scope_ar)
                %                 check_str=char(scpi_comms_for_scope_ar(ind));
                scope.RawIO.Write(char(scpi_comms_for_scope_ar(ind)));
                %                 if (check_str(end))=='?'
                %                     ar(k)=str2double(string(char(scope.RawIO.ReadString())));
                %                     k=k+1;
                %                 end
                %% Если в команде есть ?, т.е. запрашиваем данные с анализатора
                if contains(scpi_comms_for_scope_ar(ind),'MPOW?')
                    %%записываем в массив считанные данные
                    ar(k)=strcat('out_dbm=',string(char(scope.RawIO.ReadString())));
                    k=k+1;
                elseif contains(scpi_comms_for_scope_ar(ind),'EVM?')
                    ar(k)=strcat('EVM=',string(char(scope.RawIO.ReadString())));
                    k=k+1;
                    ar(k)="in_dbm=" + num2str(current_dbm_ar(ka)) + newline;
                    k=k+1;
                    ar(k)='';
                    k=k+1;
                end
            end
        end
        fprintf(fid,'%s',ar);
        k=1;
        fclose(fid);
    end   
end