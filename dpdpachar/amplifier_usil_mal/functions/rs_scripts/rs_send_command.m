% function rs_send_command
% *************************************************************************
% 
% Copyright: (c) 2011 Rohde & Schwarz GmbH & CO KG.    All rights reserved.
%                Muehldorfstr. 15
%                D-81671 Munich
%
% ************************************************************************* 
% This function sends SCPI commands to remote instruments. 
%%
% @param InstrObj    Object for remote instrument created by rs_connect.
% @param strCommand  The SCPI command string.
%%
% @return Status     Status = 0, if command could not be transmitted.         
%                    Status = 1, if command was sent successfully.
%**************************************************************************

function [Status] = rs_send_command( InstrObj, strCommand )

    % preset status
    Status = 0;
    
    % check number of arguments
    if( nargin ~= 2 )
        disp( '*** Wrong number of input arguments to rs_send_command().' )
        return;
    end

    % check first argument to be a valid object
    if( isobject(InstrObj) ~= 1 )
        disp( '*** The first parameter is not an object.' );
        return;
    end
    if( isvalid(InstrObj) ~= 1 )
        disp ('*** The first parameter is not a valid object.');
        return;
    end

    % check command to be a string
    if( isempty(strCommand) || (ischar(strCommand)~= 1) )
        disp ('*** Command string is empty or not a string.');
        return;
    end
    
    % open instrument connection
    CloseConn = 0;
    if( ~strcmp(InstrObj.Status,'open') )
        try
            fopen( InstrObj );
        catch err
            disp( '*** Cannot open instrument connection.' );
            disp (['*** Matlab error message : ' err.message]);
            return;
        end
        CloseConn = 1;
    end
    
    % send command
    try
        % fwrite (InstrObj, strCommand);  -  this does not work
        % anylonger with MATLAB version R2009a
        fprintf (InstrObj, strCommand);
    catch err
        disp( ['*** Cannot send command ''' , strCommand , ''''] );
        disp (['*** Matlab error message : ' err.message]);
        if( CloseConn ), fclose( InstrObj ); end
        return;
    end

    % close connection
    if( CloseConn )
        try
            fclose( InstrObj );
        catch err
           disp( '*** Cannot close instrument connection.' );
           disp (['*** Matlab error message : ' err.message]);
           return;
        end
    end
    
    % set return status
    Status = 1;
    
    return;

% end of file
