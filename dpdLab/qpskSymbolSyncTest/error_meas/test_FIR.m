close all
clear all
% length_fir  = 5;
% num_sps = 4;
% hfir = rcosdesign(0.35, length_fir, num_sps, 'sqrt');
% [~, ind_max] = max(hfir);
% hprd11 = hfir;
% % hprd11 = [ 0.095 0.5 0.905 0.5 0.095 ];
% hprd11 = fi(hprd11, 1, 16, 15);
% figure;
% plot(hprd11);
%
% num_sps = fi(num_sps-1,0,2,0); % число вставляемых нулей
% num_sps_div_2 = fi(num_sps/2,0,2,0); % число вставляемых нулей/2


Nsym = 10;           % Filter span in symbol durations
beta = 0.5;         % Roll-off factor
sampsPerSym = 4;    % Upsampling factor

rctFilt3 = comm.RaisedCosineTransmitFilter(...
    'Shape',                  'Square root', ...
    'RolloffFactor',          beta, ...
    'FilterSpanInSymbols',    Nsym, ...
    'OutputSamplesPerSymbol', sampsPerSym);
% Visualize the impulse response
fvtool(rctFilt3,'Analysis','impulse')
% Parameters
DataL = 20;             % Data length in symbols
R = 1000;               % Data rate
Fs = R * sampsPerSym;   % Sampling frequency
fltDelay = Nsym / (2*R);
% Create a local random stream to be used by random number generators for
% repeatability
hStr = RandStream('mt19937ar','Seed',0);

% Generate random data
x = 2*randi(hStr,[0 1],DataL,1)-1;
% Time vector sampled at symbol rate in milliseconds
tx = 1000 * (0 : DataL - 1) / R;
to = 1000 * (0 : DataL*sampsPerSym - 1) / Fs;
% Upsample and filter.
yc = rctFilt3([x; zeros(Nsym/2,1)]);
% Correct for propagation delay by removing filter transients
yc = yc(Nsym*sampsPerSym/2+1:end);


coef = coeffs(rctFilt3).Numerator;
filt_reg = zeros(1,length(coef));
x = [x; zeros(Nsym/2,1)];
x_ups = upsample(x,sampsPerSym);

figure;
plot(to ,x_ups(1:end - Nsym/2*sampsPerSym), 'm-');
hold on
plot(tx, x(1:end - Nsym/2), 'kx');

filt_out = zeros(1, length(x_ups));
filt_reg = [x_ups(1) filt_reg(1:end-1)];

% for i = 2 : length(x_ups)
%     
%     filt_out(i-1) = filt_reg * coef';
%     filt_reg = [x_ups(i) filt_reg(1:end-1)];
%     
% end


for i = 2 : length(x_ups)
    
    filt_out(i-1) = filt_reg(1 + mod(i-2, sampsPerSym) : sampsPerSym : length(filt_reg)) * coef(1 + mod(i-2, sampsPerSym) : sampsPerSym : length(coef))';
    filt_reg = [x_ups(i) filt_reg(1:end-1)];
    
end

plot(to, filt_out(Nsym*sampsPerSym/2+1:end));

% Plot data.
stem(tx, x(1:end - Nsym/2), 'kx'); hold on;
% Plot filtered data.
plot(to, yc, 'm-'); 
plot(to, filt_out(Nsym*sampsPerSym/2+1:end));hold off;
% Set axes and labels.
axis([0 25 -1.7 1.7]);  xlabel('Time (ms)'); ylabel('Amplitude');
legend('Transmitted Data','Sqrt. Raised Cosine','Location','southeast')


%%

