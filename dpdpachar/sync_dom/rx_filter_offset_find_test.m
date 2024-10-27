function rx_filter_out = rx_filter_offset_find_test(rx_filter_in, dec_factor)
%% формируем принимающий фильтр
rxfilter = comm.RaisedCosineReceiveFilter('InputSamplesPerSymbol', 4, ...
    'DecimationFactor', dec_factor, 'RolloffFactor',0.22);
rx_filter_out = rxfilter(rx_filter_in);
end