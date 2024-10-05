function [OutputWaveformFitMemless, pa] = ...
    PAMemlessModel(inOutTable, InputWaveform,...
    OutputWaveform, sampleRate, RefImp, figEn)
pa = comm.MemorylessNonlinearity('Method','Lookup table','Table',...
    inOutTable,'ReferenceImpedance', RefImp);

OutputWaveformFitMemless = pa(InputWaveform);
err = abs(OutputWaveform - OutputWaveformFitMemless)./abs(OutputWaveform);
rmsErrorMemless = rms(err)*100;
disp(['Percent RMS error in time domain is ' num2str(rmsErrorMemless) '%'])
if figEn
    figure;
    plot(real(OutputWaveform))
    hold on
    plot(real(OutputWaveformFitMemless))
    title('OutputWaveform Ref and Fit memless');
    legend('ref', 'fit memless');
    figure;
    plot(imag(OutputWaveform))
    hold on
    plot(imag(OutputWaveformFitMemless))
    title('OutputWaveform Ref and Fit memless');
    legend('ref', 'fit memless');
    %% output sig compare
    PACharPlot(OutputWaveform, ...
        OutputWaveformFitMemless,...
        sampleRate);
    
    %% output gain compare
    PACharModelCompare(InputWaveform,...
        OutputWaveform, OutputWaveformFitMemless);
end