% function [scope, generator] = connect_to_gen_and_scope(const)
try
    assemblyCheck = NET.addAssembly('Ivi.Visa');
catch
    error('Error loading .NET assembly Ivi.Visa');
end

%% ÏĞÎÂÅĞßÅÌ, ÑÎÅÄÈÍÈËÈÑÜ ËÈ ÓÆÅ Ñ ÃÅÍÅĞÀÒÎĞÎÌ È ÀÍÀËÈÇÀÎĞÎÌ, ÅÑËÈ ÍÅÒ, ÒÎ ÏÎÄÊËŞ×ÀÅÌÑß

if ( (exist('scope','var') == 0) || (exist('generator','var') == 0) )
    scope = Ivi.Visa.GlobalResourceManager.Open(['TCPIP0::' const.scope.ip '::inst0::INSTR']);
    % Clear device buffers
    scope.Clear()
    generator = Ivi.Visa.GlobalResourceManager.Open(['TCPIP0::' const.gen.ip '::inst0::INSTR']);
    generator.Clear();
end

% Linefeed as termination character for reading is necessary for the raw SOCKET and Serial connection
scope.TerminationCharacter = 10;
scope.TerminationCharacterEnabled = 1;
% end