function [ tx_symbol, step_size_est_dr_mat, tx_symbolFull ] = ...
    symbol_recoveryCorr( tx_signal, ...
    symbol_rate, sps, dec_coef, ref_data,...
    refOffset, refOffsetValue)
signal_start_index = 1 + 0 * length(tx_signal) / 10;
signal_stop_index = 10 * length(tx_signal) / 10;
signal = tx_signal(signal_start_index:signal_stop_index);
tx_signal_time = 0 : 1/symbol_rate/(sps*dec_coef) :...
    (length(tx_signal)-1) / symbol_rate/(sps*dec_coef);
signal_time = 0 : 1/symbol_rate/(sps*dec_coef) :...
    (length(signal)-1) / symbol_rate/(sps*dec_coef);
num_loop = 100;
epsilon_dr = zeros(num_loop+1,1);
% time_detect = zeros(1,num_loop+1);
if ~refOffset
    wait_bar = waitbar(0, 'Symbol recovery');
    % reshape(double(out.filter_rdy.signals.values), [1, length(out.filter_rdy.signals.values)]);
    i = 1;
    step_size_start_mat = -0.5;
    step_size_end_mat = 0.5;
    step_of_loop_mat = (step_size_end_mat-step_size_start_mat)/num_loop;

    for step_size_mat = step_size_start_mat:step_of_loop_mat:step_size_end_mat
        step_size_ar_mat(i) = step_size_mat;
        % задаем сдвиг
        offset_1 = (i-1)/num_loop * 1/symbol_rate;
        % новая сетка времени
        symbol_time_1_2_3 = step_size_mat : 1/symbol_rate : ...
            offset_1+((length(signal)-1)*1/symbol_rate)/(sps*dec_coef) ;


        symbol_1_2_3 = spline( signal_time, signal, symbol_time_1_2_3 );
        % ошибка
        epsilon_dr(i) = max(abs(xcorr(ref_data, symbol_1_2_3)));
        %       time_detect(i) = sum( ( real(symbol_1_2_3(3:2:end-1)) - real(symbol_1_2_3(1:2:end-3)) )...
        %         .* real( symbol_1_2_3(2:2:end-2)));
        waitbar(i/num_loop, wait_bar, sprintf('Symbol recovery'));
        % %     figure;
        % % plot(symbol_time_1_2_3(1:100), real(symbol_1_2_3(1:100)), '-*');
        % % hold on
        % % plot(0:100-1, real(ref_data(1:100)), '-x');
        % % plot(tx_signal_time(1:100*(sps*dec_coef)), real(tx_signal(1:100*(sps*dec_coef))));
        % % title('signal timing est');
        % % close all
        i = i + 1;
    end

    [max_val_dr, index_dr] = max(epsilon_dr(:));
    step_size_est_dr_mat = step_size_start_mat + (index_dr - 1) * step_of_loop_mat;
    new_signal_time = step_size_est_dr_mat : 1/symbol_rate : tx_signal_time( end ) ;
    new_signal_timeFull = step_size_est_dr_mat : 1/symbol_rate/(sps*dec_coef) :...
    (length(signal)-1) / symbol_rate/(sps*dec_coef);
else
    step_size_est_dr_mat = 0;
    new_signal_time = refOffsetValue : 1/symbol_rate : tx_signal_time( end ) ;
    new_signal_timeFull = refOffsetValue : 1/symbol_rate/(sps*dec_coef) :...
    (length(signal)-1) / symbol_rate/(sps*dec_coef);
end
% пересчет сигнала на новую сетку времени
tx_symbolFull = spline( tx_signal_time, tx_signal, new_signal_timeFull );
tx_symbolFull = reshape(tx_symbolFull, [], 1);
tx_symbol = spline( tx_signal_time, tx_signal, new_signal_time );
if length(ref_data) <= length(tx_symbol)
    tx_symbol = tx_symbol(1:length(ref_data)).';
else
    tx_symbol = tx_symbol.';
end
if ~refOffset
    close(wait_bar)
end
% figure;
% plot(real(tx_symbol), '-*');
% hold on
% % plot(tx_signal_time, real(tx_signal));
% plot(real(ref_data), '-x');
% title('signal timing est');
end
