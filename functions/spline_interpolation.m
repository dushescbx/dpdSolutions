function [signal] = spline_interpolation(signal, param)
% spline interpolation
signal.tx_int = (0: param.DataL*param.sampsPerSym*param.IF - 1) / param.Fs / param.IF;
signal.yq = spline(signal.to, signal.yc, signal.tx_int); %% interpolated samples
% % normalize to 1
% yq = yq/max(yq);
% figure;
% plot(real(yq));
% figure;
% plot(imag(yq));