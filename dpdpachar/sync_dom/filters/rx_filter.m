function rx_filter_out = rx_filter(rx_filter_in, mat_or_real, raw_or_iq, figure_on, dec_factor) %, ref_data
%% формируем принимающий фильтр
rxfilter = comm.RaisedCosineReceiveFilter('InputSamplesPerSymbol',4, ...
    'DecimationFactor',dec_factor,'RolloffFactor',0.22);
rx_filter_out = rxfilter(rx_filter_in);


% rx_filter_out = offset_find(rx_filter_out, ref_data);






if (mat_or_real == 0 && raw_or_iq == 0)
    rx_filter_out = rx_filter_out(7:end);
elseif (mat_or_real == 0 && raw_or_iq == 1)
%     for offset = 1 : 1 : 14
%         rx_filter_out = rx_filter_out(offset:end);
        %rx_filter_out = rx_filter_out(6:end);
        %         scatterplot(rx_filter_out);
        %         title('after rx filter mat');
%     end
else
    rx_filter_out = rx_filter_out(11:end);
end
if (figure_on == 1)
    scatterplot(rx_filter_out);
    title('after rx filter mat');
end
end