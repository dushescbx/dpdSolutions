clear all
APSK_ar = [ 32 ];
f = 1;
direct = 'C:\Users\Konstantinov_PA\Desktop\RABOTA\actual\';
%% входной массив значений
run('download_power_arrays.m');
%% генерация BPSK
run('bpsk_gen.m');
%% КОНСТАНТЫ КОМАНД ДЛЯ ГЕНЕРАТОРА И АНАЛИЗАТОРА
run('const_for_scpi_comms.m');
%% соединяемся с генератором и анализатором
run('connect_to_gen_and_scope.m');
%% построение характеристики по измеренным значениям усилителя при помощи маркера
run('pa_char_with_sine_real_pa_marker.m');
%% построение характеристики по измеренным значениям усилителя при помощи VSA
run('pa_char_with_sine_real_pa_vsa.m');
%% построение графиков усиления по различным моделям
run('plot_pa_char.m');