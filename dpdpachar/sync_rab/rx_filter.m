function rx_filter_out = rx_filter(rx_filter_in)
%% формируем принимающий фильтр
rxfilter = comm.RaisedCosineReceiveFilter('InputSamplesPerSymbol',4, ...
    'DecimationFactor',4,'RolloffFactor',0.22);
rx_filter_out = rxfilter(rx_filter_in);
rx_filter_out = rx_filter_out(11:end);
scatterplot(rx_filter_out);
title('after rx filter mat');
end