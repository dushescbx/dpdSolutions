function [scpi_command_ar]=scpi_coms_for_generator_variable(current_dbm)
run('const_for_scpi_comms.m');

%% ÊÎÌÀÍÄÛ ÄËß ÃÅÍÅĞÀÒÎĞÀ ÑÈÃÍÀËÀ
i=1;
scpi_command_ar(i)=strcat(":SOURce1:POWer:POWer " ,num2str(current_dbm));
i=i+1;
end