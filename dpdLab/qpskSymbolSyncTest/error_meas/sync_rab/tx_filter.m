function tx_filter_out = tx_filter(tx_filter_in)
txfilter = comm.RaisedCosineTransmitFilter('FilterSpanInSymbols',10,'OutputSamplesPerSymbol',4,'RolloffFactor',0.22);
tx_filter_out = txfilter(tx_filter_in);
scatterplot(tx_filter_out);
title('after tx filter mat');