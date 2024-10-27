clear all
close all
% dir = 'C:\Users\abf\Desktop\RABOTA\actual';
direct = 'C:\Users\Konstantinov_PA\Desktop\RABOTA\actual\';
no_meas = 1; % ���������� �������� ���������� ������
if (no_meas == 1)
    APSK_ar = 32;
end
%% ��������� ��������� ��� ������ ��������
run('constant_for_model.m');
run('const_for_scpi_comms.m');
offset=0;
% %% ������ �������������� �� �������� ������� ��������
f1=figure;
run('download_power_arrays.m');
if (no_meas == 1)
    current_dbm_ar = input_ar.d;
end

figure_on = 0;
%% ���� �� ���� ����������
APSK_ar = 32;
for f=1:1:length(APSK_ar)
    %     %% ���������� ������ � �������������� �� IQ �������� �� �����������
    %     run('pa_char_with_iq.m');
    %% ���������� ������ � �������������� �� trace (��������) �� �����������
    %     run('pa_char_with_trace.m');
    %% ���������� ������ � �������������� �� trace (��������), ��������������� � ������� rx ������� �� �����������
    %     run('pa_char_with_trace_to_raw.m');
    %% ���������� ������ � �������������� �� ������������������ raw ������ (��������) �� �����������
    i = 1;
    for PAorder = [ 5 : 2 : 5]
        for PAmemory = [ 1 : 2 : 1 ]
            %             pa_char_with_sync_raw_data_BPSK(input_ar.d, output_ar.d, direct, APSK_ar(f), figure_on, PAmemory, PAorder)
            %             run('kusochnaya_ampl_char_BPSK.m');
            pa_char_with_sync_raw_data(input_ar.d, output_ar.d, direct, APSK_ar(f), figure_on, PAmemory, PAorder)
        end
    end
    %     pa_char_with_sync_raw_data(input_ar.d, output_ar.d, direct, APSK_ar(f), figure_on, PAmemory, PAorder)
    
    
    %     run('pa_char_with_trace_2_no_corr_Data.m');
    %     %% ���������� ������ � �������������� �� raw (��������) �� �����������
    %     run('pa_char_with_raw.m');
    %     %% ������ ������� �������� �������� �� ������ � ���������� �� �������
    %     compare_constellations(data_out_from_model,data_out_from_scope)
    %     %% ���������� ���������(��������) �������������� ���������
    %     run('ideal_pa_char');
    %     %% ���������� �������������� �� ��������������� �������� �������
    % %     run('pa_char_with_sine_model');
    %     %% ���������� �������������� �� ���������� ��������� ��������� ��� ������ �������
    %     run('pa_char_with_sine_real_pa_marker.m');
    %     %% ���������� �������������� �� ���������� ��������� ��������� ��� ������ VSA
    %     run('pa_char_with_sine_real_pa_vsa.m');
    %     %% ���������� �������� �������� �� ��������� �������
    %     run('plot_pa_char.m');
    %     %% ��������� ��������� ����
    %     run('phase_distortion_meas.m');
end
