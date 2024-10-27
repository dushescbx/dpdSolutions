function [scpi_command_ar]=scpi_coms_for_generator_sine_meas_BPSK_var(current_dbm)
%% ÊÎÌÀÍÄÛ ÄËß ÃÅÍÅĞÀÒÎĞÀ ÑÈÃÍÀËÀ
i=1;
scpi_command_ar(i)=strcat(":SOURce1:POWer:POWer " ,num2str(current_dbm));
i=i+1;

