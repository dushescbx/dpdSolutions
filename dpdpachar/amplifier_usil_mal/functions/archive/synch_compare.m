function evm = synch_compare(data_train,data_ref)
%% уравниваем мощность
data_train = data_train(1:length(data_ref)/10);
data_ref = data_ref(6:length(data_train)+5);
% % % data_train = data_train(1:length(data_ref)/10+1);
% % % data_ref = data_ref(6:length(data_train)+5);
power_of_ref_sig_mat = mean(abs(data_ref.^2));
power_of_train_sig = mean(abs(data_train.^2));
koef = power_of_ref_sig_mat/power_of_train_sig;
data_train = sqrt(koef) * data_train;
%% строим сигнальное созвездие
% scatterplot(data_train);
% title('synch data');
% scatterplot(data_ref);
% title('trace data');
%% вычисляем EVM
evm = evm_meas(data_ref,data_train);
angle_dif = (angle(data_ref) - angle(data_train))*180/pi;
for i=1:1:length(angle_dif)
    if angle_dif(i) > 180
        angle_dif(i) = -360 + angle_dif(i);
    elseif angle_dif(i) < -180
        angle_dif(i) = 360 + angle_dif(i);
    end
end
% plot(angle_dif);
mean_angle_diff = mean(angle_dif)

