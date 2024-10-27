function sdvig_otschetov(data_in)
%% сдвиг отсчетов

for off=0:1:3
    clear simim
    run('constant_for_model.m');
    simin.data=data_in(1+off:length(data_out-4+off));%data_out_ADD(146+off:145+4e4+off);
    simin.time=0:length(simin.data)-1;
    simin=timeseries(simin.data,simin.time);
    sim('dpd_static_verify_simin_data_no_filter_test.slx');
    scatterplot(data_out1);
    title(num2str(off));
end
end