function evm = synch_compare(data_train, data_ref)
%% уравниваем мощность
power_of_ref_sig_mat = mean(abs(data_ref.^2));
power_of_train_sig = mean(abs(data_train.^2));
koef = power_of_ref_sig_mat/power_of_train_sig;
data_train = sqrt(koef) * data_train;
%% вычисляем EVM
evm = evm_meas(data_ref,data_train);

