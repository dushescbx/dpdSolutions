function [scpi_command_ar]=scpi_coms_for_scope_for_ampl_sine_meas_marker_settings()
run('const_for_scpi_comms.m');


%%  ŒÃ¿Õƒ€ ƒÀﬂ ¬≈ “Œ–ÕŒ√Œ ¿Õ¿À»«¿“Œ–¿
i=1;
scpi_command_ar(i)=strcat(":SENS:FREQ:CENT ",num2str(FREQuency_CW));
i=i+1;
scpi_command_ar(i)=":SENS:FREQ:SPAN 1e7";
i=i+1;

scpi_command_ar(i)=(":CALC1:MARK1:STAT ON");
i=i+1;
scpi_command_ar(i)=strcat(":CALC1:MARK1:X ",num2str(FREQuency_CW));
i=i+1;

end