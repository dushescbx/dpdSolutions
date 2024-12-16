function [param, signal] = data_gen_and_params()
% test param
param.distortions_on = 0;
param.phase_offset = 0*pi/180; % reciever IQ modulator offset
param.M_NDA = 4;

param.Nsym = 50;           % Filter span in symbol durations
param.beta = 0.35;         % Roll-off factor
param.sampsPerSym = 4;    % Upsampling factor
% Parameters
param.DataL = 1e5;             % Data length in symbols
param.R = 1000;               % Data rate
param.Fs = param.R * param.sampsPerSym;   % Sampling frequency
param.IF = 2; % Interpolation factor
% Filter group delay, since raised cosine filter is linear phase and
% symmetric.
param.fltDelay = param.Nsym / (2*param.R);
% Create a local random stream to be used by random number generators for
% repeatability
hStr = RandStream('mt19937ar','Seed',0);
% Time vector sampled at sampling frequency
% signal.to = (0: param.DataL*param.sampsPerSym - 1) / param.Fs; %+ 2*param.Nsym
% Generate random data
% x = 2*randi(hStr,[0 1],DataL,1)-1;
param.M = 2; % mod index
QPSK = 1;
if QPSK
    signal.x = randi(hStr, 2^param.M, 1, param.DataL)-1; %% words
    %% to symbols
    if param.M > 1
        signal.x = exp(1i*pi/2^param.M+signal.x*1i*pi/param.M);
    else
        signal.x = exp(signal.x*1i*pi/param.M);
    end
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
% %% siglal dist
% param.delta_f = 0.1; %-0.5 ... 0.5
% param.delpa_phi = 0; %; -pi ... pi
% param.delayVec = [0]; % - length(sig) ... length(sig)
%% filter design
param.hfir = rcosdesign(param.beta, param.Nsym, param.sampsPerSym, 'sqrt');
%% filter design
param.NsymRx = param.Nsym;
param.hfirRx = rcosdesign(param.beta, param.NsymRx, param.sampsPerSym, 'sqrt'); %*param.IF
%% Test params
param.test.iterN = 1e1;
%% siglal dist
param.test.delta_f = linspace(-1/2^param.M/2 + 0.01*(1/2^param.M/2) ,...
    1/2^param.M/2 - 0.01*(1/2^param.M/2), param.test.iterN); %-0.5 ... 0.5
% param.test.delta_f = linspace(-5e-5 ,...
%     5e-5, param.test.iterN); %-0.5 ... 0.5
% param.test.delta_f = linspace(-0.5, 0.5, param.test.iterN); %-0.5 ... 0.5
param.test.delpa_phi = linspace(-pi+pi/10, pi, param.test.iterN); %; -pi ... pi
param.test.delayVec = linspace(-1, 1, param.test.iterN); % - length(sig) ... length(sig)
% param.test.delayVec = linspace(-param.sampsPerSym*param.IF, param.sampsPerSym*param.IF, param.test.iterN); % - length(sig) ... length(sig)

param.test.k1 = randi(param.test.iterN, 1, param.test.iterN);
param.test.k2 = randi(param.test.iterN, 1, param.test.iterN);
param.test.k3 = randi(param.test.iterN, 1, param.test.iterN);
param.test.delayVal = randi(10*param.test.iterN, 1, param.test.iterN);
%% costas loop
param.costasLoop.alpha = 0.132;
param.costasLoop.beta = 0.00932;