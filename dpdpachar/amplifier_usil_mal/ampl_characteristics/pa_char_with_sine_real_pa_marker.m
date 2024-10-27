    
    
    
    %% ��������� �������������� ��������� �� ��������������� �������� �������
    ji=1;
    % ����� ���������� ������ ��������� � �����������
    fid_1=fopen(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\input_power_sine_marker.txt'],'wt');
    fid_2=fopen(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\output_power_sine_marker.txt'],'wt');
    
    % ���������� ������� ��� ���������� � �����������
%     save_file_name = strcat("'C:\Temp\_sine_meas_with_marker_power=" , num2str(current_dbm));
            
    clear output_array scpi_comms_for_scope_ar scpi_comms_for_generator_ar;
    scpi_comms_for_scope_ar=scpi_coms_for_scope_for_ampl_sine_meas_marker_settings();
    scpi_comms_for_generator_ar=scpi_coms_for_generator_for_ampl_sine_meas_marker_settings();
    
    % �������� ������� �� ���������
    for i=1:1:length(scpi_comms_for_generator_ar)
        generator.RawIO.Write(char(scpi_comms_for_generator_ar(i)));
        disp((scpi_comms_for_generator_ar(i)));
    end
    % �������� ������� �� ����������
    for i=1:1:length(scpi_comms_for_scope_ar)
        scope.RawIO.Write(char(scpi_comms_for_scope_ar(i)));
        disp(char(scpi_comms_for_scope_ar(i)));
    end
    
    clear scpi_comms_for_scope_ar scpi_comms_for_generator_ar;
    
    scpi_comms_for_scope_ar=scpi_coms_for_scope_for_ampl_sine_meas_marker_variable();
    for i=1:1:length(input_ar.d)
        
        scpi_comms_for_generator_ar=scpi_coms_for_generator_for_ampl_sine_meas_marker_variable(input_ar.d(i));
        
        % �������� ������� �� ���������
        for k=1:1:length(scpi_comms_for_generator_ar)
            generator.RawIO.Write(char(scpi_comms_for_generator_ar(k)));
            disp((scpi_comms_for_generator_ar(k)));
        end
        % �������� ������� �� ����������
        for k=1:1:length(scpi_comms_for_scope_ar)
            pause(0.1);
            scope.RawIO.Write(char(scpi_comms_for_scope_ar(k)));
            % ���� � �������
            if contains(scpi_comms_for_scope_ar(k),'?')
                output_array(ji)=str2double(string(char(scope.RawIO.ReadString())))
                ji=ji+1;
            end
            disp(char(scpi_comms_for_scope_ar(k)));
        end
    end
    fprintf(fid_2,'%+2.4f\n',output_array);
    fprintf(fid_1,'%+2.4f\n',input_ar.d);
    fclose(fid_1);
    fclose(fid_2);
        figure(f1);
    plot(input_ar.d,output_array);
    
    %% ����� ���������� � �����������
    generator.RawIO.Write(char('*RST'));
    scope.RawIO.Write(char('*RST'));
    generator.Clear();
    scope.Clear();
    
    