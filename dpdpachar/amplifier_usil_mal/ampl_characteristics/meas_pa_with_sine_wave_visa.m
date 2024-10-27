clear all;
close all;
clc;
run('const_for_scpi_comms.m');


try
    assemblyCheck = NET.addAssembly('Ivi.Visa');
catch
    error('Error loading .NET assembly Ivi.Visa');
end

% Opening VISA session to the instrument
% scope = Ivi.Visa.GlobalResourceManager.Open('TCPIP0::10.105.31.74::inst0::INSTR');
% % Clear device buffers
% scope.Clear();
% generator = Ivi.Visa.GlobalResourceManager.Open('TCPIP0::10.105.31.60::inst0::INSTR');
% generator.Clear();


% Linefeed as termination character for reading is necessary for the raw SOCKET and Serial connection
scope.TerminationCharacter = 10;
scope.TerminationCharacterEnabled = 1;
DPD_on_off=false;
inp=false;
fid_1=fopen(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\input_power_sine.txt'],'wt');
fid_2=fopen(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\output_power_sine.txt'],'wt');


for current_dbm=-20:1:-20
    save_file_name = strcat("'C:\Temp\_"  , num2str(APSK) , "APSK" , num2str(current_dbm) , "dbm_DPD_on=" , num2str(DPD_on_off) , "_input=" , num2str(inp));
    scpi_comms_for_scope_ar=scpi_coms_for_scope_sine_meas(save_file_name);
    scpi_comms_for_generator_ar=scpi_coms_for_generator_sine_meas(save_file_name,current_dbm);
    % LineFeed character at the end - required for SOCKET and Serial connection
    for i=1:1:length(scpi_comms_for_generator_ar)
        %             generator.RawIO.Write(char(scpi_comms_for_generator_ar(i)));
        disp((scpi_comms_for_generator_ar(i)));
        %idnResponse = char(scope.RawIO.ReadString());
    end
    
    for i=1:1:length(scpi_comms_for_scope_ar)
        %             scope.RawIO.Write(char(scpi_comms_for_scope_ar(i)));
        disp(char(scpi_comms_for_scope_ar(i)));
    end
    %         idnResponse = char(scope.RawIO.ReadString()); 
end
fclose(fid_1);
fclose(fid_2);