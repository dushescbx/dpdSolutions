clear all
APSK_ar = [ 32 ];
f = 1;
direct = 'C:\Users\Konstantinov_PA\Desktop\RABOTA\actual\';
%% ������� ������ ��������
run('download_power_arrays.m');
%% ��������� BPSK
run('bpsk_gen.m');
%% ��������� ������ ��� ���������� � �����������
run('const_for_scpi_comms.m');
%% ����������� � ����������� � ������������
run('connect_to_gen_and_scope.m');
%% ���������� �������������� �� ���������� ��������� ��������� ��� ������ �������
run('pa_char_with_sine_real_pa_marker.m');
%% ���������� �������������� �� ���������� ��������� ��������� ��� ������ VSA
run('pa_char_with_sine_real_pa_vsa.m');
%% ���������� �������� �������� �� ��������� �������
run('plot_pa_char.m');