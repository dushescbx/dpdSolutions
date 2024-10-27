wfunction sym_corrected_data = symbol_syncronyize(in_data_for_sync,ref_data)
%% константы для подстройки временной задержки
start_sym = 0;
point_num_mat = length(in_data_for_sync);
power_of_ref_sig_mat = mean(abs(ref_data).^2);
x_mat = 1:point_num_mat;
yy_r_mat = zeros(0,0);
yy_i_mat = zeros(0,0);

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
    yy_r_mat = spline(x_mat,real(in_data_for_sync),xx_fixed_mat);
    yy_i_mat = spline(x_mat,imag(in_data_for_sync),xx_fixed_mat);
    power_of_interp_sig = mean(abs(complex(yy_r_mat,yy_i_mat).^2));
    koef = power_of_ref_sig_mat/power_of_interp_sig;
    yy_r_mat = sqrt(koef) * yy_r_mat;
    yy_i_mat = sqrt(koef) * yy_i_mat;
    koef = power_of_ref_sig_mat/power_of_interp_sig;
    epsilon_dr(i) = max(abs(xcorr(ref_data,complex(yy_r_mat,yy_i_mat))));
    i = i + 1;
end



[max_val_dr, index_dr] = max(epsilon_dr(:));
step_size_est_dr_mat = step_size_start_mat + (index_dr - 1) * step_of_loop_mat;

% figure;
% plot(step_size_ar_mat,epsilon_dr);
% title(['step size est dr=' num2str(step_size_est_dr_mat) ' index=' num2str(index_dr)]);


%% строим символы с заданной скорректированной задержкой
% 
% x_mat = 1:(length(in_data_for_sync));
% xx_fixed_mat = x_mat + ref_delay/4;
% yy_r_mat = spline(x_mat,real(in_data_for_sync),xx_fixed_mat);
% yy_i_mat = spline(x_mat,imag(in_data_for_sync),xx_fixed_mat);
% scatterplot(complex(yy_r_mat,yy_i_mat));
% title(['after symbol sync known data delay vec =' num2str(ref_delay/4)]);



x_mat = 1:(length(in_data_for_sync));
xx_fixed_mat = x_mat + step_size_est_dr_mat;
yy_r_mat = spline(x_mat,real(in_data_for_sync),xx_fixed_mat);
yy_i_mat = spline(x_mat,imag(in_data_for_sync),xx_fixed_mat);
sym_corrected_data = complex(yy_i_mat,yy_r_mat)';
scatterplot(sym_corrected_data);
title(['after symbol sync est data delay vec dr =' num2str(step_size_est_dr_mat)]);
