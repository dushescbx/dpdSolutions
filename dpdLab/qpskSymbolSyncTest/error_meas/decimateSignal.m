function [ tx_symbol] = ...
    decimateSignal( tx_signal, ...
    symbol_rate, sps, dec_coef)

tx_signal_time = 0 : 1/symbol_rate/(sps*dec_coef) :...
    (length(tx_signal)-1) / symbol_rate/(sps*dec_coef);

    new_signal_time = 0 : 1/symbol_rate/sps : tx_signal_time( end ) ;

% пересчет сигнала на новую сетку времени

tx_symbol = spline( tx_signal_time, tx_signal, new_signal_time );

end
