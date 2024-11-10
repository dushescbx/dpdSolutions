function [param, signal] = data_gen_and_params()
% test param
param.distortions_on = 0;
param.phase_offset = 0*pi/180; % reciever IQ modulator offset
param.M_NDA = 4;

param.Nsym = 50;           % Filter span in symbol durations
param.beta = 0.35;         % Roll-off factor
param.sampsPerSym = 2;    % Upsampling factor
% Parameters
param.DataL = 1e5;             % Data length in symbols
param.R = 1000;               % Data rate
param.Fs = param.R * param.sampsPerSym;   % Sampling frequency
param.IF = 1; % Interpolation factor
% Filter group delay, since raised cosine filter is linear phase and
% symmetric.
param.fltDelay = param.Nsym / (2*param.R);
% Create a local random stream to be used by random number generators for
% repeatability
hStr = RandStream('mt19937ar','Seed',0);
% Time vector sampled at sampling frequency
signal.to = (0: param.DataL*param.sampsPerSym - 1) / param.Fs; %+ 2*param.Nsym 
% Generate random data
% x = 2*randi(hStr,[0 1],DataL,1)-1;
param.M = 2; % mod index
QPSK = 1;
if QPSK
    signal.x = randi(hStr, 2^param.M, 1, param.DataL)-1; %% words
    %% to symbols
    signal.x = exp(1i*pi/4+signal.x*1i*pi/2);
    signal.x = reshape(signal.x, [], 1);
else
    Nperiods = 10;
    NsampPeriod = param.DataL/Nperiods;
    n = 0:param.DataL - 1;
    % f = 1/NsampPeriod;
    f = 0.1;
    signal.x = cos(2*pi*f*n) + 1i*sin(2*pi*f*n);
    figure; plot(real(signal.x)); hold on; plot(imag(signal.x));
    signal.x = reshape(signal.x, [], 1);
end
% Time vector sampled at symbol rate
signal.tx = (0: param.DataL - 1) / param.R;
%% siglal dist
param.delta_f = 0; %0.01*length(x); %0.1*length(x);% ; %; %0.1*length(x)
param.delpa_phi = pi/8; %pi/8; %;
param.delayVec = [0];
%% filter design
param.hfir = rcosdesign(param.beta, param.Nsym, param.sampsPerSym, 'sqrt');