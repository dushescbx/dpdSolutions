function [scpi_command_ar]=scpi_coms_for_scope_settings(x, const)
run('const_for_scpi_comms.m');


%% ������� ��� ���������� �����������
i=1;
%% ������� ����� ����� ��� ��������� VSA
scpi_command_ar(i)=(":INST:CRE:NEW DDEM, 'VSA'");
i=i+1;
%% �������� ���� ���������
scpi_command_ar(i)=(":INIT:CONT OFF");
i=i+1;
%% ����������� �������
scpi_command_ar(i)=strcat(":SENS:FREQ:CENT:VAL ",num2str(const.SCPI.FREQuency_CW));
i=i+1;
%% ������ ������ ���������
if (x==8 || x==2)
    scpi_command_ar(i)=(":SENS:DDEM:FORM PSK");
    i=i+1;
    %% ���������� PSK, �� ����������������
    scpi_command_ar(i)=(":SENS:DDEM:PSK:FORM NORMal");
    i=i+1;
elseif x==4
    scpi_command_ar(i)=(":SENS:DDEM:FORM QPSK");
    i=i+1;
    scpi_command_ar(i)=(":SENS:DDEM:QPSK:FORM NORMal");
    i=i+1;
else
    scpi_command_ar(i)=strcat(":SENS:DDEM:FORM ",const.SCPI.DM_FORMat_type);
    i=i+1;
    %% ������ ����������� ��������
    scpi_command_ar(i)=strcat(":SENS:DDEM:MAPP:VAL " ,const.SCPI.DDEM_MAPP_VAL);
    i=i+1;
end
%% ������ ����� ��������� (4,8,16...)
scpi_command_ar(i)=strcat(":SENS:DDEM:" , psk_or_apsk(x), ":NST " , num2str(x));
i=i+1;
%% ���������� �������
scpi_command_ar(i)=strcat(":SENS:DDEM:SRAT ", num2str(const.SCPI.DDEM_SRAT));
i=i+1;
%% ������������ ����� � ��������
scpi_command_ar(i)=strcat(":SENS:DDEM:RLEN:VAL " ,num2str(const.SCPI.res_len) , " SYM");
i=i+1;
%% ���� �������
scpi_command_ar(i)=(":SENS:DDEM:SIGN:PATT ON");
i=i+1;
%% ��������� �������
scpi_command_ar(i)=strcat(":SENS:DDEM:SEAR:SYNC:PATT:ADD ", find_pattern(strcat(num2str(x), "apsk")));
i=i+1;
%% �������� �������
scpi_command_ar(i)=strcat(":SENS:DDEM:SEAR:SYNC:SEL ", find_pattern(strcat(num2str(x), "apsk")));
i=i+1;
%% ������ ����� ������� �� ������
scpi_command_ar(i)=strcat(":SENS:DDEM:PRAT " , num2str(const.SCPI.samples_per_symbol_ratio));
i=i+1;
%% �������� ������ ����� ������ �������
scpi_command_ar(i)=(":SENS:DDEM:SEAR:SYNC:MODE SYNC");
i=i+1;
%% ������� �������
scpi_command_ar(i)=(":TRIG:SEQ:SOUR EXT");
i=i+1;
%% The complete result area is evaluated.
scpi_command_ar(i)=(":CALC:ELIN:STAT OFF");
i=i+1;
%% ��������� ������������ �� ��������
scpi_command_ar(i)=(":CALC:TRAC:ADJ:VAL TRIG");
i=i+1;
%% ����� ������������ ��������
scpi_command_ar(i)=strcat(":SENS:DDEM:TIME " , num2str(const.SCPI.res_len));
i=i+1;
%% ��������� ��� ���������
scpi_command_ar(i)=(":FORM:DEXP:HEAD OFF");
i=i+1;
%% ��������� ��������� ���������� ������
scpi_command_ar(i)=(":FORM:DEXP:DSEP POIN");
i=i+1;
%% ����������� �� ������ ����
scpi_command_ar(i)=(":CALC:TRAC:ADJ:ALIG:DEF LEFT");
i=i+1;
%% ���� �������
scpi_command_ar(i)=(":SENS:DDEM:SEAR:SYNC:STAT ON");
i=i+1;
%% Display update ON
scpi_command_ar(i)=(":SYST:DISP:UPD ON");
i=i+1;
if x==2
    %% ��� ��������
    scpi_command_ar(i)=(":TRIG:SEQ:SOUR:VAL IMM");
    i=i+1;
    %% ��� ��������
    scpi_command_ar(i)=(":SENS:DDEM:SEAR:SYNC:STAT OFF");
    i=i+1;
end
end