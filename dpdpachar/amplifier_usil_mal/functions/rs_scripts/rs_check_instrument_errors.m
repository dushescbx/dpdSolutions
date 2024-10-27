% function rs_check_instrument_errors
% *************************************************************************
% 
% Copyright: (c) 2011 Rohde & Schwarz GmbH & CO KG.    All rights reserved.
%                Muehldorfstr. 15
%                D-81671 Munich
%
% ************************************************************************* 
% This function reads the instruments error queue. 
%%
% @param InstrObj    Object for remote instrument created by rs_connect.
%%
% @return Status     Status = 0, errors occured
%                    Status = 1, no errors occured
%**************************************************************************

function [Status, Result] = rs_check_instrument_errors( InstrObj )

    Status = 0;
    Result = '';

    % check number of arguments
    if( nargin ~= 1 )
        disp( '*** Wrong number of input arguments to rs_check_instrument_errors().' )
        return;
    end

    % check first argument to be an object
    if( isobject(InstrObj) ~= 1 )
        disp( '*** The first parameter is not an object.' );
        return;
    end
    if( isvalid(InstrObj) ~= 1 )
        disp( '*** The first parameter is not a valid object.' );
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

    Counter = 0;
    Error = 0;
    while( Counter<100 )
    
        % query instrument error
        try
            [Result, count, msg] = query( InstrObj, 'SYST:ERR?' );
        catch err
            disp ('*** Cannot query instrument.');
            disp (['*** Matlab error message : ' err.message]);
            if( CloseConn ), fclose( InstrObj ); end
            return;
        end
        
        % no response
        if( count==0 ); break; end;
        
        % no more errors
        if( Result(1)=='0' ); break; end;
        
        % show error
        disp( Result );
        Error = 1;
        
        Counter = Counter+1;
        
    end

    % close connection
    if( CloseConn )
        try
            fclose( InstrObj );
        catch err
            disp( '*** Cannot close instrument connection.' );
            disp(['*** Matlab error message : ' err.message]);
            return;
        end
    end
    
    % set return status
    Status = ~Error;

    return;

%end of file
