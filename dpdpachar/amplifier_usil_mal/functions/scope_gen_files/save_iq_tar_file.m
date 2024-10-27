function save_iq_tar_file(iq,filename,samplerate)
%SAVE_IQ_TAR_FILE Saves I/Q data to an iq-tar file.
%  SAVE_IQ_TAR_FILE(IQ,FILENAME,SAMPLERATE) saves the I/Q data
%  in IQ of the given SAMPLERATE to the file FILENAME.
%
%  IQ:         Complex or real-valued data in the unit Volts.
%              IQ can be a vector or a matrix.
%              If IQ is a matrix the columns represent the channels
%              of a multi-channel signal (e.g. MIMO).
%  FILENAME:   Filename, e.g. "my.iq.tar".
%              If no extension is specified, the extension '.iq.tar' will be appended.
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
% See also LOAD_IQ_TAR_FILE.

% ============================================================================
% Copyright 2017-10-10 Rohde & Schwarz GmbH & Co. KG
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
%
% ============================================================================


% Check if iq is a vector or a matrix (multi-channel signal)
if isvector(iq)
    % force column vector
    iq = iq(:);
end
% => the row index is the time index, the column index is the channel

filename_iqtar = filename;
%is extension '.iq.tar'?
if ~strcmpi(filename_iqtar(end-length('.iq.tar')+1:end),'.iq.tar')
    % Append extension '.iq.tar' if filename has no '.iq.tar' - extension
    filename_iqtar = [filename_iqtar,'.iq.tar'];
end
%extract filename_base
[~,b,c]=fileparts(filename_iqtar(1:end-length('.iq.tar')));
filename_base=[b,c];


% Temporary files will be saved to the systems temp directory
temp_dir = tempname;
mkdir(temp_dir);

% Assemble filenames
filename_iqw_base  = fullfile(temp_dir,filename_base);
filename_xml  = fullfile(temp_dir,[filename_base,'.xml']);
filename_xslt_pure = 'open_IqTar_xml_file_in_web_browser.xslt';
filename_xslt = fullfile(temp_dir,filename_xslt_pure);


%===================================================================================
% Save I/Q data to binary file in float32
%===================================================================================

% Save one binary file that contains all channels interleaved
% Number of channels = number of columns
% Number of samples (same for all channels) = number of rows
nof_channels = size(iq,2);
nof_samples  = size(iq,1);

% Save binary file
[is_real_flag,dataFilenameWithExtension] = save_data_file(filename_iqw_base,iq);


%===================================================================================
% Write xml file
%===================================================================================

% Determine <Format>
Format = 'complex';
if is_real_flag
    Format = 'real';
end

% Assemble text for <Comment>
ChannelTxt = '';
if nof_channels > 1
    ChannelTxt = sprintf(' in %u channels',nof_channels);
end
Comment = sprintf('%u %s samples%s captured by %s.m (MATLAB %s) on %s',nof_samples,Format,ChannelTxt,mfilename,version,datestr(now, 'yyyy-mm-ddTHH:MM:SS'));


% save as xml file
fid = fopen(filename_xml, 'w', 'native', 'UTF-8');
if fid ~= -1
    % File could be opened
    fprintf(fid,'<?xml version="1.0" encoding="UTF-8"?>\n');
    fprintf(fid,'<!-- Please open this xml file in the web browser. If the stylesheet ''open_IqTar_xml_file_in_web_browser.xslt'' is in the same directory the web browser can nicely display the xml file. -->\n');
    fprintf(fid,'<?xml-stylesheet type="text/xsl" href="%s"?>\n',filename_xslt_pure);
    % Please increase fileFormatVersion whenever the format is changed!
    fprintf(fid,'<RS_IQ_TAR_FileFormat fileFormatVersion="2" xsi:noNamespaceSchemaLocation="http://www.rohde-schwarz.com/file/RsIqTar.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">\n');
    fprintf(fid,'  <Name>%s.m (MATLAB %s)</Name>\n',mfilename,version);
    fprintf(fid,'  <Comment>%s</Comment>\n',Comment);
    fprintf(fid,'  <DateTime>%s</DateTime>\n',datestr(now, 'yyyy-mm-ddTHH:MM:SS')); % xs:dateTime format
    fprintf(fid,'  <Samples>%u</Samples>\n',nof_samples);
    fprintf(fid,'  <Clock unit="Hz">%g</Clock>\n',samplerate);
    fprintf(fid,'  <Format>%s</Format>\n',Format);
    fprintf(fid,'  <DataType>float32</DataType>\n'); % fix here to match "save_iqw_file"
    
    fprintf(fid,'  <ScalingFactor unit="V">1</ScalingFactor>\n');
    
    if nof_channels > 1
        fprintf(fid,'  <NumberOfChannels>%u</NumberOfChannels>\n',nof_channels);
    end
    
    % Remove temporary path
    [~, xml_filename_base, xml_zExt] = myFileparts(dataFilenameWithExtension);
    fprintf(fid,'  <DataFilename>%s</DataFilename>\n',[xml_filename_base,xml_zExt]);
    
    % Write preview data
    write_preview_data_to_xml(fid,iq);
    
    fprintf(fid,'</RS_IQ_TAR_FileFormat>\n');
    fclose(fid);
else
    warning('RS:CouldNotWriteFile','Could not open "%s" for writing.',filename_xml);
end

%===================================================================================
% Creat temporary xslt (styleheet) file
%===================================================================================
save_xslt_file(filename_xslt);


%===================================================================================
% Pack to tar file
%===================================================================================

% Pack files (no compression if extension~=.tgz / .gz)
% File order in tar: xml, data , xslt.
temp_files_to_tar = {};
temp_files_to_tar{end+1} = filename_xml;
temp_files_to_tar{end+1} = dataFilenameWithExtension;
temp_files_to_tar{end+1} = filename_xslt;

filename_iqtartmp=[temp_dir,'.iq.tar'];
tar(filename_iqtartmp,temp_files_to_tar);
movefile(filename_iqtartmp,filename_iqtar);


% delete temporary files
delete(filename_xml);
delete(dataFilenameWithExtension);
delete(filename_xslt);
rmdir(temp_dir);


% END OF FUNCTION


function [is_real_flag,dataFilenameWithExtension] = save_data_file(filename,iq)
% Saves the iq data to the given filename.
% as dataformat always float32 is used.
% This function detects whether the data is complex or not.
% returns "true" if the iq data is real-valued
% iq: Vector or matrix of I/Q data
%     Number of channels = number of columns
%     Number of samples (same for all channels) = number of rows

nof_channels = size(iq,2);
%nof_samples  = size(iq,1);

is_real_flag = isreal(iq);

dataFilenameWithExtension = filename;

% Add extension to filename
if is_real_flag
    dataFilenameWithExtension = [dataFilenameWithExtension,'.real'];
else
    dataFilenameWithExtension = [dataFilenameWithExtension,'.complex'];
end

% Add number of channel information to filename
dataFilenameWithExtension = sprintf('%s.%.0fch',dataFilenameWithExtension,nof_channels);

% Always use float 32 here
dataFilenameWithExtension = [dataFilenameWithExtension,'.float32'];


% Do interleaving:
%   I/Q_[channel][index/time]
%   Example for 2 channels
%   File content = I[0][0],Q[0][0],I[1][0],Q[1][0],
%                  I[0][1],Q[0][1],I[1][1],Q[1][1],
%                  I[0][2],Q[0][2],I[1][2],Q[1][2],
%                  ...
iq = iq.';
iq = iq(:);


if is_real_flag
    % real-valued data
    
    % save as iqw file, iii
    fid = fopen(dataFilenameWithExtension,'w');
    if fid ~= -1
        % File could be opened
        fwrite(fid,single(iq),'float32');
        fclose(fid);
    else
        warning('RS:CouldNotWriteFile','Could not open "%s" for writing.',filename);
    end
    
else
    % complex data
    
    % save as iqw file, iqiqiq
    fid = fopen(dataFilenameWithExtension,'w');
    if fid ~= -1
        % File could be opened
        
        % Write I/Q interleaved
        
        %for k=1:length(iq)
        %    fwrite(fid,single(real(iq(k))),'float32');
        %    fwrite(fid,single(imag(iq(k))),'float32');
        %end
        
        % Speed optimized implementation
        iq = iq(:).';
        iq = [real(iq); imag(iq)];
        iq = iq(:);
        fwrite(fid, iq, 'float32');
        
        fclose(fid);
    else
        warning('RS:CouldNotWriteFile','Could not open "%s" for writing.',filename);
    end
    
end
% END OF FUNCTION



function write_preview_data_to_xml(fid,iq)
% Writes preview data for all channels to the xml file

nof_channels = size(iq,2);
%nof_samples  = size(iq,1);

fprintf(fid,'  <PreviewData>\n');

fprintf(fid,'    <ArrayOfChannel length="%u">\n',nof_channels);
for k=1:nof_channels
    fprintf(fid,'      <Channel>\n');
    if nof_channels>1
        fprintf(fid,'      <Name>Channel %u</Name>\n',k); % optional
        fprintf(fid,'      <Comment>Channel %u of %u</Comment>\n',k,nof_channels); % optional
    end
    write_preview_data_of_one_channel_to_xml(fid,iq(:,k));
    fprintf(fid,'      </Channel>\n');
end
fprintf(fid,'    </ArrayOfChannel>\n');

fprintf(fid,'  </PreviewData>\n');
% END OF FUNCTION


function write_preview_data_of_one_channel_to_xml(fid,iq)

% Calculate PvT preview traces
max_nof_pvt_preview_samples = 256; % Maximum number of PvT preview sample (256 arbitrarily chosen)
[PvtMinTrace,PvtMaxTrace] = calc_pvt_previewdata(iq,max_nof_pvt_preview_samples);

% Calculate Spectrum preview traces
fft_length_spectrum_preview = 256; % FFT length (2^n) for spectrum preview (256 arbitrarily chosen)
[SpectrumMinTrace,SpectrumMaxTrace] = calc_spectrum_previewdata(iq,fft_length_spectrum_preview);

% Calculate I/Q preview
NofPositiveBins = 32; % Number of bins on the positive axis (32 arbitrarily chosen)
[iq_histo_as_vector,width,height] = calc_iq_previewdata(iq,NofPositiveBins);


fprintf(fid,'        <PowerVsTime>\n');
fprintf(fid,'          <Min>\n');
fprintf(fid,'            <ArrayOfFloat length="%i">\n',length(PvtMinTrace));
for k=1:length(PvtMinTrace)
    fprintf(fid,'              <float>%i</float>\n',floor(PvtMinTrace(k))); % integer numbers are sufficient (no need to blow up the xml)
end
fprintf(fid,'            </ArrayOfFloat>\n');
fprintf(fid,'          </Min>\n');
fprintf(fid,'          <Max>\n');
fprintf(fid,'            <ArrayOfFloat length="%i">\n',length(PvtMaxTrace));
for k=1:length(PvtMaxTrace)
    fprintf(fid,'              <float>%i</float>\n',ceil(PvtMaxTrace(k))); % integer numbers are sufficient (no need to blow up the xml)
end
fprintf(fid,'            </ArrayOfFloat>\n');
fprintf(fid,'          </Max>\n');
fprintf(fid,'        </PowerVsTime>\n');
fprintf(fid,'        <Spectrum>\n');
fprintf(fid,'          <Min>\n');
fprintf(fid,'            <ArrayOfFloat length="%i">\n',length(SpectrumMinTrace));
for k=1:length(SpectrumMinTrace)
    fprintf(fid,'              <float>%i</float>\n',floor(SpectrumMinTrace(k))); % integer numbers are sufficient (no need to blow up the xml)
end
fprintf(fid,'            </ArrayOfFloat>\n');
fprintf(fid,'          </Min>\n');
fprintf(fid,'          <Max>\n');
fprintf(fid,'            <ArrayOfFloat length="%i">\n',length(SpectrumMaxTrace));
for k=1:length(SpectrumMaxTrace)
    fprintf(fid,'              <float>%i</float>\n',ceil(SpectrumMaxTrace(k))); % integer numbers are sufficient (no need to blow up the xml)
end
fprintf(fid,'            </ArrayOfFloat>\n');
fprintf(fid,'          </Max>\n');
fprintf(fid,'        </Spectrum>\n');
fprintf(fid,'        <IQ>\n');
fprintf(fid,'          <Histogram width="%i" height="%i">',width,height);
for k=1:length(iq_histo_as_vector)
    fprintf(fid,'%1i',iq_histo_as_vector(k));
end
fprintf(fid,'</Histogram>\n');
fprintf(fid,'        </IQ>\n');
% END OF FUNCTION


function [myMin,myMax] = calc_pvt_previewdata(iq,max_nof_preview_samples)
% Calculates the min and max traces for the power vs time preview diagram

if length(iq) > max_nof_preview_samples
    % Do data reduction
    
    % Keep it simple and ignore last samples
    decimation_factor = floor(length(iq)/max_nof_preview_samples);
    nof_ignored_samples_at_the_end = length(iq)-decimation_factor*max_nof_preview_samples;
    dBm = 20*log10(abs(iq(1:decimation_factor*max_nof_preview_samples)));
    dBm = reshape(dBm,decimation_factor,max_nof_preview_samples);
    myMax = max(dBm);
    myMin = min(dBm);
    
    % Handle ignored sample at the end
    if  nof_ignored_samples_at_the_end > 0
        dBm = 20*log10(abs(iq(end-nof_ignored_samples_at_the_end+1:end)));
        lastMax = max(dBm);
        lastMin = min(dBm);
        myMax(end) = max(myMax(end),lastMax);
        myMin(end) = min(myMin(end),lastMin);
    end
    
    % ready to save the preview samples
else
    % Use all samples
    dBm = 20*log10(abs(iq));
    myMax = dBm;
    myMin = dBm;
    % ready to save the preview samples
end
% END OF FUNCTION


function [myMin,myMax] = calc_spectrum_previewdata(iq,LFFT)

% Init
myMin = Inf(LFFT,1);
myMax = zeros(LFFT,1);
%myAvg = zeros(LFFT,1);

% overlap ]0,1[
overlap = 0.5;
stepInSamples = floor(LFFT*(1-overlap));

% Window
fenster = blackman(LFFT);
fenster = 1/sqrt(LFFT*mean(fenster.^2))*fenster;

% The other samples are ignored
nof_blocks = floor((length(iq)-LFFT)/stepInSamples);
for k = 0:nof_blocks-1
    idx = 1:LFFT;
    idx = idx + k*stepInSamples;
    mag2 = abs(fft(iq(idx).*fenster)).^2;
    myMin = min(myMin,mag2);
    myMax = max(myMax,mag2);
    %myAvg = myAvg + 1/nof_blocks*mag2;
end

% to dBm
myMin = 10*log10(myMin);
myMax = 10*log10(myMax);
%myAvg = 10*log10(myAvg);

% fftshift
myMin = fftshift(myMin);
myMax = fftshift(myMax);
%myAvg = fftshift(myAvg);
% END OF FUNCTION


function [iq_histo_as_vector,width,height] = calc_iq_previewdata(iq,NofPositiveBins)
% Init return values
width = 0;
height = 0;
iq_histo_as_vector = [];
% Only continue if samples present
if ~isempty(iq)
    % Maximum absolute value of real and imaginary part
    max_abs_I_or_Q = max(max(abs(real(iq(:)))), max(abs(imag(iq(:)))));
    
    % Only continue if the signal is not zero
    if max_abs_I_or_Q > 0
        % Only continue if enough bins present
        if NofPositiveBins >= 2
            width  = 2*NofPositiveBins;
            height = width;
            % I/Q plane should be a little larger than the maximum value
            my_max = max_abs_I_or_Q*NofPositiveBins/(NofPositiveBins-1.5);
            vBins = linspace(-my_max,+my_max,width);
            % Find bin index of real and imaginary values
            idx_col_I = interp1(vBins,1:length(vBins),real(iq(:)),'nearest');
            idx_row_Q = interp1(-vBins,1:length(vBins),imag(iq(:)),'nearest');
            z = accumarray([idx_row_Q,idx_col_I], 1, [height,width]);
            % Quantization
            max_count = max(9, max(z(:))); % 9*(x-1)/max_count+1>=0 for max_count>=9
            z = floor(9*(z-1)/max_count+1);
            % Prepare vector that reads the matrix row-wise
            z = z';
            iq_histo_as_vector = z(:);
        end
    end
end
% END OF FUNCTION


function [Pathstr, Name, Ext] = myFileparts(filename)
Ext =[];
[Pathstr, Name, zExt] = fileparts(filename);
while ~isempty(zExt)
    Ext = [zExt,Ext]; %#ok<AGROW>
    [~, Name, zExt] = fileparts(Name);
end
% END OF FUNCTION


function save_xslt_file(filename)
fid=fopen(filename,'w');
fprintf(fid,'<?xml version="1.0" encoding="UTF-8"?>\r\n');
fprintf(fid,'<!--\r\n');
fprintf(fid,'============================================================================\r\n');
fprintf(fid,'Copyright 2017-10-10 Rohde & Schwarz GmbH & Co. KG\r\n');
fprintf(fid,'\r\n');
fprintf(fid,'Licensed under the Apache License, Version 2.0 (the "License");\r\n');
fprintf(fid,'you may not use this file except in compliance with the License.\r\n');
fprintf(fid,'You may obtain a copy of the License at\r\n');
fprintf(fid,'\r\n');
fprintf(fid,'  http://www.apache.org/licenses/LICENSE-2.0\r\n');
fprintf(fid,'\r\n');
fprintf(fid,'Unless required by applicable law or agreed to in writing, software\r\n');
fprintf(fid,'distributed under the License is distributed on an "AS IS" BASIS,\r\n');
fprintf(fid,'WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\r\n');
fprintf(fid,'See the License for the specific language governing permissions and\r\n');
fprintf(fid,'limitations under the License.\r\n');
fprintf(fid,'============================================================================\r\n');
fprintf(fid,'-->\r\n');
fprintf(fid,'\r\n');
fprintf(fid,'\r\n');
fprintf(fid,'<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">\r\n');
fprintf(fid,'<xsl:output method="html" doctype-system="about:legacy-compat" indent="yes"/>\r\n');
fprintf(fid,'\r\n');
fprintf(fid,'\r\n');
fprintf(fid,'<xsl:template match="/RS_IQ_TAR_FileFormat">\r\n');
fprintf(fid,'\r\n');
fprintf(fid,'    <html>\r\n');
fprintf(fid,'      <head>\r\n');
fprintf(fid,'        <style>\r\n');
fprintf(fid,'body{font-family:Arial,sans-serif;background-color:white}#xmldata{display:none}table{empty-cells:show;table-layout:auto;margin-top:20px;margin-bottom:0}\r\n');
fprintf(fid,'th{background-color:#aeb5bb;border-style:none;padding:5px;font-size:large;text-align:left;vertical-align:top;font-weight:bold}\r\n');
fprintf(fid,'tbody tr:nth-child(even){background-color:#fff}tbody tr:nth-child(odd){background-color:#eff0f1}tr td:nth-child(1){font-weight:bold}\r\n');
fprintf(fid,'div.perDiv{font-size:small;font-weight:normal}tr td{border-style:solid;border-width:1px;border-color:#aeb5bb;padding:3px;vertical-align:top}\r\n');
fprintf(fid,'div.error{background-color:orangered;padding:2px}footer{font-size:smaller;border-top-style:solid;border-top-width:10px;border-top-color:#bfbfbf;padding-top:3px;margin-top:30px;padding-left:1px}\r\n');
fprintf(fid,'a{color:#008cda;text-decoration:none}\r\n');
fprintf(fid,'        </style>\r\n');
fprintf(fid,'\r\n');
fprintf(fid,'        <!-- Source code (c) by Rohde & Schwarz -->\r\n');
fprintf(fid,'        <!--<script src="RsIqTar.js" ></script>-->\r\n');
fprintf(fid,'        <script>\r\n');
fprintf(fid,'        <xsl:text disable-output-escaping="yes">\r\n');
fprintf(fid,'          <![CDATA[\r\n');
fprintf(fid,'function Iqtar(){var t=document.getElementsByTagName("RS_IQ_TAR_FILEFORMAT")[0];this.fileFormatVersion=t.getAttribute("fileFormatVersion");\r\n');
fprintf(fid,'this.Name=this.getChildValue(t,"Name");this.Comment=this.getChildValue(t,"Comment");this.DateTime=this.getChildValue(t,"DateTime");\r\n');
fprintf(fid,'this.Samples=parseInt(this.getChildValue(t,"Samples"));this.Clock=parseFloat(this.getChildValue(t,"Clock"));this.ClockUnit=this.getChildAttributeValue(t,"Clock","unit");\r\n');
fprintf(fid,'this.Format=this.getChildValue(t,"Format");this.DataType=this.getChildValue(t,"DataType");this.ScalingFactor=parseFloat(this.getChildValue(t,"ScalingFactor"));\r\n');
fprintf(fid,'this.ScalingFactorUnit=this.getChildAttributeValue(t,"ScalingFactor","unit");this.NumberOfChannels=parseInt(this.getChildValue(t,"NumberOfChannels"));\r\n');
fprintf(fid,'this.DataFilename=this.getChildValue(t,"DataFilename");this.UserData={RohdeSchwarz:{DataImportExport_MandatoryData:{},DataImportExport_OptionalData:{}}};\r\n');
fprintf(fid,'var e=t.getElementsByTagName("UserData");if(e.length){var a=e[0].getElementsByTagName("RohdeSchwarz");if(a.length){var i=a[0].getElementsByTagName("DataImportExport_MandatoryData");\r\n');
fprintf(fid,'if(i.length)for(var r=i[0].children,n=0;n<r.length;n++)switch(r[n].tagName){case"CHANNELNAMES":var l=r[n].children;\r\n');
fprintf(fid,'this.UserData.RohdeSchwarz.DataImportExport_MandatoryData.ChannelNames=[];for(var h=0;h<l.length;h++)this.UserData.RohdeSchwarz.DataImportExport_MandatoryData.ChannelNames.push(l[h].innerText);\r\n');
fprintf(fid,'break;case"CENTERFREQUENCY":var s=parseFloat(r[n].innerText),o=""+r[n].getAttribute("unit"),d=""+s+" "+o;"HZ"==o.toUpperCase()&&(d=GetFreqWithUnit(s)\r\n');
fprintf(fid,');this.UserData.RohdeSchwarz.DataImportExport_MandatoryData.CenterFrequency=d;break;default:this.UserData.RohdeSchwarz.DataImportExport_MandatoryData[""+r[n].tagName]=""+r[n].innerText\r\n');
fprintf(fid,'}var m=a[0].getElementsByTagName("DataImportExport_OptionalData");if(m.length)for(var c=m[0].getElementsByTagName("Key"),v=0;\r\n');
fprintf(fid,'v<c.length;v++){var p=""+c[v].getAttribute("name"),f=""+c[v].innerText;if(-1!==p.indexOf("[Hz]")){p=p.substring(0,p.indexOf("[Hz]"));\r\n');
fprintf(fid,'f=GetFreqWithUnit(parseFloat(f))}else if(-1!==p.indexOf("[dB]")){p=p.substring(0,p.indexOf("[dB]"));f+=" dB"}else if(-1!==p.indexOf("[dBm]")){p=p.substring(0,p.indexOf("[dBm]"));\r\n');
fprintf(fid,'f+=" dBm"}this.UserData.RohdeSchwarz.DataImportExport_OptionalData[p]=f}}}this.PreviewData={};this.PreviewData.Channel=[];\r\n');
fprintf(fid,'var g=t.getElementsByTagName("PreviewData");if(g.length){var u=this.getChildrenByTagName(g[0],"ArrayOfChannel");if(u.length){var C=this.getChildrenByTagName(u[0],"Channel");\r\n');
fprintf(fid,'if(C.length)for(var y=0;y<C.length;y++){var D={};D.Name=this.getChildValue(C[y],"Name");D.Comment=this.getChildValue(C[y],"Comment");\r\n');
fprintf(fid,'D.PowerVsTime={};var b=this.getChildrenByTagName(C[y],"PowerVsTime");if(b.length){D.PowerVsTime.Min=this.getTrace(b[0],"Min");\r\n');
fprintf(fid,'D.PowerVsTime.Max=this.getTrace(b[0],"Max")}D.Spectrum={};var w=this.getChildrenByTagName(C[y],"Spectrum");if(b.length){D.Spectrum.Min=this.getTrace(w[0],"Min");\r\n');
fprintf(fid,'D.Spectrum.Max=this.getTrace(w[0],"Max")}D.IQ={};var T=this.getChildrenByTagName(C[y],"IQ");if(T.length){var N=T[0].getElementsByTagName("Histogram");\r\n');
fprintf(fid,'if(N.length){D.IQ.width=parseInt(N[0].getAttribute("width"));D.IQ.height=parseInt(N[0].getAttribute("height"));D.IQ.histo=N[0].innerText\r\n');
fprintf(fid,'}}this.PreviewData.Channel.push(D)}}}}Iqtar.prototype.getChildrenByTagName=function(t,e){for(var a=[],i=t.children,r=0;r<i.length;r++)i[r].tagName==e.toUpperCase()&&a.push(i[r]);\r\n');
fprintf(fid,'return a};Iqtar.prototype.getChildValue=function(t,e){var a="",i=t.getElementsByTagName(e);i.length&&(a=i[0].innerText);return a};\r\n');
fprintf(fid,'Iqtar.prototype.getChildAttributeValue=function(t,e,a){var i="",r=t.getElementsByTagName(e);r.length&&(i=r[0].getAttribute(a));return i};\r\n');
fprintf(fid,'Iqtar.prototype.getTrace=function(t,e){var a=[],i=t.getElementsByTagName(e);if(i.length){var r=i[0].getElementsByTagName("ArrayOfFloat");\r\n');
fprintf(fid,'if(r.length)for(var n=r[0].children,l=0;l<n.length;l++)a.push(parseFloat(n[l].innerText))}return a};Iqtar.prototype.toHtml=function(){document.title=decodeURI(""+window.location.pathname.split("/").pop());\r\n');
fprintf(fid,'var t="";t+="<h1>"+document.title+" (of iq-tar file)</h1>";t+=''<table class="Top" >'';t+=''<thead><tr><th colspan="2" >Description</th></tr></thead>'';t+="<tbody>";if(this.Name){t+="<tr>";\r\n');
fprintf(fid,'t+="<td>Saved by</td>";t+="<td>"+this.Name+"</td>";t+="</tr>"}if(this.Comment){t+="<tr>";t+="<td>Comment</td>";t+="<td>"+this.Comment+"</td>";t+="</tr>"}if(this.DateTime){t+="<tr>";\r\n');
fprintf(fid,'t+="<td>Date &amp; Time</td>";t+="<td>"+this.DateTime.replace("T","&nbsp;&nbsp;")+"</td>";t+="</tr>"}t+="<tr>";t+="<td>Sample rate</td>";var e=0;if("HZ"==(""+this.ClockUnit).toUpperCase()){e=this.Clock;\r\n');
fprintf(fid,'t+="<td>"+GetFreqWithUnit(e)+"</td>"}else t+="<td>"+this.Clock+" "+this.ClockUnit+"</td>";t+="</tr>";t+="<tr>";t+="<td>Number of samples</td>";t+="<td>"+this.Samples+"</td>";t+="</tr>";var a=0;\r\n');
fprintf(fid,'if(this.Clock>0&&"HZ"==(""+this.ClockUnit).toUpperCase()){a=this.Samples/this.Clock;t+="<tr>";t+="<td>Duration of signal</td>";t+="<td>";t+=GetDurationWithUnit(a);t+="</td>";t+="</tr>"}t+="<tr>";\r\n');
fprintf(fid,'t+="<td>Data format</td>";t+="<td>"+this.Format+", "+this.DataType+"</td>";t+="</tr>";if(this.DataFilename){t+="<tr>";t+="<td>Data filename</td>";t+="<td>"+this.DataFilename+"</td>";\r\n');
fprintf(fid,'t+="</tr>"}t+="<tr>";t+="<td>Scaling factor</td>";if("V"==(""+this.ScalingFactorUnit).toUpperCase()){var i=this.ScalingFactor;\r\n');
fprintf(fid,'t+=Math.abs(i)>1e3?"<td>"+i/1e3+" kV</td>":Math.abs(i)<.001?"<td>"+1e6*i+" uV</td>":Math.abs(i)<1?"<td>"+1e3*i+" mV</td>":"<td>"+i+" V</td>"}else t+="<td>"+this.ScalingFactor+" "+this.ScalingFactorUnit+"</td>";\r\n');
fprintf(fid,'t+="</tr>";if(this.NumberOfChannels>1){t+="<tr>";t+="<td>Number of channels</td>";t+="<td>"+this.NumberOfChannels+"</td>";t+="</tr>"}t+="</tbody>";t+="</table>";\r\n');
fprintf(fid,'var r=this.UserData.RohdeSchwarz.DataImportExport_MandatoryData;if(Object.keys(r).length>0){t+=''<table class="Top" >'';t+="<tbody>";\r\n');
fprintf(fid,'t+=''<tr><th colspan="2" class="ChHd">DataImportExport_MandatoryData</th></tr>'';for(var n in r)if(r.hasOwnProperty(n)){var l=r[n];t+="<tr>";t+="<td>"+n+"</td>";\r\n');
fprintf(fid,'if("[object Array]"===Object.prototype.toString.call(l)){t+="<td>";for(var h=0;h<l.length;h++)t+="<div>"+l[h]+"</div>";t+="</td>"}else t+="<td>"+l+"</td>";t+="</tr>"}t+="</tbody>";\r\n');
fprintf(fid,'t+="</table>"}var s=this.UserData.RohdeSchwarz.DataImportExport_OptionalData;if(Object.keys(s).length>0){t+=''<table class="Top" >'';t+="<tbody>";t+=''<tr><th colspan="2" class="ChHd">DataImportExport_OptionalData</th></tr>'';\r\n');
fprintf(fid,'for(var n in s)if(s.hasOwnProperty(n)){var l=s[n];t+="<tr>";t+="<td>"+n+"</td>";t+="<td>"+l+"</td>";t+="</tr>"}t+="</tbody>";t+="</table>"}if(this.PreviewData&&this.PreviewData.Channel)\r\n');
fprintf(fid,'for(var o=0;o<this.PreviewData.Channel.length;o++){t+=''<table class="Top" >'';t+="<tbody>";t+=''<tr><th colspan="2" class="ChHd">'';\r\n');
fprintf(fid,'t+=this.PreviewData.Channel[o].Name?this.PreviewData.Channel[o].Name:"Channel "+(o+1);t+="</th></tr>";if(this.PreviewData.Channel[o].Comment){t+="<tr>";t+="<td>Comment</td>";\r\n');
fprintf(fid,'t+="<td>"+this.PreviewData.Channel[o].Comment+"</td>";t+="</tr>"}if(this.PreviewData.Channel[o].PowerVsTime){t+="<tr>";t+=''<td><div>Power vs time</div><div class="perDiv" id="divLabelpvt''+o+''" /></td>'';\r\n');
fprintf(fid,'t+=''<td><div id="divpvt''+o+''" ></div></td>'';t+="</tr>"}if(this.PreviewData.Channel[o].Spectrum){t+="<tr>";t+=''<td><div>Spectrum</div><div class="perDiv" id="divLabelspec''+o+''" /></td>'';\r\n');
fprintf(fid,'t+=''<td><div id="divspec''+o+''" ></div></td>'';t+="</tr>"}if(this.PreviewData.Channel[o].IQ){t+="<tr>";t+=''<td><div>I/Q</div><div class="perDiv" id="divLabeliq''+o+''" /></td>'';\r\n');
fprintf(fid,'t+=''<td><div id="diviq''+o+''" ></div></td>'';t+="</tr>"}t+="</tbody>";t+="</table>"}t+="<footer>";t+=''<div>E-mail: <a href="mailto:info@rohde-schwarz.com">info@rohde-schwarz.com</a></div>'';\r\n');
fprintf(fid,'t+=''<div>Internet: <a href="http://www.rohde-schwarz.com" >http://www.rohde-schwarz.com</a></div>'';this.fileFormatVersion&&(t+="<div>Fileformat version: "+this.fileFormatVersion+"</div>");\r\n');
fprintf(fid,'document.getElementById("AddJavaScriptGeneratedContentHere").innerHTML=t;if(this.PreviewData&&this.PreviewData.Channel)for(var o=0;o<this.PreviewData.Channel.length;o++)\r\n');
fprintf(fid,'{this.PreviewData.Channel[o].PowerVsTime&&drawPreview("pvt"+o,this.PreviewData.Channel[o].PowerVsTime.Min,this.PreviewData.Channel[o].PowerVsTime.Max,a);\r\n');
fprintf(fid,'this.PreviewData.Channel[o].Spectrum&&drawPreview("spec"+o,this.PreviewData.Channel[o].Spectrum.Min,this.PreviewData.Channel[o].Spectrum.Max,e);\r\n');
fprintf(fid,'this.PreviewData.Channel[o].IQ&&drawIqPreview("iq"+o,this.PreviewData.Channel[o].IQ)}};function drawPreview(t,e,a,i){if(e.length==a.length&&e.length>0)\r\n');
fprintf(fid,'{var r=e.length,n=r/2,l=document.createElement("canvas");l.setAttribute("width",r+1);l.setAttribute("height",n+1);l.setAttribute("id",t);document.getElementById("div"+t).appendChild(l);\r\n');
fprintf(fid,'var h=l.getContext("2d"),s=e.min(),o=a.max(),d=.025,m=o-s;s-=d/(1-2*d)*m;o+=d/(1-2*d)*m;m=o-s;isNaN(s)&&(s=-150);isNaN(o)&&(o=50);var c=0,v=.5*n;if(o>s){c=1/(s-o)*n;v=-c*o}h.strokeStyle="#AEB5BB";h.fillStyle="#AEB5BB";\r\n');
fprintf(fid,'var p=getPerDivision(s,o),f="";if(p>0){f="<div>y-axis: "+p+" dB /div</div>";for(var g=Math.ceil(s/p)*p;o>g;g+=p)h.fillRect(.5,g*c+v-.5,r,1)}var u="";if(0==t.search("pvt")){var C=getPerDivision(0,i);\r\n');
fprintf(fid,'if(C>0){u="<div>x-axis: "+GetTimeWithUnit(C)+" /div</div>";for(var y=e.length/i,D=C;i>D;D+=C)h.fillRect(y*D,.5,1,n)}}else if(0==t.search("spec")){var C=getPerDivision(-.5*i,.5*i);\r\n');
fprintf(fid,'if(C>0){u="<div>x-axis: "+GetFreqWithUnit(C)+" /div</div>";for(var y=e.length/i,b=.5*e.length,D=Math.ceil(-.5*i/C)*C;.5*i>D;D+=C)h.fillRect(y*D+b,.5,1,n)}}h.strokeStyle="#0000FF";h.fillStyle="#0000FF";\r\n');
fprintf(fid,'for(var w=0;w<e.length;w++){var T=e[w],N=a[w];isNaN(T)&&(T=s);isNaN(N)&&(N=o);h.fillRect(w,N*c+v,1,(T-N)*c)}h.strokeStyle="#000000";h.fillStyle="#000000";h.strokeRect(.5,.5,r,n);\r\n');
fprintf(fid,'document.getElementById("divLabel"+t).innerHTML="<br/>"+f+u}else if(0==a.length||0==e.length);else{var F="";F+=''<div class="error">Error: Min and Max preview traces have bad lengths (''+e.length+", "+a.length+").</div>";\r\n');
fprintf(fid,'document.getElementById("div"+t).innerHTML=F}}function drawIqPreview(t,e){if(e.histo.length==e.width*e.height&&e.histo.length>0){var a=2,i=a*e.width,r=a*e.height,n=document.createElement("canvas");\r\n');
fprintf(fid,'n.setAttribute("width",i);n.setAttribute("height",r);n.setAttribute("id",t);document.getElementById("div"+t).appendChild(n);for(var l=n.getContext("2d"),h=0,s=0;r>s;s+=a)for(var o=0;i>o;o+=a)\r\n');
fprintf(fid,'{var d=e.histo.charAt(h++);switch(d){case"0":break;case"1":l.fillStyle="#E3E3FF";l.fillRect(o,s,a,a);break;case"2":l.fillStyle="#C6C6FF";l.fillRect(o,s,a,a);break;case"3":l.fillStyle="#AAAAFF";\r\n');
fprintf(fid,'l.fillRect(o,s,a,a);break;case"4":l.fillStyle="#8E8EFF";l.fillRect(o,s,a,a);break;case"5":l.fillStyle="#7171FF";l.fillRect(o,s,a,a);break;case"6":l.fillStyle="#5555FF";l.fillRect(o,s,a,a);break;\r\n');
fprintf(fid,'case"7":l.fillStyle="#3939FF";l.fillRect(o,s,a,a);break;case"8":l.fillStyle="#1C1CFF";l.fillRect(o,s,a,a);break;default:l.fillStyle="#0000FF";l.fillRect(o,s,a,a)}l.strokeStyle="#000000";\r\n');
fprintf(fid,'l.fillStyle="#000000";l.strokeRect(0,0,i,r)}}else{var m="";m+=''<div class="error">Error: I/Q preview has incorrect length (''+e.histo.length+" != "+e.width+" * "+e.height+").</div>";\r\n');
fprintf(fid,'document.getElementById("div"+t).innerHTML=m}}function getPerDivision(t,e){var a=0,i=0,r=0;if(e>t){var n=e-t;if(n>0){var l=14,h=Math.log(n/l)/Math.LN10;r=Math.floor(h);var s=h-r;i=0;if(.3>=s)i=2;else if(.69>=s)i=5;\r\n');
fprintf(fid,'else{i=1;r+=1}a=i*Math.pow(10,r)}}return a}function GetTimeWithUnit(t){var e="";e+=t>=1?NiceNo(t)+" s":t>=.001?NiceNo(1e3*t)+" ms":t>=1e-6?NiceNo(1e6*t)+" us":t+" s";return e}\r\n');
fprintf(fid,'function GetDurationWithUnit(t){var e="",a=31536e3,i=Math.floor(t/a);if(i>0){e+=i+" year";i>1&&(e+="s");e+="&nbsp;&nbsp;&nbsp;";t-=i*a}a=86400;i=Math.floor(t/a);if(i>0){e+=i+" day";i>1&&(e+="s");\r\n');
fprintf(fid,'e+="&nbsp;&nbsp;&nbsp;";t-=i*a}a=3600;i=Math.floor(t/a);if(i>0){e+=i+" h&nbsp;&nbsp;&nbsp;";t-=i*a}a=60;i=Math.floor(t/a);if(i>0){e+=i+" min&nbsp;&nbsp;&nbsp;";t-=i*a}e+=GetTimeWithUnit(t);\r\n');
fprintf(fid,'e=e.replace(/(&nbsp;)+$/,"");return e}function NiceNo(t){var e=3,a=""+t.toFixed(e);a=a.replace(/[0]+$/,"");a=a.replace(/[.]$/,"");return a}function GetFreqWithUnit(t){var e="";\r\n');
fprintf(fid,'e+=t>=1e9?t/1e9+" GHz":t>=1e6?t/1e6+" MHz":t>=1e3?t/1e3+" kHz":t+" Hz";return e}Array.prototype.max=function(){return Math.max.apply({},this)};Array.prototype.min=function(){return Math.min.apply({},this)};          \r\n');
fprintf(fid,'          ]]>\r\n');
fprintf(fid,'        </xsl:text>\r\n');
fprintf(fid,'        </script>\r\n');
fprintf(fid,'\r\n');
fprintf(fid,'\r\n');
fprintf(fid,'      <script>\r\n');
fprintf(fid,'        window.onload = function()\r\n');
fprintf(fid,'        {\r\n');
fprintf(fid,'          // Generate html from xml data\r\n');
fprintf(fid,'          var obj = new Iqtar();\r\n');
fprintf(fid,'\r\n');
fprintf(fid,'          // Render html preview document\r\n');
fprintf(fid,'          obj.toHtml();\r\n');
fprintf(fid,'\r\n');
fprintf(fid,'          // Uncomment for debugging\r\n');
fprintf(fid,'          console.log("FINE @ " + Date().toString() );\r\n');
fprintf(fid,'        };\r\n');
fprintf(fid,'      </script>\r\n');
fprintf(fid,'      </head>\r\n');
fprintf(fid,'      <body>\r\n');
fprintf(fid,'\r\n');
fprintf(fid,'        <!-- Embedding original iq-tar xml content -->\r\n');
fprintf(fid,'        <xml id="xmldata">\r\n');
fprintf(fid,'          <xsl:copy-of select="/RS_IQ_TAR_FileFormat" />\r\n');
fprintf(fid,'        </xml>\r\n');
fprintf(fid,'\r\n');
fprintf(fid,'        <div id="AddJavaScriptGeneratedContentHere"></div>\r\n');
fprintf(fid,'\r\n');
fprintf(fid,'      </body>\r\n');
fprintf(fid,'    </html>\r\n');
fprintf(fid,'\r\n');
fprintf(fid,'  </xsl:template>\r\n');
fprintf(fid,'\r\n');
fprintf(fid,'</xsl:stylesheet>\r\n');
fclose(fid);
% END OF FUNCTION
