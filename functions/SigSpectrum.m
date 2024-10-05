function sa = SigSpectrum(paInput, sampleRate,...
    testSignal, bw, desc, sel, fig_en)
if fig_en
    % paInput = reshape(paInput, [], 1);
    sa = dsp.SpectrumAnalyzer;
    sa.SpectrumType = 'Power';
    sa.SampleRate = sampleRate;
    sa.SpectralAverages = 16;
    sa.ReferenceLoad = 100;
    if strcmp(testSignal, "Tones")
        sa.DistortionMeasurements.Enable = true;
        sa.DistortionMeasurements.Algorithm = "Intermodulation";
        if sel
            sa.YLimits = [-80 60];
        else
            sa.YLimits = [-80 40];
        end
    else
        if sel
            sa.YLimits = [-80 30];
        else
            sa.ChannelMeasurements.Enable = true;
            sa.ChannelMeasurements.Span = bw;
            sa.YLimits = [-100 20];
        end
    end
    sa(paInput)
    if sel
        sa.ChannelNames = desc;

    else
        sa.ChannelNames = {'PA Input'};
    end
    sa.ShowLegend = true;
else
    sa = [];
end
