close all
clear all
APSK_ar = 2;
directory = 'C:\Users\Konstantinov_PA\Desktop\RABOTA\actual';
%% ПРОВЕРЯЕМ, есть ли необходимые сигналы в генераторе
run('download_data_to_gen.m');
% % % %% КОНСТАНТЫ КОМАНД ДЛЯ ГЕНЕРАТОРА И АНАЛИЗАТОРА
% % % run('const_for_scpi_comms.m');
%% соединяемся с генератором и анализатором
run('connect_to_gen_and_scope.m');
%% генерируем сигнал и считываем его из анализатора в файл
run('generate_signal_and_record_to_file_BPSK.m');
%% построение характеристики усилителя
% run('amplifier_characteristics.m');
