close all
clear all
APSK_ar = 2;
directory = 'C:\Users\Konstantinov_PA\Desktop\RABOTA\actual';
%% ���������, ���� �� ����������� ������� � ����������
run('download_data_to_gen.m');
% % % %% ��������� ������ ��� ���������� � �����������
% % % run('const_for_scpi_comms.m');
%% ����������� � ����������� � ������������
run('connect_to_gen_and_scope.m');
%% ���������� ������ � ��������� ��� �� ����������� � ����
run('generate_signal_and_record_to_file_BPSK.m');
%% ���������� �������������� ���������
% run('amplifier_characteristics.m');
