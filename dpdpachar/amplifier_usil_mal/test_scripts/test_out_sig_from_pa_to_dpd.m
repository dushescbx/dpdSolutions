APSK_ar=[ 32 ];
%% ПРОВЕРЯЕМ, есть ли необходимые сигналы в генераторе
run('exist_or_not_waveform_in_generator.m');

%% КОНСТАНТЫ КОМАНД ДЛЯ ГЕНЕРАТОРА И АНАЛИЗАТОРА
run('const_for_scpi_comms.m');

%% соединяемся с генератором и анализатором
run('connect_to_gen_and_scope.m');

%% генерируем сигнал и считываем его из анализатора в файл
run('generate_signal_and_record_to_file_wo_model_of_pa.m');

%% определение оптимальных констант для дпд
run('automatic_rpem_find_opt_wo_model_of_pa.m');