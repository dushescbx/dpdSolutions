% Design and normalize filter.
function [signalOut, param] = rx_rrc_filter(signalIn, param)
% param.rcrFilt = comm.RaisedCosineReceiveFilter(...
%     'Shape',                  'Square root', ...
%     'RolloffFactor',          param.beta, ...
%     'FilterSpanInSymbols',    param.Nsym, ...
%     'InputSamplesPerSymbol',  param.sampsPerSym, ...
%     'DecimationFactor',       1);
% Filter at the receiver.
yr = upfirdn([(signalIn);],... % zeros(param.Nsym*param.sampsPerSym/2, 1)
    param.hfir, 1, 1); %param.sampsPerSym
% yr_r = param.rcrFilt([real(signalIn); zeros(param.Nsym*param.sampsPerSym/2, 1)]);
% yr_i = param.rcrFilt([imag(signalIn); zeros(param.Nsym*param.sampsPerSym/2, 1)]);
% yr = complex(yr_r, yr_i);

% Correct for propagation delay by removing filter transients
% signalOut = yr;
% figure; plot(real(yr), '-*');
signalOut = yr(param.Nsym*param.sampsPerSym/2+1:end-param.Nsym*param.sampsPerSym/2);
% figure; plot(real(signalOut), '-x');
% Plot data.
% figure;
% stem(signal.tx, imag(signal.x), 'kx'); hold on;
% % Plot filtered data.
% plot(signal.to, imag(signal.yr), 'b-');
% plot(signal.tx_int(1:param.IF:end), 2*imag(signal.yr_int)); hold off;
% % Set axes and labels.
% xlabel('Time (ms)'); ylabel('Amplitude');
% legend('Transmitted Data','Rcv Filter Output', 'Rcv FIlter Output interp dec', ...
%     'Location','southeast')
% figure;
% stem(signal.tx, real(signal.x), 'kx'); hold on;
% % Plot filtered data.
% % plot(signal.to, real(signal.yr), 'b-');
% plot(signal.tx_int(1:param.IF:end), 2*real(signal.yr_int));
% if param.distortions_on
%     plot(signal.tx_int(1:param.IF:end), 2*real(signal.yr_int_dist));
%     legend_str = [ "Transmitted Data" "Rcv FIlter Output interp dec" ...
%     "Rcv FIlter Output interp dec distorted" ];
% else
%     legend_str = [ "Transmitted Data" "Rcv FIlter Output interp dec" ];
% end
% % Set axes and labels.
% xlabel('Time (ms)'); ylabel('Amplitude');
% legend(legend_str, 'Location','southeast')