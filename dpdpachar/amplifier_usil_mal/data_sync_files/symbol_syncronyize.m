function [sym_corrected_data, est_symb_del, est_freq, est_phase] = symbol_syncronyize(in_data_for_sync,ref_data,ref_delay, figure_on, mat_or_real, raw_or_iq)
%% ��������� ��� ���������� ��������� ��������
start_sym = 0;
point_num_mat = length(in_data_for_sync);
power_of_ref_sig_mat = mean(abs(ref_data).^2);
x_mat = 1:point_num_mat;
yy_r_mat = zeros(0,0);
yy_i_mat = zeros(0,0);

%% ���������� ��������� ��������
step_size_start_mat = -0.5;
step_size_end_mat = 0.5;
step_of_loop_mat = (step_size_end_mat-step_size_start_mat)/5e1;

%% ����� ���������������� ������������
num_of_loops = 3;
%% ��������� �����
% ref_samp = tx_filter(ref_data);
shifted_sym = shift_of_symb_finder(in_data_for_sync, ref_data, 0);
shifted_offset_sym = offset_find(shifted_sym, ref_data);
%% ������� ������� � ��������� �����
[freq_phase_corrected_data, est_freq, est_phase] = freq_phase_correction(shifted_offset_sym, ref_data, mat_or_real, figure_on, raw_or_iq);

for k = 1:num_of_loops
    i = 1;
    step_size_mat = step_size_start_mat:step_of_loop_mat:step_size_end_mat;
    for f = 1 : length(step_size_mat)
        %������ ����� �����
        %% �������� ������
        unshifted_sym = fract_del(in_data_for_sync, step_size_mat(f));
        %% ��������� �����
        shifted_sym = shift_of_symb_finder(unshifted_sym, ref_data, 0);
        %% ������� ���������� �������� � ������
        shifted_offset_sym = offset_find(shifted_sym, ref_data);
        %% ������������
        power_of_interp_sig = mean(abs(shifted_offset_sym.^2));
        koef = power_of_ref_sig_mat/power_of_interp_sig;
        shifted_offset_sym = sqrt(koef) .* shifted_offset_sym;
        koef = power_of_ref_sig_mat/power_of_interp_sig;
        
        %% ��������� � ������� �������������
        freq_phase_corrected_data = phase_freq_timing_offset(shifted_offset_sym,est_freq,est_phase,0);
        
        %% ������� ��� ���������� ��������
        epsilon_dr(i) = max(abs(xcorr(ref_data,freq_phase_corrected_data)));
        i = i + 1;
        if (figure_on == 1)
            scatterplot(freq_phase_corrected_data);
            title(['delay =' num2str(step_size_mat(f))]);
        end
    end
    if (figure_on == 1)
        figure;
        plot(est_freq);
        title('est freq');
        figure;
        plot(est_phase);
        title('est phase');
        %% ������ ����������� ���� ������ �� �������� ����������
        figure;
        plot(step_size_mat,epsilon_dr(1:length(step_size_mat)))
    end
    %% ������� �������� � ������������ �����������
    [max_val_dr, index_dr] = max(epsilon_dr(:));
    %% ��������� ������� ������
    step_size_est_dr_mat = step_size_start_mat + (index_dr - 1) * step_of_loop_mat;
    step_size_start_mat = step_size_est_dr_mat -  step_of_loop_mat;
    step_size_end_mat = step_size_est_dr_mat +  step_of_loop_mat;
    step_of_loop_mat = step_of_loop_mat / 2;
    % % %     close all
end
% figure;
% plot(step_size_ar_mat,epsilon_dr);
% title(['step size est dr=' num2str(step_size_est_dr_mat) ' index=' num2str(index_dr)]);

% %% ���������� � ��������� ��������������� (���� �� �������� ������, � ��� �������������)
% if mat_or_real == 1
%     %% �������� ������
%     unshifted_sym = fract_del(in_data_for_sync, ref_delay);
%     %% ��������� �����
%     shifted_sym = shift_of_symb_finder(unshifted_sym, ref_data, 0, 1);
%     %% ��������� � ������� �������������
%     [freq_phase_corrected_data, est_freq, est_phase] = freq_phase_correction(shifted_sym,ref_data, mat_or_real, figure_on, raw_or_iq);
%     
%     if (figure_on == 1)
%         scatterplot(freq_phase_corrected_data);
%         title(['after symbol sync known data delay vec =' num2str(ref_delay)]);
%     end
% end

%% ������ ��������� � ���������� ���������, ��������� � ������� �������.
%% �������� ������
unshifted_sym = fract_del(in_data_for_sync, step_size_est_dr_mat);
%% ��������� �����
shifted_sym = shift_of_symb_finder(unshifted_sym, ref_data, 0);
%% ������� ���������� �������� � ������
shifted_offset_sym = offset_find(shifted_sym, ref_data);

%% ��������� � ������� �������������
[sym_corrected_data, est_freq, est_phase] = freq_phase_correction(shifted_offset_sym, ref_data, mat_or_real, figure_on, raw_or_iq);
if (figure_on == 1)
    scatterplot(sym_corrected_data);
    title(['after symbol sync est data delay vec dr =' num2str(step_size_est_dr_mat)]);
end
est_symb_del = step_size_est_dr_mat;
end

