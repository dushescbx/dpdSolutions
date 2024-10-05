function [txWaveform] = Gen2TonesSig(f1, f2, SR, sN)

swg = dsp.SineWave([1 1],[f1 f2],...
  'ComplexOutput',true,...
  'SampleRate',SR,...
  'SamplesPerFrame',sN);

txWaveform = awgn(sum(swg(),2),30);

figure; plot(abs(fft(txWaveform)))