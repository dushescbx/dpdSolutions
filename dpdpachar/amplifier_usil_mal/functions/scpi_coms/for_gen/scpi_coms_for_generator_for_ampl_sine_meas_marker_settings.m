function [scpi_command_ar]=scpi_coms_for_generator_for_ampl_sine_meas_marker_settings()
run('const_for_scpi_comms.m');


%% йнлюмдш дкъ цемепюрнпю яхцмюкю йнрнпше онярнъммш
i=1;
scpi_command_ar(i)=strcat(":SOURce1:FREQuency:CW ", num2str(FREQuency_CW));
i=i+1;
scpi_command_ar(i)=':OUTPut1:STATe 1';
i=i+1;

end