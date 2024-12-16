function [signalOut] = spline_interpolation(signalIn, IF)
% spline interpolation
tx_int = (0 : 1/IF : length(signalIn) - 1);
tx_int = reshape(tx_int, [], 1);
signalOut = spline(0:length(signalIn) - 1, signalIn, tx_int); %% interpolated samples
% figure; 
% plot(tx_int, real(signalOut)); 
% hold on; 
% plot(0:length(signalIn) - 1, real(signalIn)); 
% 
% figure; 
% plot(tx_int, imag(signalOut)); 
% hold on; 
% plot(0:length(signalIn) - 1, imag(signalIn)); 
% plot(tx_int, imag(signalOut)); 
% % normalize to 1
% yq = yq/max(yq);
% figure;
% plot(real(yq));
% figure;
% plot(imag(yq));