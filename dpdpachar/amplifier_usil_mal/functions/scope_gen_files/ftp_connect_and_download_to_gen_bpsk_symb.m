%% ������� �������� ������ �� ���������
function ftp_connect_and_download_to_gen_bpsk_symb(directory)
%% ������ ������ � �����
username='instrument';
password='instrument';
%% ������������ � ����������
ftpobj=ftp('10.105.31.119',username,password);
% dir(ftpobj)
%% ��������� � ����� USER
cd(ftpobj,'user');
%% ������� ����� ref_waveforms
mkdir(ftpobj,'ref_waveforms')
%% ��������� � ����� ref_waveforms
cd(ftpobj,'ref_waveforms');
%% ��������� ���� � ���������
mput(ftpobj,[directory '\amplifier_usil_mal\_BPSK_ref_symb_after_filter_for_conv_wv.wv']);
mput(ftpobj,[directory '\amplifier_usil_mal\_BPSK_ref_symb_before_transm_filter.wv']);

