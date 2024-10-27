function [scpi_command_ar]=scpi_coms_for_scope_for_ampl_sine_meas_marker_variable()
run('const_for_scpi_comms.m');


%% йнлюмдш дкъ бейрнпмнцн юмюкхгюрнпю
i=1;
scpi_command_ar(i)=(":INIT:IMM;*WAI");
i=i+1;
scpi_command_ar(i)=":CALC1:MARK1:Y?";
i=i+1;
end