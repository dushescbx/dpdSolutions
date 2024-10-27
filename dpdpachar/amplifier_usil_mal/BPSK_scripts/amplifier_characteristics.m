clear all
close all
% dir = 'C:\Users\abf\Desktop\RABOTA\actual';
direct = 'C:\Users\Konstantinov_PA\Desktop\RABOTA\actual\';
no_meas = 1; % используем готорвые измеренные данные
if (no_meas == 1)
    APSK_ar = 32;
end
%% ЗАГРУЖАЕМ КОНСТАНТЫ ДЛЯ МОДЕЛИ СИМУЛИНК
run('constant_for_model.m');
run('const_for_scpi_comms.m');
offset=0;
% %% строим характеристику по участкам входной мощности
f1=figure;
run('download_power_arrays.m');
if (no_meas == 1)
    current_dbm_ar = input_ar.d;
end

figure_on = 0;
%% ЦИКЛ ПО ВСЕМ СОЗВЕЗДИЯМ
APSK_ar = 32;
for f=1:1:length(APSK_ar)
    %     %% построение модели и характеристики по IQ отсчетам из анализатора
    %     run('pa_char_with_iq.m');
    %% построение модели и характеристики по trace (символам) из анализатора
    %     run('pa_char_with_trace.m');
    %% построение модели и характеристики по trace (символам), преобразованным с помощью rx фильтра из анализатора
    %     run('pa_char_with_trace_to_raw.m');
    %% построение модели и характеристики по синхронизированным raw данным (символам) из анализатора
    i = 1;
    for PAorder = [ 5 : 2 : 5]
        for PAmemory = [ 1 : 2 : 1 ]
            %             pa_char_with_sync_raw_data_BPSK(input_ar.d, output_ar.d, direct, APSK_ar(f), figure_on, PAmemory, PAorder)
            %             run('kusochnaya_ampl_char_BPSK.m');
            pa_char_with_sync_raw_data(input_ar.d, output_ar.d, direct, APSK_ar(f), figure_on, PAmemory, PAorder)
        end
    end
    %     pa_char_with_sync_raw_data(input_ar.d, output_ar.d, direct, APSK_ar(f), figure_on, PAmemory, PAorder)
    
    
    %     run('pa_char_with_trace_2_no_corr_Data.m');
    %     %% построение модели и характеристики по raw (символам) из анализатора
    %     run('pa_char_with_raw.m');
    %     %% строим графики различия символов по модели и измеренных на приборе
    %     compare_constellations(data_out_from_model,data_out_from_scope)
    %     %% построение идеальной(линейной) характеристики усилителя
    %     run('ideal_pa_char');
    %     %% построение характеристики по синусоидальному входному сигналу
    % %     run('pa_char_with_sine_model');
    %     %% построение характеристики по измеренным значениям усилителя при помощи маркера
    %     run('pa_char_with_sine_real_pa_marker.m');
    %     %% построение характеристики по измеренным значениям усилителя при помощи VSA
    %     run('pa_char_with_sine_real_pa_vsa.m');
    %     %% построение графиков усиления по различным моделям
    %     run('plot_pa_char.m');
    %     %% измерение искажений фазы
    %     run('phase_distortion_meas.m');
end
