clear all
close all

%% words gen
M = 2; % mod index
n = 1e3; % num of samples
interp_factor = 10; % interpolation factor
X = randi(2^M, 1, n)-1; %% words
%% to symbols
Sym_out = exp(1i*pi/4+X*1i*pi/2);
% %%
% figure;
% plot(Sym_out);
%% фильтрация и интерполяция
filtlen = 10; % Filter length in symbols
rolloff = 0.5; % Filter rolloff factor
sps = 8; % samples per symbol
rrcFilter = rcosdesign(rolloff,filtlen,sps,'sqrt'); % rrc filter
txFiltSignal = upfirdn([Sym_out], rrcFilter, sps, 1); % upsample by sps and filter

txFiltSignal_nt = txFiltSignal(1+filtlen/2*sps:end-(filtlen-1)/2*sps+1); % signal without filter transients

%% spline interpolation
x = 1 : length(txFiltSignal_nt); %% original signal sample times
y = txFiltSignal_nt; %% original samples
xq = 1 : 1/interp_factor : length(txFiltSignal_nt) + 1 - 1/interp_factor; %% interpolation signal sample times
yq = spline(x,y,xq); %% interpolated samples
%% compare sym and filtered sym
figure;
stem(1:length(Sym_out), real(Sym_out), 'kx');
hold on
plot(1:1/sps:length(txFiltSignal_nt)/sps+1-1/sps, real(txFiltSignal_nt));
plot(1:1/sps/interp_factor:length(Sym_out)+3/4-1/sps/interp_factor, real(yq));

%% generate sin and cos for IQ modulation
period_in_samples = 5;
sin_mod_IQ = sin((1:length(xq))/period_in_samples*2*pi);
cos_mod_IQ = cos((1:length(xq))/period_in_samples*2*pi);
%% 
figure;
plot(sin_mod_IQ);
hold on
plot(cos_mod_IQ);
%% ideal IQ modulation
I = real(yq);
Q = imag(yq);
IQ_mod_signal = I.*cos_mod_IQ - Q.*sin_mod_IQ;


%% distortions of IQ modulation
IQ_mod_signal_dist = IQ_mod_signal + 0.2*(IQ_mod_signal.^3);
% %%
% figure;
% plot(IQ_mod_signal);
% hold on
% plot(IQ_mod_signal_dist);

%% IQ demodulation
I_demod_signal = IQ_mod_signal .* cos_mod_IQ;
Q_demod_signal = IQ_mod_signal .* (-1*sin_mod_IQ);
rx_signal = complex(I_demod_signal, Q_demod_signal);
figure;
plot(Q_demod_signal);
hold on
plot(Q);

%% RRC filter
rxFiltSignal = upfirdn([rx_signal], rrcFilter, 1, 1); % filter

rcrFilt = comm.RaisedCosineReceiveFilter(...
  'Shape',                  'Square root', ...
  'RolloffFactor',          rolloff, ...
  'FilterSpanInSymbols',    filtlen, ...
  'InputSamplesPerSymbol',  sps, ...
  'DecimationFactor',       1);
% Filter at the receiver.
yr = rcrFilt([rx_signal.'; zeros(filtlen*sps/2, 1)]);
yr = yr(1+filtlen/2*sps:end-(filtlen-1)/2*sps+1);

%% 
figure;
plot(imag(rxFiltSignal(1+filtlen/2*sps:end-(filtlen-1)/2*sps+1)));
hold on
plot(imag(yq));
plot(imag(yr));
legend('rx sig', 'tx sig', 'rx sig comm');
% %% gardner symbol det
% symbol_rate = 1;
% [ tx_symbol ] = symbol_recovery( rxFiltSignal, symbol_rate, sps, interp_factor);
% figure;
% plot(real(tx_symbol));
% hold on
% plot(real(Sym_out));