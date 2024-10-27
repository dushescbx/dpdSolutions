    figure
    plot(180/pi*(angle(data_out_from_model(1:length(data_out_from_scope)))-angle(data_out_from_scope)));
    figure
    plot((abs(data_out_from_model(1:length(data_out_from_scope)))-abs(data_out_from_scope))./abs(data_out_from_scope));