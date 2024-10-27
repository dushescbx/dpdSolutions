function [scpi_command_ar]=scpi_coms_for_generator_sine_meas(save_file_name,current_dbm)
run('const_for_scpi_comms.m');


%%  ŒÃ¿Õƒ€ ƒÀﬂ √≈Õ≈–¿“Œ–¿ —»√Õ¿À¿
i=1;
scpi_command_ar(i)=strcat(":SOURce1:BB:ARBitrary:WAVeform:SELect " , ARBitrary_WAVeform_SELect, num2str(x) , 'APSK_ref_symb.wv"');
i=i+1;
scpi_command_ar(i)=strcat(":SOURce1:FREQuency:CW ", num2str(FREQuency_CW));
i=i+1;
scpi_command_ar(i)=strcat(":SOURce1:POWer:POWer " ,num2str(current_dbm));
i=i+1;
scpi_command_ar(i)=':OUTPut1:STATe 1';
i=i+1;
