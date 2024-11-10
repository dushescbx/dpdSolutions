function [ tx_symbol ] = symbol_recovery( tx_signal, symbol_rate, sps, dec_coef)
signal_start_index = 1 + 0 * length(tx_signal) / 10;
signal_stop_index = 1 * length(tx_signal) / 10;
signal = tx_signal(signal_start_index:signal_stop_index);
tx_signal_time = 0 : 1/symbol_rate/(sps*dec_coef) :...
    (length(tx_signal)-1) / symbol_rate/(sps*dec_coef);
signal_time = 0 : 1/symbol_rate/(sps*dec_coef) :...
    (length(signal)-1) / symbol_rate/(sps*dec_coef);
num_loop = 100;
time_detect = zeros(num_loop+1,1);
% time_detect = zeros(1,num_loop+1);
wait_bar = waitbar(0, 'Symbol recovery');
% reshape(double(out.filter_rdy.signals.values), [1, length(out.filter_rdy.signals.values)]);
for i = 1 : num_loop
    % задаем сдвиг
    offset_1 = (i-1)/num_loop * 1/symbol_rate;
    % новая сетка времени
      symbol_time_1_2_3 = offset_1 : 1/symbol_rate/2 : ...
        offset_1+((length(signal)-1)*1/symbol_rate)/(sps*dec_coef) ;

    % symbol_time_1_2_3 = offset_1 : 1/symbol_rate/2 : ...
    %     offset_1+(length(signal)-2*(sps*dec_coef)) / symbol_rate/(sps*dec_coef) + 1/symbol_rate ;
   %     figure; plot(symbol_time_1_2_3);
   % hold on; plot(signal_time);
    if mod(length(symbol_time_1_2_3),2) == 0 % четная длина
        symbol_time_1_2_3 = symbol_time_1_2_3(1:end-1);
    end
    symbol_1_2_3 = spline( signal_time, signal, symbol_time_1_2_3 );
    % ошибка
    time_detect(i) = sum( ( real(symbol_1_2_3(3:2:end)) - real(symbol_1_2_3(1:2:end-1)) )...
        .* real( symbol_1_2_3(2:2:end)) +( imag(symbol_1_2_3(3:2:end)) - ...
        imag(symbol_1_2_3(1:2:end-1)) ) .* imag( symbol_1_2_3(2:2:end )  ));
%       time_detect(i) = sum( ( real(symbol_1_2_3(3:2:end-1)) - real(symbol_1_2_3(1:2:end-3)) )...
%         .* real( symbol_1_2_3(2:2:end-2)));  
    waitbar(i/num_loop, wait_bar, sprintf('Symbol recovery'));
%     figure;
% plot(symbol_time_1_2_3(1:2:100), real(symbol_1_2_3(1:2:100)), '-*');
% hold on
% plot(tx_signal_time(1:100*sps*dec_coef/2),...
%     real(tx_signal(1:100*sps*dec_coef/2)));
% title('signal timing est');
% close all
end

% figure;
% plot(  (1:num_loop) ./ num_loop .* 1/symbol_rate, diff(time_detect)  );
% hold on
% определение положения максимума
[~ , index_min] = max( (( diff(time_detect) ) ));
offset_time = (index_min-1)* 1/num_loop/symbol_rate;
% пересчет сигнала на новую сетку времени
new_signal_time = offset_time : 1/symbol_rate : tx_signal_time( end ) ;
tx_symbol = spline( tx_signal_time, tx_signal, new_signal_time );
tx_symbol = tx_symbol.';
close(wait_bar)

% figure;
% plot(new_signal_time, real(tx_symbol), '-*');
% hold on
% plot(tx_signal_time, real(tx_signal));
% title('signal timing est');
end
