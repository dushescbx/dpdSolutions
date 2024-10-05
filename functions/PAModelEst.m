function [fitCoefMatMem, OutputWaveformFitMem, sa] ...
    = PAModelEst(param, InputWaveform, ...
    OutputWaveform, sampleRate, ...
    testSignal, figEn, coef)

numDataPts = length(InputWaveform);
halfDataPts = round(numDataPts/2);

fitCoefMatMem = MemPolyModel('coefficientFinder',             ...
    InputWaveform(1:halfDataPts),OutputWaveform(1:halfDataPts), ...
    param.memLen,param.degLen,param.modType);

% disp(abs(fitCoefMatMem));

rmsErrorTimeMem = MemPolyModel('errorMeasure', ...
    InputWaveform, OutputWaveform, fitCoefMatMem, param.modType);
disp(['Percent RMS error in time domain is ' num2str(rmsErrorTimeMem) '%'])
%% !!!!!!!!!!!!!!!!!!!!!!!
OutputWaveformFitMem = MemPolyModel('signalGenerator', ...
    InputWaveform, fitCoefMatMem, param.modType);
OutputWaveformFitMemSine = MemPolyModel('signalGenerator', ...
    InputWaveform, coef, param.modType);
%% !!!!!!!!!!!!!!!!!!!!!!!
% % % OutputWaveformFitMem = MemPolyModel('signalGenerator', ...
% % %     InputWaveform, [0], param.modType);
if figEn
    PACharPlot(OutputWaveform, OutputWaveformFitMem, sampleRate)
    PACharPlot(OutputWaveformFitMemSine, OutputWaveformFitMem, sampleRate)
    PACharModelCompare(InputWaveform, OutputWaveform, OutputWaveformFitMem)

sa = SigSpectrum(...
        [OutputWaveform...
        OutputWaveformFitMem...
        OutputWaveformFitMemSine ...
        InputWaveform],...
        sampleRate, testSignal, [], ...
        {'Actual PA QAM Output', 'Memory Polynomial sine Output',...
        'Memory Polynomial QAM Output', 'PA Input'}, 1, 1);
else
    sa = [];
end