function [scpi_command_ar]=scpi_coms_for_scope_variable(save_file_name, save_file_name_sp_tr, const)
i=1;
%% выбираем канал VSA
scpi_command_ar(i)=strcat(":INST:SEL 'VSA'");
i=i+1;
%% выставляем ref level сигнала
scpi_command_ar(i)=strcat("SENS:ADJ:LEV;*WAI");
i=i+1;
%% начинаем новое измерение
scpi_command_ar(i)=(":INIT:IMM;*WAI");
i=i+1;
%% с заголовком
scpi_command_ar(i)=(":FORM:DEXP:HEAD ON");
i=i+1;
%% считываем trace data
scpi_command_ar(i)=(":FORM:DEXP:MODE TRAC");
i=i+1;
%% десятичная точка
scpi_command_ar(i)=(":FORM:DEXP:DSEP POIN");
i=i+1;
%% сохраняем trace data
scpi_command_ar(i)=strcat(":MMEM:STOR1:TRAC 1," + save_file_name + "_trace.DAT'");
i=i+1;
%% сохраняем trace data
scpi_command_ar(i)=strcat(":MMEM:STOR1:TRAC 1," + save_file_name + "_trace.DAT'");
i=i+1;
%% сохраняем iq
scpi_command_ar(i)=(":MMEM:STOR:IQ:STAT 1," + save_file_name + "_iq'");
i=i+1;
%% считываем raw data
scpi_command_ar(i)=(":FORM:DEXP:MODE RAW"); %%
i=i+1;
scpi_command_ar(i)=(":FORM:DEXP:HEAD ON");
i=i+1;
scpi_command_ar(i)=(":FORM:DEXP:DSEP POIN");
i=i+1;
scpi_command_ar(i)=strcat(":MMEM:STOR1:TRAC 1," + save_file_name + "_raw.DAT'");
i=i+1;
%% выставляем имя скриншота
scpi_command_ar(i)=strcat(":MMEM:NAME " + save_file_name + "'");
i=i+1;
%% делаем скриншот
scpi_command_ar(i)=("HCOP:DEV:LANG1 JPG");
i=i+1;
scpi_command_ar(i)=("HCOP:IMM1");
i=i+1;
%% считываем мощность
scpi_command_ar(i)=(":CALC2:MARK1:FUNC:DDEM:STAT:MPOW?");
i=i+1;
scpi_command_ar(i)=(":CALC2:MARK1:FUNC:DDEM:STAT:EVM?");
i=i+1;
%% переходим в окно спектра
scpi_command_ar(i)=(":INST:SEL 'Spectrum'");
i=i+1;
scpi_command_ar(i)=(":INIT:CONT OFF");
i=i+1;
scpi_command_ar(i)=(":FORM:DEXP:DSEP POIN");
i=i+1;
%% в каком формате сохранять
scpi_command_ar(i)=(":FORM:DEXP:FORM DAT");
i=i+1;
scpi_command_ar(i)=(":FORM:DEXP:HEAD ON");
i=i+1;
scpi_command_ar(i)=(":FORM:DEXP:TRAC SING");
i=i+1;
%% выставляем центральную частоту
scpi_command_ar(i)=strcat(":SENS:FREQ:CENT ",num2str(const.SCPI.FREQuency_CW));
i=i+1;
%% выставляем ширину спектра
scpi_command_ar(i)=strcat(":SENS:FREQ:SPAN ",num2str(const.SCPI.RBW));
i=i+1;
scpi_command_ar(i)=(":INIT:IMM;*WAI");
i=i+1;
scpi_command_ar(i)=(":SENS:ADJ:LEV;*WAI");
i=i+1;
scpi_command_ar(i)=strcat(":MMEM:STOR1:TRAC 1," + save_file_name_sp_tr + ".DAT'");
i=i+1;
end