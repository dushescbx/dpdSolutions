% clear all;
close all;

% ���� � �������� ����� � �������
const.com.direct = 'C:\rabota\DPD\dpdpachar\amplifier_usil_mal\';
% const.com.direct = 'C:\Users\Konstantinov_PA\Desktop\RABOTA\28.08_corr\';
cd(const.com.direct);
% ��������� ��� �����, ������� ���� � �������� �����
addpath(genpath(const.com.direct));
%% ������ ��������
disp('loading const data');
const = constant_for_scope_and_generator(const);

%% ���������, ���� �� ����������� ������� � ����������
disp('generating ref data');
exist_or_not_waveform_in_generator(const);

%% ����������� � ����������� � ������������
disp('connecting to R&S gen and vec analyzer');
run('connect_to_gen_and_scope.m');

%% ���������� ������ � ��������� ��� �� ����������� � ����
disp('sending data to PA');
generate_signal_and_record_to_file(const, generator, scope);

%% �������������� iq ������
disp('syncing data from vec analyzer');
raw_or_iq = 0;
for i = const.sig.APSK
    for power = const.sig.in_power
        symbol_synch_data = conv_unsync_iq_to_sync(i, power, raw_or_iq, const);
    end
end

%% ������ �������������� ���������
disp('characterizing PA');
files_for_test_pa_char(const);

%% ������������ dpd coef
disp('calculating dpd coef and generating dpd samples');
dpd_tets(const);
close all

%% ��������� dpd ������ � ���������� ������
disp('comparing dpd and no dpd symbols');
dpd_sym_to_pa(const);