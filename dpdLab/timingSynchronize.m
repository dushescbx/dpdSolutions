function [d_out, timeOffset] = timingSynchronize(d_in,...
    d_ref, figure_on)
%%
step_size_start_mat = -0.5;
step_size_end_mat = 0.5;
step_of_loop_mat = (step_size_end_mat-step_size_start_mat)/2e1;

%%
num_of_loops = 5;
t = 0 : length(d_in) - 1;
%%
for k = 1:num_of_loops
    i = 1;
    step_size_mat = step_size_start_mat:step_of_loop_mat:step_size_end_mat;
    epsilon_dr = zeros(1, length(step_size_mat));
    for f = 1 : length(step_size_mat)
        d_timingEst = spline(t, d_in, t + step_size_mat(f));
        epsilon_dr(f) = max(abs(xcorr(d_ref, d_timingEst)));
        if f == 2
            figure; plot(abs(xcorr(d_ref, d_timingEst)));
        end
    end
    if (figure_on)
        figure;
        plot(step_size_mat,epsilon_dr)
    end
    %% íàõîäèì çàäåðæêó ñ ìàêñèìàëüíîé êîðåëëÿöèåé
    [max_val_dr, index_dr] = max(epsilon_dr(:));
    %% óìåíüøàåì ãðàíèöû ïîèñêà
    step_size_est_dr_mat = step_size_start_mat + (index_dr - 1) * step_of_loop_mat;
    step_size_start_mat = step_size_est_dr_mat -  2*step_of_loop_mat;
    step_size_end_mat = step_size_est_dr_mat +  2*step_of_loop_mat;
    step_of_loop_mat = step_of_loop_mat / 2;
    % % %     close all
end
timeOffset = step_size_est_dr_mat;
d_out = spline(t, d_in, t + timeOffset);


end