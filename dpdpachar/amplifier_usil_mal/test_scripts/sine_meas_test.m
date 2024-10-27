%% хглепемхе уюпюйрепхярхйх сяхкхрекъ он яхмсянхдюкэмнлс бундмнлс яхцмюкс
ji=1;
% леярн янупюмемхъ тюикнб янгбегдхи я юмюкхгюрнпю
fid_1=fopen(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\input_power_sine.txt'],'wt');
fid_2=fopen(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\output_power_sine.txt'],'wt');

% цемепхпсел йнлюмдш дкъ цемепюрнпю х юмюкхгюрнпю

clear output_array scpi_comms_for_scope_ar scpi_comms_for_generator_ar;
scpi_comms_for_scope_ar=scpi_coms_for_scope_for_ampl_sine_meas_marker_settings();
scpi_comms_for_generator_ar=scpi_coms_for_generator_for_ampl_sine_meas_marker_settings();

% оняшкюел йнлюмдш мю цемепюрнп
for i=1:1:length(scpi_comms_for_generator_ar)
    generator.RawIO.Write(char(scpi_comms_for_generator_ar(i)));
    disp((scpi_comms_for_generator_ar(i)));
end
% оняшкюел йнлюмдш мю юмюкхгюрнп
for i=1:1:length(scpi_comms_for_scope_ar)
    scope.RawIO.Write(char(scpi_comms_for_scope_ar(i)));
    disp(char(scpi_comms_for_scope_ar(i)));
end

clear scpi_comms_for_scope_ar scpi_comms_for_generator_ar;

scpi_comms_for_scope_ar=scpi_coms_for_scope_for_ampl_sine_meas_marker_variable();
for i=1:1:length(input_ar.d)
    
    scpi_comms_for_generator_ar=scpi_coms_for_generator_for_ampl_sine_meas_marker_variable(input_ar.d(i));
    
    % оняшкюел йнлюмдш мю цемепюрнп
    for i=1:1:length(scpi_comms_for_generator_ar)
        generator.RawIO.Write(char(scpi_comms_for_generator_ar(i)));
        disp((scpi_comms_for_generator_ar(i)));
    end
    % оняшкюел йнлюмдш мю юмюкхгюрнп
    for i=1:1:length(scpi_comms_for_scope_ar)
        pause(0.1);
        scope.RawIO.Write(char(scpi_comms_for_scope_ar(i)));
        % еякх б йнлюмде
        if contains(scpi_comms_for_scope_ar(i),'?')
            output_array(ji)=str2double(string(char(scope.RawIO.ReadString())))
            ji=ji+1;
        end
        disp(char(scpi_comms_for_scope_ar(i)));
    end
end
fprintf(fid_2,'%+2.4f\n',output_array);
fprintf(fid_1,'%+2.4f\n',input_ar.d);
fclose(fid_1);
fclose(fid_2);
