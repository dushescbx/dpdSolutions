function [txWaveform,sampleRate,numFrames] = helperPACharGenerateTones()
%helperPACharGenerateTones Generate two complex tones
%   [X,R,N] = helperPACharGenerate5GNRTM generates a two tone waveform,
%   X, at a sample rate of R. N is the suggested number of frames.
%
%   See also PowerAmplifierCharacterizationExample.

%   Copyright 2020 The MathWorks, Inc.

fc1 = 1.8e6;
fc2 = 2.6e6;

numFrames = 30;
sampleRate = 15.36e6;
swg = dsp.SineWave([1 1],[fc1 fc2],...
  'ComplexOutput',true,...
  'SampleRate',sampleRate,...
  'SamplesPerFrame',numFrames*81920);

txWaveform = awgn(sum(swg(),2),30);
