function [scpi_command_ar]=scpi_coms_for_scope_settings_BPSK(x)
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

scpi_command_ar(i)=strcat(":SENS:DDEM:" , psk_or_apsk(x), ":NST " , num2str(x));
i=i+1;
scpi_command_ar(i)=strcat(":SENS:DDEM:SRAT ", num2str(DDEM_SRAT));
i=i+1;
scpi_command_ar(i)=strcat(":SENS:DDEM:RLEN:VAL " ,num2str(res_len) , " SYM");
i=i+1;
scpi_command_ar(i)=(":SENS:DDEM:SIGN:PATT ON");
i=i+1;
scpi_command_ar(i)=strcat(":SENS:DDEM:SEAR:SYNC:PATT:ADD " , find_pattern(strcat(num2str(x),"apsk")));
i=i+1;
scpi_command_ar(i)=strcat(":SENS:DDEM:SEAR:SYNC:SEL " , find_pattern(strcat(num2str(x),"apsk")));
i=i+1;
scpi_command_ar(i)=strcat(":SENS:DDEM:TIME " , num2str(meas_symb_num));
i=i+1;
scpi_command_ar(i)=strcat(":SENS:DDEM:PRAT " , num2str(samples_per_symbol));
i=i+1;
scpi_command_ar(i)=(":SENS:DDEM:SEAR:SYNC:MODE SYNC");
i=i+1;
scpi_command_ar(i)=(":TRIG:SEQ:SOUR EXT");
i=i+1;
scpi_command_ar(i)=(":CALC:ELIN:STAT ON");
i=i+1;
scpi_command_ar(i)=(":CALC:ELIN:STAT OFF");
i=i+1;
scpi_command_ar(i)=(":CALC:TRAC:ADJ:VAL TRIG");
i=i+1;
scpi_command_ar(i)=strcat(":SENS:DDEM:TIME " , num2str(res_len));
i=i+1;
scpi_command_ar(i)=(":FORM:DEXP:HEAD OFF");
i=i+1;
scpi_command_ar(i)=(":FORM:DEXP:DSEP POIN");
i=i+1;
scpi_command_ar(i)=(":CALC:TRAC:ADJ:ALIG:DEF LEFT");
i=i+1;
scpi_command_ar(i)=(":SENS:DDEM:SEAR:SYNC:STAT ON");
i=i+1;
scpi_command_ar(i)=(":SYST:DISP:UPD ON");
i=i+1;

% scpi_command_ar(i)=(":TRIG:SEQ:SOUR:VAL IMM");
% i=i+1;
% scpi_command_ar(i)=(":SENS:DDEM:SEAR:SYNC:STAT OFF");
% i=i+1;

end