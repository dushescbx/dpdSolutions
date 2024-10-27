function [iq,samplerate] = load_iq_tar_file(filename)
%SAVE_IQ_TAR_FILE Saves I/Q data to an iq-tar file.
%  [IQ,SAMPLERATE] = LOAD_IQ_TAR_FILE(FILENAME) loads I/Q data
%  from a given iq-tar file and also returns the sample rate.
%
%  FILENAME:   Filename, e.g. "my.iq.tar".
%
%  IQ:         Complex or real-valued data in the unit Volts.
%              IQ can be a vector or a matrix.
%              If IQ is a matrix the columns represent the channels
%              of a multi-channel signal (e.g. MIMO).
%  SAMPLERATE: Sample rate of the captured data in Hz.
%
%  Example:
%    N = 2000;
%    samplerate = 1e6
%    iq = cos(2*pi*1/40*(0:N-1)) + randn(1,N);
%    filename = 'example.iq.tar'
%    save_iq_tar_file(iq,filename,samplerate)
%    [iq,samplerate] = load_iq_tar_file(filename);
%    plot(abs(iq));
%
% See also SAVE_IQ_TAR_FILE.

% ============================================================================
% Copyright 2015-02-12 Rohde & Schwarz GmbH & Co. KG
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%   http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
% ============================================================================


%===================================================================================
% Init return values
%===================================================================================

iq = [];
samplerate = 0;

%===================================================================================
% Untar files into a temporary directory
%===================================================================================

% Generate a unique tempdirectory to untar the iq-tar file
temp_directory_for_untar = tempname;

% Create temp directory and untar iq-tar file
filenames = untar(filename,temp_directory_for_untar);

%===================================================================================
% Get I/Q parameter XML file
%===================================================================================

% Search (first) I/Q parameter XML file
% Note: Only one xml file is allowed to be inside the iq-tar file.
xml_filename = '';
for k=1:length(filenames)
    [~, ~, ext] = fileparts(filenames{k});
    if strcmpi(ext,'.xml')
        xml_filename = filenames{k};
        break
    end
end

% Abort if XML file not found
if isempty(xml_filename)
    % Delete temporary directory and its files
    rmdir(temp_directory_for_untar,'s');
    % Abort loading
    warning('load_iq_tar_file:xmlFileNotFound','''%s'' contains no I/Q parameter XML file.',filename);
    return
end


%===================================================================================
% Extract XML parameters
%===================================================================================

% Load xml tree
xml = xmlread(xml_filename);

% Get <Samples> (number of samples)
Samples = 0;
tags = xml.getElementsByTagName('Samples');
if tags.getLength > 0
    childNode = tags.item(0).getFirstChild;
    childData = childNode.getData;
    Samples   = str2double(char(childData));
end

% Get <NumberOfChannels>
NumberOfChannels = 1; % default value (if XML element does not exist)
tags = xml.getElementsByTagName('NumberOfChannels');
if tags.getLength > 0
    childNode = tags.item(0).getFirstChild;
    childData = childNode.getData;
    NumberOfChannels   = str2double(char(childData));
end

% Get <Clock> in Hz
samplerate = 0;
tags = xml.getElementsByTagName('Clock');
if tags.getLength > 0
    childNode = tags.item(0).getFirstChild;
    childData = childNode.getData;
    samplerate   = str2double(char(childData));
end

% Get <ScalingFactor> in V
ScalingFactor = 1; % default value (if XML element does not exist)
tags = xml.getElementsByTagName('ScalingFactor');
if tags.getLength > 0
    childNode = tags.item(0).getFirstChild;
    childData = childNode.getData;
    ScalingFactor   = str2double(char(childData));
end

% Get <Format>
Format = '';
tags = xml.getElementsByTagName('Format');
if tags.getLength > 0
    childNode = tags.item(0).getFirstChild;
    childData = childNode.getData;
    Format    = char(childData);
end

% Get <DataType>
DataType = '';
tags = xml.getElementsByTagName('DataType');
if tags.getLength > 0
    childNode = tags.item(0).getFirstChild;
    childData = childNode.getData;
    DataType   = char(childData);
end

% Get <DataFilename>
DataFilename = '';
tags = xml.getElementsByTagName('DataFilename');
if tags.getLength > 0
    childNode = tags.item(0).getFirstChild;
    childData = childNode.getData;
    DataFilename    = char(childData);
end


%===================================================================================
% Further checking
%===================================================================================

% Only allow DataType = 'float32' (in this implementation)
if ~strcmp(DataType,'float32')
    % Delete temporary directory and its files
    rmdir(temp_directory_for_untar,'s');
    % Abort loading
    warning('load_iq_tar_file:dataTypeNotSupported','DataType = ''%s'' not supported in this implementation.',DataType);
    return
end

% Check I/Q data binary file
iq_filename = '';
for k=1:length(filenames)
    [~, name, ext] = fileparts(filenames{k});
    if strcmpi([name,ext],DataFilename)
        iq_filename = filenames{k};
        break
    end
end

% Abort if I/Q data binary file file not found
if isempty(iq_filename)
    % Delete temporary directory and its files
    rmdir(temp_directory_for_untar,'s');
    % Abort loading
    warning('load_iq_tar_file:iqFileNotFound','''%s'' I/Q data binary file not found.',DataFilename);
    return
end

%===================================================================================
% Read I/Q data binary file
%===================================================================================

% Read binary data (still channelwise and I/Q-pair-wise interleaved)
fid = fopen(iq_filename);
iq = fread(fid,inf,DataType);
fclose(fid);

% Distinguish formats and apply ScalingFactor
switch lower(Format)
    case 'complex'
        % Force even length
        L = length(iq);
        L = L - mod(L,2);
        % Combine I and Q values to a complex number
        iq = iq(1:2:L) + 1i*iq(2:2:L);
        % Apply ScalingFactor
        iq = ScalingFactor * iq;
    case 'polar'
        % Force even length
        L = length(iq);
        L = L - mod(L,2);
        % Combine mag and phase values to a complex number and apply ScalingFactor to mag only.
        iq = ScalingFactor * iq(1:2:L) .* exp(1i*iq(2:2:L));
    case 'real'
        % Apply ScalingFactor
        iq = ScalingFactor * iq;
    otherwise
        % Delete temporary directory and its files
        rmdir(temp_directory_for_untar,'s');
        % Abort loading
        warning('load_iq_tar_file:formatNotSupported','Format = ''%s'' not supported in this implementation.',Format);
        return
end

% Undo channel-wise interleaving
% Check lengths first
if length(iq) ~= NumberOfChannels*Samples
    % Delete temporary directory and its files
    rmdir(temp_directory_for_untar,'s');
    % Abort loading
    warning('load_iq_tar_file:incorrectNofSamples','Incorrect number of samples in file %d ~= %d * %d.',length(iq),NumberOfChannels,Samples);
    return
end
% Number of channels = number of columns
% Number of samples (same for all channels) = number of rows
iq = reshape(iq,NumberOfChannels,Samples).';
% nof_channels = size(iq,2)
% nof_samples  = size(iq,1)


%===================================================================================
% Delete temporary directory and its files
%===================================================================================

% Delete temporary directory and its files
rmdir(temp_directory_for_untar,'s');

% END OF FUNCTION
