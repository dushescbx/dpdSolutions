function [signal, param] = iq_modulation(signal, param)
% IQ modulation
param.f_iq = 1.25*param.Fs;
param.g_tx = 2;
param.phi_tx = -15*pi/180;
% sin_mod_IQ = sin(signal.tx_int*param.f_iq*2*pi);
cos_mod_IQ = cos(signal.tx_int*param.f_iq*2*pi);
sin_mod_IQ = param.g_tx*sin(signal.tx_int*param.f_iq*2*pi+param.phi_tx);

% figure;
% plot(sin_mod_IQ);
% hold on
% plot(real(yq));
% figure;
% plot(imag(yq));
% hold on
% plot(cos_mod_IQ);
IQ_mod_signal_re = real(signal.yq).*cos_mod_IQ - imag(signal.yq).*sin_mod_IQ;
IQ_mod_signal_im = real(signal.yq).*sin_mod_IQ + imag(signal.yq).*cos_mod_IQ;
signal.IQ_mod_signal = complex(IQ_mod_signal_re, IQ_mod_signal_im);
% figure;
% plot(IQ_mod_signal);
% I * cos - Q * sin