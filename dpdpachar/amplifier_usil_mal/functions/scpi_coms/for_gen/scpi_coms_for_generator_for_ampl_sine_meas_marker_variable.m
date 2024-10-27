function [scpi_command_ar]=scpi_coms_for_generator_for_ampl_sine_meas_marker_variable(current_dbm)
run('const_for_scpi_comms.m');


%% йнлюмдш дкъ цемепюрнпю яхцмюкю йнрнпше хглемъчряъ
i=1;
scpi_command_ar(i)=strcat(":SOURce1:POWer:POWer " ,num2str(current_dbm));
i=i+1;
end