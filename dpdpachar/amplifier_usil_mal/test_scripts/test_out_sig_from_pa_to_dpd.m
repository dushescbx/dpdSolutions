APSK_ar=[ 32 ];
%% ���������, ���� �� ����������� ������� � ����������
run('exist_or_not_waveform_in_generator.m');

%% ��������� ������ ��� ���������� � �����������
run('const_for_scpi_comms.m');

%% ����������� � ����������� � ������������
run('connect_to_gen_and_scope.m');

%% ���������� ������ � ��������� ��� �� ����������� � ����
run('generate_signal_and_record_to_file_wo_model_of_pa.m');

%% ����������� ����������� �������� ��� ���
run('automatic_rpem_find_opt_wo_model_of_pa.m');