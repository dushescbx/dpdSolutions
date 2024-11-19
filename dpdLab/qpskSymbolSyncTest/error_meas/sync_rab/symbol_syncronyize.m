function [sym_corrected_data, step_size_est_dr_mat] = ...
    symbol_syncronyize(in_data_for_sync,ref_data, ref_delay)
%% константы для подстройки временной задержки
start_sym = 0;
point_num_mat = length(in_data_for_sync);
x_mat = 1:point_num_mat;
yy_mat = zeros(0,0);

%% подстройка временной задержки
i = 1;
step_size_start_mat = -0.5;
step_size_end_mat = 0.5;
step_of_loop_mat = (step_size_end_mat-step_size_start_mat)/1e2;

for step_size_mat = step_size_start_mat:step_of_loop_mat:step_size_end_mat
    %задаем новые точки
    step_size_ar_mat(i) = step_size_mat;
    xx_fixed_mat = x_mat(1:point_num_mat) + step_size_mat;
    % получаем значения функции в этих точках
    yy_mat = spline(x_mat, in_data_for_sync, xx_fixed_mat);
    epsilon_dr(i) = max(abs(xcorr(ref_data,yy_mat)));
    i = i + 1;
    figure; plot(real(ref_data)); hold on; plot(real(yy_mat))
end



[max_val_dr, index_dr] = max(epsilon_dr(:));
step_size_est_dr_mat = step_size_start_mat + (index_dr - 1) * step_of_loop_mat;

% figure;
% plot(step_size_ar_mat,epsilon_dr);
% title(['step size est dr=' num2str(step_size_est_dr_mat) ' index=' num2str(index_dr)]);


%% строим символы с заданной скорректированной задержкой

x_mat = 1:(length(in_data_for_sync));
xx_fixed_mat = x_mat + ref_delay;
sym_corrected_data = spline(x_mat,in_data_for_sync,xx_fixed_mat);
% scatterplot(complex(yy_r_mat,yy_i_mat));
% title(['after symbol sync known data delay vec =' num2str(ref_delay/4)]);



% % % x_mat = 1:(length(in_data_for_sync));
% % % xx_fixed_mat = x_mat + step_size_est_dr_mat;
% % % sym_corrected_data = spline(x_mat, in_data_for_sync, xx_fixed_mat);
sym_corrected_data = reshape(sym_corrected_data, [], 1);
% scatterplot(sym_corrected_data);
% title(['after symbol sync est data delay vec dr =' num2str(step_size_est_dr_mat)]);
