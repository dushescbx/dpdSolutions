% clear all;
close all;

% путь к основной папке с файлами
const.com.direct = 'C:\rabota\DPD\dpdpachar\amplifier_usil_mal\';
% const.com.direct = 'C:\Users\Konstantinov_PA\Desktop\RABOTA\28.08_corr\';
cd(const.com.direct);
% добавл€ем все файлы, которые есть в основной папке
addpath(genpath(const.com.direct));
%% массив констант
disp('loading const data');
const = constant_for_scope_and_generator(const);

%% ѕ–ќ¬≈–я≈ћ, есть ли необходимые сигналы в генераторе
disp('generating ref data');
exist_or_not_waveform_in_generator(const);

%% соедин€емс€ с генератором и анализатором
disp('connecting to R&S gen and vec analyzer');
run('connect_to_gen_and_scope.m');

%% генерируем сигнал и считываем его из анализатора в файл
disp('sending data to PA');
generate_signal_and_record_to_file(const, generator, scope);

%% синхронизируем iq сэмплы
disp('syncing data from vec analyzer');
raw_or_iq = 0;
for i = const.sig.APSK
    for power = const.sig.in_power
        symbol_synch_data = conv_unsync_iq_to_sync(i, power, raw_or_iq, const);
    end
end

%% строим характеристику усилител€
disp('characterizing PA');
files_for_test_pa_char(const);

%% рассчитываем dpd coef
disp('calculating dpd coef and generating dpd samples');
dpd_tets(const);
close all

%% прогон€ем dpd сэмплы и сравниваем работу
disp('comparing dpd and no dpd symbols');
dpd_sym_to_pa(const);