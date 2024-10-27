filename='C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\_32APSK7dbm_DPD_on=False_pa_on=True_iq.iq.tar';
[iq,SR]=load_iq_tar_file(filename);
pow=10*log10(mean(abs(iq).^2/1e-3))
figure;
        plot(20*log10(abs(fft(iq))));
                hold on;
        plot(20*log10(abs(fft(data_in))));
clear simin
offset_of_otscheti=0;
simin.data=iq;
simin.time=1:length(simin.data);
simin=timeseries(simin.data,simin.time);
sim('dpd_static_verify_simin_data_no_filter_test.slx');
