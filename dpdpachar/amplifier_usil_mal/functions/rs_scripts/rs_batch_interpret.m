% function rs_batch_interpret
% *************************************************************************
% 
% Copyright: (c) 2011 Rohde & Schwarz GmbH & CO KG.    All rights reserved.
%                Muehldorfstr. 15
%                D-81671 Munich
%
% ************************************************************************* 
% This function reads a text file containing commands and queries in 
% arbitrary order and type, sends them to the remote device and displays the 
% queries' results.
%%
% @param InstrObj    Object for remote instrument created by rs_connect.
% @param filename    The name of the text file (.txt) containig the SCPI 
%                    command and query strings. Comments can be included
%                    using the Matlab format of putting a '%' at the
%                    beginning of the line.
% @param output      If 1, the processed lines are displayed with line
%                    number and result (when query)
%%
% @return Status     Status = 0, if file could not properly be processed.         
%                    Status = 1, if file processing was successful.
% @return Result     <1xn>struct of returned results. All results are counted by
%                    consecutive numbers. For example the third query's result
%                    is stored in 'result(3).text'.                    
%**************************************************************************

function [Status, result] = rs_batch_interpret( InstrObj, filename, output )
    
    Status = 0;

    % check number of arguments
    if (nargin ~= 3)
        disp ('*** Wrong number of input arguments to rs_batch_interpret().')
        return;
    end

    % check first argument to be an object
    if (isobject(InstrObj) ~= 1)
        disp ('*** The first parameter is not an object.');
        return;
    end
    if (isvalid(InstrObj) ~= 1)
        disp ('*** The first parameter is not a valid object.');
        return;
    end

    % check file name to be a string
    if (isempty(filename) || (ischar(filename)~= 1))
        disp ('*** File name is empty or not a string.');
        return;
    end

    % check if batch file exists
    [fid, message] = fopen (filename, 'r');
    if fid == -1
         disp (['*** fopen() returned: ' message]);
         return;
    end

    linecnt = 0;
    resnum  = 0;

    % process file
    while 1
        linecnt = linecnt+1;
        
        % read next line
        comline = fgetl(fid);
        
        % returns -1 if no more data
        if (~ischar(comline))
            break;
        end
        
        % igore blank lines
        if (numel(comline) == 0)
            continue;
        end
        
        % exclude comments
        if (comline(1) == '%')
            continue;
        end
        
        % query
        if ~(isempty(strfind(comline, '?')))
            resnum = resnum + 1;
            [stat, res] = rs_send_query (InstrObj, comline);
            if (stat < 1)
                disp (['*** Failure processing : ' comline]);
                break;
            end
            result(resnum).text = res;
            if (output == 1)
                disp (['<<< ' num2str(linecnt) '  ' comline]);
                disp (['>>> ' num2str(resnum)  '  ' result(resnum).text]);
            end
            continue
        end
        
        % command
        if (output == 1)
            disp (['<<< ' num2str(linecnt) '  ' comline]);
        end
        [stat] = rs_send_command (InstrObj, comline);
        if (stat < 1)
            disp (['*** Failure processing : ' comline]);
            break;
        end
    end   

    fclose(fid);
    
    Status = 1;

    return;

%end of file
