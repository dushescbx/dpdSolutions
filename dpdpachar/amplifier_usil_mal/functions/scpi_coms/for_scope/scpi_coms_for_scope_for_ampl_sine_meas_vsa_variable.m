function [scpi_command_ar]=scpi_coms_for_scope_for_ampl_sine_meas_vsa_variable(save_file_name)
run('const_for_scpi_comms.m');
%%  ŒÃ¿Õƒ€ ƒÀﬂ ¬≈ “Œ–ÕŒ√Œ ¿Õ¿À»«¿“Œ–¿
i=1;
scpi_command_ar(i)=(":INIT:IMM;*WAI");
i=i+1;
% scpi_command_ar(i)=strcat(":MMEM:STOR1:TRAC 1," + save_file_name + ".DAT'");
% i=i+1;
scpi_command_ar(i)=strcat(":MMEM:NAME " + save_file_name + "'");
i=i+1;
scpi_command_ar(i)=("HCOP:DEV:LANG1 JPG");
i=i+1;
scpi_command_ar(i)=("HCOP:IMM1");
i=i+1;
scpi_command_ar(i)=(":CALC2:MARK1:FUNC:DDEM:STAT:MPOW?");
i=i+1;
end