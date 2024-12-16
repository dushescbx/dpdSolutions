function [evm_rms]=evm_measNew(ref,signal)%,ref_power
% evm = 100*(((real(ref)-...
%     real(signal)).^2+(imag(ref)-imag(signal)).^2)...
%     ./abs(ref).^2);
ref = reshape(ref, 1, []);
signal = reshape(signal, 1, []);
min_len = min([length(ref) length(signal)]);
ref = ref(1:min_len);
signal = signal(1:min_len);
power_of_ref_sig_mat = mean(abs(ref.^2));
power_of_train_sig = mean(abs(signal.^2));
koef = power_of_ref_sig_mat/power_of_train_sig;
signal = sqrt(koef) * signal;
evm = ((real(ref)-...
    real(signal)).^2+(imag(ref)-imag(signal)).^2)...
    ./mean(abs(ref));
evm_rms = 100*sqrt(mean(evm.^2));
evm_rmsTest = 100*rms(evm);

figure; plot(ref, 'x');
hold on; plot(signal, '.');