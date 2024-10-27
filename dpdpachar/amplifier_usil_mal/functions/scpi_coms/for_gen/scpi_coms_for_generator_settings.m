function [scpi_command_ar]=scpi_coms_for_generator_settings(x, const)
%% ������� ��� ���������� �������
i=1;
%% �������� ����������� �����
scpi_command_ar(i)=strcat(":SOURce1:BB:ARBitrary:WAVeform:SELect ",...
    '"', const.SCPI.ARBitrary_WAVeform_SELect, const.com.ref_wv_folder_name, '/', const.sig.ref_sample_filename(1), ...
    num2str(x), const.sig.ref_sample_filename(2), ".wv", '"');
i=i+1;
%% ��� ���������
scpi_command_ar(i)=strcat(":SOURce1:BB:DM:FORMat ", '"','DM_FORMat_type', num2str(x), '"');
i=i+1;
%% ��� �������� ���������
scpi_command_ar(i)=':SOURce1:BB:DM:STATe 1';
i=i+1;
%% ��� ARB ����������
scpi_command_ar(i)=':SOURce1:BB:ARBitrary:STATe 1';
i=i+1;
%% ������ ������������ ���������� ������������������, ������� ����� ����������
%� ������ ������� "Single"
scpi_command_ar(i)=strcat(":SOURce1:BB:ARBitrary:TRIGger:SLENgth ", num2str(const.SCPI.ARBitrary_TRIGger_SLENgth));
i=i+1;
%% ����� �������: RATio
scpi_command_ar(i)=':SOURce1:BB:ARBitrary:TRIGger:OUTPut1:MODE RAT';
i=i+1;
%% ���������� ��
scpi_command_ar(i)=strcat(":SOURce1:FREQuency:CW ", num2str(const.SCPI.FREQuency_CW));
i=i+1;
%% ����� �������� � �������
scpi_command_ar(i)=strcat(":SOURce1:BB:ARBitrary:TRIGger:OUTPut1:ONTime " ,num2str(const.SCPI.TRIGger_OUTPut1_ONTime));
i=i+1;
scpi_command_ar(i)=strcat(":SOURce1:BB:ARBitrary:TRIGger:OUTPut1:OFFTime " ,num2str(const.SCPI.TRIGger_OUTPut1_OFFTime));
i=i+1;
%% �������� IQ ���������
scpi_command_ar(i)=strcat(':SOURce1:IQ:STATe 1');
i=i+1;
%% clock �������
scpi_command_ar(i)=strcat(":SOURce1:BB:ARBitrary:CLOCk ", num2str(const.SCPI.ARBitrary_CLOCk));
i=i+1;
%% �������� ���������
scpi_command_ar(i)=':SOURce1:MODulation:ALL:STATe 1';
i=i+1;
%% �������� �� �����
scpi_command_ar(i)=':OUTPut1:STATe 1';
i=i+1;