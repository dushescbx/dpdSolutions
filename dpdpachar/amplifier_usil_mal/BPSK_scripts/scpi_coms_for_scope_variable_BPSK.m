function [scpi_command_ar]=scpi_coms_for_scope_variable_BPSK(save_file_name)
run('const_for_scpi_comms.m');
i=1;

scpi_command_ar(i)=(":INIT:IMM;*WAI");
i=i+1;
scpi_command_ar(i)=(":FORM:DEXP:HEAD ON");
i=i+1;
scpi_command_ar(i)=(":FORM:DEXP:MODE TRAC");
i=i+1;
scpi_command_ar(i)=(":FORM:DEXP:DSEP POIN");
i=i+1;
scpi_command_ar(i)=strcat(":MMEM:STOR1:TRAC 1," + save_file_name + "_trace.DAT'");
i=i+1;
scpi_command_ar(i)=(":MMEM:STOR:IQ:STAT 1," + save_file_name + "_iq'");
i=i+1;
scpi_command_ar(i)=(":FORM:DEXP:MODE RAW"); %%
i=i+1;
scpi_command_ar(i)=(":FORM:DEXP:HEAD ON");
i=i+1;
scpi_command_ar(i)=(":FORM:DEXP:DSEP POIN");
i=i+1;
scpi_command_ar(i)=strcat(":MMEM:STOR1:TRAC 1," + save_file_name + "_raw.DAT'");
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