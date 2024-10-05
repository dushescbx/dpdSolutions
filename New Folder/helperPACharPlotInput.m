function sa = helperPACharPlotInput(paInput,sampleRate,testSignal,bw)
%helperPACharPlotResults Plot PA characterization results
%   S = helperPACharPlotInput(PIN,R,TEST) plots the spectrum of the test
%   signal. R is the sample rate and TEST is the test signal type, which
%   can be "Tones" or "Modulated". When TEST is "Modulated", channel
%   bandwidth, BW, is used to measure channel power.
%
%   See also PowerAmplifierCharacterizationExample.

%   Copyright 2020 The MathWorks, Inc.

sa = dsp.SpectrumAnalyzer;
sa.SpectrumType = 'Power';
sa.SampleRate = sampleRate;
sa.SpectralAverages = 16;
sa.ReferenceLoad = 100;
if strcmp(testSignal, "Tones")
  sa.DistortionMeasurements.Enable = true;
  sa.DistortionMeasurements.Algorithm = "Intermodulation";
  sa.YLimits = [-80 40];
else
  sa.ChannelMeasurements.Enable = true;
  sa.ChannelMeasurements.Span = bw;
  sa.YLimits = [-100 20];
end
sa(paInput)
sa.ChannelNames = {'PA Input'};
sa.ShowLegend = true;

