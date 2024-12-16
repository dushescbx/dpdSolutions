function [signal_out, param] = tx_rrc_filter(param, signal_in)
% Design raised cosine filter with given order in symbols
% param.rctFilt3 = comm.RaisedCosineTransmitFilter(...
%   'Shape',                  'Square root', ...
%   'RolloffFactor',          param.beta, ...
%   'FilterSpanInSymbols',    param.Nsym, ...
%   'OutputSamplesPerSymbol', param.sampsPerSym);
% Upsample and filter.
yc = upfirdn([(signal_in);],... % zeros(param.Nsym/2, 1)
    param.hfir, param.sampsPerSym, 1);
% yc_r = param.rctFilt3([real(signal.x); zeros(param.Nsym/2, 1)]);
% yc_i = param.rctFilt3([imag(signal.x); zeros(param.Nsym/2, 1)]);
% yc = complex(yc_r, yc_i);
% Correct for propagation delay by removing filter transients
% signal.yc = yc;
% figure; plot(real(yc(1:2000)), '-*');
% figure; plot(real(yc(end-2000:end)), '-*');
signal_out = yc(param.sampsPerSym*param.Nsym/2+1:...
end-param.sampsPerSym*param.Nsym/2+param.sampsPerSym - 1);
% % figure;
% hold on; 
% plot(real(signal.yc(end-2000:end)), '-x');
% plot(real(signal.yc(1:2000)), '-x');