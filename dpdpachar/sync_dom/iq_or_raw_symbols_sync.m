close all
raw_or_iq = 0;
APSK = 32;
if APSK == 2
    direct = 'C:\Users\Konstantinov_PA\Desktop\RABOTA\actual';
else
    direct = 'C:\Users\Konstantinov_PA\Desktop\RABOTA\actual';
end
for i = APSK
    for power = 10:13
        symbol_synch_data = conv_unsync_iq_to_sync(i, power, raw_or_iq, direct);
    end
end


