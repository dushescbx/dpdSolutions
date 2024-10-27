concat_timeseries_ar=timeseries([],[]);

for i=0:1:9
    if (i~=3)
        load(['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier - копия (3) - копия - копия - копия - копия - копия\New folder\_' num2str(i) 'dbm_DPD_on=False_input=Falsene_LBV.DAT.mat']);
        simin.time=simin.time+length(concat_timeseries_ar.time);
        concat_timeseries_ar=append(concat_timeseries_ar,simin);
    end
end