function [param] = Params()

%% sine params
param.PAModel.SineFreqDistr = 0; % 0 - discrete distr, 1 - uniformly distr sines
param.PAModel.SineinitPhaseSel = 0; % 0 - random init phase, 1 - zero init phase

%% Mat PA model params

param.MatPAModel = 1; % 1 - математическая модель усилителя, 0 - реальные данные

% тестовый сигнал в реальном устройстве
% (0 - гарм, 1 - OFDM 15MHz, 2 - OFDM 40MHz,
% 3 - OFDM 100 MHz
param.MatPARealSigSel = 0;
param.MatPAModelSel = 0; % 0 - Cubic poly, 1 - Wiener model
param.PAModel.M = 4; % Modulation order
% test signal select
% 1 - QAM, 0 - sine
param.PAModel.signalSel = 1;
param.PAModel.sps = 4; %4; % Samples per symbol
param.PAModel.pindBm = [19]; % Input power (dBm)
% cubic PA model
param.PAModel.Cubic.gain = 100; % Amplifier gain
param.PAModel.Cubic.AMPMConversion = 0.5/4; % AMPMConversion cubic poly
% Saleh PA model
param.PAModel.Saleh.InputScaling = 0;
param.PAModel.Saleh.AMAMParameters = [2.1587 1.1517];
param.PAModel.Saleh.AMPMParameters = [4.0033 9.1040];
param.PAModel.Saleh.OutputScaling = 25;
% filter model
param.PAModel.Filter.num = [0 [ .25]*exp(j*pi/4)];     % phase offset
param.PAModel.Filter.den = [1 -.75*(1+j)/sqrt(2)]; % complex denominator
%
param.PAModel.Fs = 200e6;
param.PAModel.DataLen =  1e6; % samples number
param.PAModel.snr = 100;
param.PAModel.RefImp = 50;
param.PAModel.beta = 0.35;
param.PAModel.Nsym = 6*70;
param.PAModel.R = 1e6; % Data rate
param.PAModel.interpFactor = param.PAModel.Fs/param.PAModel.R/param.PAModel.sps; % 1; %
% param.PAModel.interpFactor = param.PAModel.DataLen/param.PAModel.R/param.PAModel.sps; % 1;
% sine
if param.PAModel.SineFreqDistr == 0
    param.PAModel.sineFreq = [7.5e6; 20e6;]; % 1e5
elseif param.PAModel.SineFreqDistr == 1
    param.PAModel.SineStartFreq = -param.PAModel.R/2;
    param.PAModel.SineStopFreq = param.PAModel.R/2;
    param.PAModel.SineN = 10;
    param.PAModel.sineFreq = linspace(param.PAModel.SineStartFreq,...
        param.PAModel.SineStopFreq, param.PAModel.SineN).';
end

param.PAModel.sineOversamplingRate = param.PAModel.sps ...
    * param.PAModel.interpFactor;
if ~param.MatPAModel
    param.PAModel.Fs = 200e6;
elseif param.PAModel.signalSel == 1
    param.PAModel.Fs = param.PAModel.R * param.PAModel.sps ...
        * param.PAModel.interpFactor; % Sampling frequency
else
    param.PAModel.Fs = param.PAModel.sineOversamplingRate * 2 * max(param.PAModel.sineFreq);
end
param.PAModel.fltDelay = param.PAModel.Nsym / (2*param.PAModel.R);
%% interpolate params
param.overSamplingRate = param.PAModel.sps * param.PAModel.interpFactor;
param.filterLength = 6*70;
%%
PACharSavedDataParam;
%% PA model select
param.modType = 'memPoly'; % 'ctMemPoly'; memPoly
%% PA model params
param.memLen = 5; % глубина памяти
param.degLen = 5; % степень нелинейности памяти
%% grid search
param.GridSearch.On = 0; %поиск оптимальных значений memLen, degLen
param.GridSearch.MemLen = 5;
param.GridSearch.PolyLen = 11;
%% swap signals
param.swapSignals = 0; % нахождение коэффов фильтра по одному сигналу
% (сумма гармонических сигналов), а поиск ошибки модели по другому
%% sync sequence adding
param.Nsync = 1e2;
param.syncData = randi([0 param.PAModel.M-1],...
    ceil((param.Nsync)),1);


%% PA linear gain
if param.MatPAModel
    if param.MatPAModelSel
        param.PAModel.PALinearGain...
            = param.PAModel.Saleh.OutputScaling;%% не учитывается inputScaling
    else
        param.PAModel.PALinearGain =...
            param.PAModel.Cubic.gain;
    end
else
    param.PAModel.PALinearGain = 0; %% ??????????? добавить
end
