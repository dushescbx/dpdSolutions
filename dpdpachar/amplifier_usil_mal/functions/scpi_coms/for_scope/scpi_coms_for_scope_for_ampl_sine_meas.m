function [scpi_command_ar]=scpi_coms_for_scope_for_ampl_sine_meas_marker(save_file_name,x)
run('const_for_scpi_comms.m');


%%  ŒÃ¿Õƒ€ ƒÀﬂ ¬≈ “Œ–ÕŒ√Œ ¿Õ¿À»«¿“Œ–¿
i=1;
% scpi_command_ar(i)=("*RST");
% i=i+1;
scpi_command_ar(i)=(":INST:CRE:NEW DDEM, 'VSA'");
i=i+1;
scpi_command_ar(i)=(":INIT:CONT OFF");
i=i+1;
scpi_command_ar(i)=strcat(":SENS:FREQ:CENT:VAL ",num2str(FREQuency_CW));
i=i+1;

if (x==8 || x==2)
    scpi_command_ar(i)=(":SENS:DDEM:FORM PSK");
    i=i+1;
    scpi_command_ar(i)=(":SENS:DDEM:PSK:FORM NORMal");
    i=i+1;
elseif x==4
    scpi_command_ar(i)=(":SENS:DDEM:FORM QPSK");
    i=i+1;
    scpi_command_ar(i)=(":SENS:DDEM:QPSK:FORM NORMal");
    i=i+1;
else
    scpi_command_ar(i)=strcat(":SENS:DDEM:FORM ",DM_FORMat_type);
    i=i+1;
    scpi_command_ar(i)=strcat(":SENS:DDEM:MAPP:VAL " ,DDEM_MAPP_VAL);
    i=i+1;
end
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
scpi_command_ar(i)=(":FORM:DEXP:MODE RAW");
i=i+1;
scpi_command_ar(i)=(":FORM:DEXP:MODE TRAC");
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
if x==2   
    scpi_command_ar(i)=(":TRIG:SEQ:SOUR:VAL IMM");
    i=i+1;
    scpi_command_ar(i)=(":SENS:DDEM:SEAR:SYNC:STAT OFF");
    i=i+1;
end
scpi_command_ar(i)=(":INIT:IMM;*WAI");
i=i+1;
scpi_command_ar(i)=strcat(":MMEM:STOR1:TRAC 1," + save_file_name + ".DAT'");
i=i+1;
scpi_command_ar(i)=strcat(":MMEM:NAME " + save_file_name + "'");
i=i+1;
scpi_command_ar(i)=("HCOP:DEV:LANG1 JPG");
i=i+1;
scpi_command_ar(i)=("HCOP:IMM1");
i=i+1;
scpi_command_ar(i)=(":CALC2:MARK1:FUNC:DDEM:STAT:MPOW?");
i=i+1;
end