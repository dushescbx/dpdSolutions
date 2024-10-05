function [txWaveform,sampleRate,numFrames] = helperPACharGenerateOFDM(bw)
%helperPACharGenerateOFDM Generate OFDM signal
%   [X,R,N] = helperPACharGenerateOFDM generates a 5G-like OFDM waveform,
%   X, at a sample rate of R. N is the suggested number of frames.
%
%   See also PowerAmplifierCharacterizationExample.

%   Copyright 2020 The MathWorks, Inc.


% Create a local random stream for repeatable data
s = RandStream('mt19937ar','Seed',12345);

% Based on requested BW, select 5G-like parameters
switch bw
  case 5e6
    scs = 30e3;
    fftLength = 256;
    NSubcarriers = 132;  
    cpLength = 18;
    windowLength = 6;
  case 15e6
    scs = 30e3;
    fftLength = 1024;
    NSubcarriers = 456;  
    cpLength = 72;
    windowLength = 6;
  case 40e6
    scs = 30e3;
    fftLength = 2048;
    NSubcarriers = 1272;  
    cpLength = 144;
    windowLength = 8;
  case 100e6
    scs = 30e3;
    fftLength = 4096;
    NSubcarriers = 3276;  
    cpLength = 288;
    windowLength = 20;
end

M = 64;     % 64-QAM
sampleRate = scs * fftLength;
nGuardBandCarrier = fftLength - NSubcarriers;
numFrames = 30;

ofdmMod = comm.OFDMModulator;
ofdmMod.FFTLength = fftLength;
ofdmMod.NumGuardBandCarriers = [nGuardBandCarrier/2+1; nGuardBandCarrier/2];
ofdmMod.CyclicPrefixLength = cpLength;
ofdmMod.Windowing = true;
ofdmMod.WindowLength = windowLength;

waveform = zeros(fftLength+cpLength, numFrames);
refSymbols = zeros(fftLength - nGuardBandCarrier - 1, numFrames);
for p = 1:numFrames
  x = randi(s, [0 M-1], fftLength - nGuardBandCarrier - 1, 1);
  refSymbols(:,p) = qammod(x, M);
  waveform(:, p) = ofdmMod(refSymbols(:,p));
end
txWaveform = waveform(:);
