function [scpi_command_ar]=scpi_coms_for_scope_for_ampl_sine_meas_vsa_settings(save_file_name)
run('const_for_scpi_comms.m');


%%  ŒÃ¿Õƒ€ ƒÀﬂ ¬≈ “Œ–ÕŒ√Œ ¿Õ¿À»«¿“Œ–¿
i=1;
scpi_command_ar(i)=(":INST:CRE:NEW DDEM, 'VSA'");
i=i+1;
scpi_command_ar(i)=(":INIT:CONT OFF");
i=i+1;
scpi_command_ar(i)=strcat(":SENS:FREQ:CENT:VAL ",num2str(FREQuency_CW));
i=i+1;
scpi_command_ar(i)=(":SENS:DDEM:FORM PSK");
i=i+1;
scpi_command_ar(i)=(":SENS:DDEM:PSK:FORM NORMal");
i=i+1;
scpi_command_ar(i)=strcat(":SENS:DDEM:" , psk_or_apsk(2), ":NST " , num2str(2));
i=i+1;
scpi_command_ar(i)=strcat(":SENS:DDEM:SRAT ", num2str(DDEM_SRAT));
i=i+1;
scpi_command_ar(i)=strcat(":SENS:DDEM:RLEN:VAL " ,num2str(res_len) , " SYM");
i=i+1;
scpi_command_ar(i)=strcat(":SENS:DDEM:TIME " , num2str(meas_symb_num));
i=i+1;
scpi_command_ar(i)=strcat(":SENS:DDEM:TIME " , num2str(res_len));
i=i+1;
end