function d_out =...
    timing_phase_freq_offset(d_in,...
    delta_f,delpa_phi,delayVec)
%%
L = length(d_in);
d_in = reshape(d_in, [], 1);
d_inZeros = d_in;
% d_inZeros = [zeros(1,1); d_in; zeros(1,1);]; 
t = 0 : length(d_inZeros) - 1;
t = reshape(t, [], 1);

%% сдвиг частоты и фазы
ind = (0:1:L-1).';
exp_freq_shift=exp(2*pi*1i*delta_f*ind + 1i*delpa_phi);
% exp_freq_shift=exp(2*pi*1i*delta_f*ind/length(ind) + 1i*delpa_phi);
% phase_freq_offset_sig_out = d_in.*exp_freq_shift;
%% формируем временную задержку
d_outTimeShift = spline(t, d_inZeros, t + delayVec);
d_out = d_outTimeShift(1:end).*exp_freq_shift;
% d_out = (fract_del(phase_freq_offset_sig_out, ));
% figure; plot(ind, d_in); hold on;
% plot(ind + delayVec, d_out);

% figure; 
% plot(t + delayVec, real(d_outTimeShift), 'x'); 
% hold on; 
% plot(t, real(d_inZeros)); 
% 
% figure; 
% plot(t + delayVec, imag(d_outTimeShift), '*'); 
% hold on; 
% plot(t, imag(d_inZeros)); 
end