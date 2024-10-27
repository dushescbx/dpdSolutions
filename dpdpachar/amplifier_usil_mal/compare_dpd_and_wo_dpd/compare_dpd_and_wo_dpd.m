function compare_dpd_and_wo_dpd(const)
for APSK = const.sig.APSK
    %% загружаем массив мощностей
    [input_ar, output_ar] = download_power_arrays(const.com, APSK);
    for samples_power = const.sig.in_power
        clear simin
        %% загружаем данные спектра
        load(strcat(const.com.pa_meas_sig_folder_name, '\_', num2str(APSK), ...
            'APSK', num2str(samples_power), 'dbm_spectrum_trace.dat.mat'));
        x_spect_wo_dpd(:) = real(simin.data);
        y_spect_wo_dpd(:) = imag(simin.data);
        wo_dpd_trace = simin.data;
        clear simin
        load(strcat(const.com.pa_meas_sig_folder_name, '\_', num2str(APSK), ...
            'APSK', num2str(samples_power), 'dbm_trace.dat.mat'));
        no_dpd_sym = simin.data;
        %% загружаем данные созвездия
        for cur_model_pow = const.sig.in_power(end) - const.PA_meas.offset_ar
            for current_dbm = samples_power - const.DPD.step_for_compare : const.DPD.step_for_compare : samples_power + const.DPD.step_for_compare %const.sig.in_power
                %% загружаем данные спектра
                clear simin
                load(strcat(const.DPD.data_from_dpd_meas(2),...
                    "\in_power=", num2str(current_dbm),...
                    "model_power=", num2str(cur_model_pow), '_samples_power=', num2str(samples_power), '_spectrum_trace.dat.mat'));
                x_spect_with_dpd(:) = real(simin.data);
                y_spect_with_dpd(:) = imag(simin.data);
                figure;
                plot(x_spect_wo_dpd, y_spect_wo_dpd);
                hold on
                plot(x_spect_with_dpd, y_spect_with_dpd);
                legend('wo dpd', 'with dpd');
                title(['cur model pow=' num2str(cur_model_pow) ' current dbm=' num2str(samples_power)]);
                %% загружаем данные созвездия
                clear simin
                load(strcat(const.DPD.data_from_dpd_meas(2),...
                    "\in_power=", num2str(current_dbm),...
                    "model_power=", num2str(cur_model_pow), '_samples_power=', num2str(samples_power), '_trace.dat.mat'));
                dpd_sym = simin.data;
                
                compare_scatterplots_dpd_wo_dpd( dpd_sym, no_dpd_sym, 0, samples_power, cur_model_pow)
                close all
            end
        end
    end
    
    for cur_model_pow = const.sig.in_power(end) - const.PA_meas.offset_ar
        figure;
        for samples_power = const.sig.in_power
            EVM_with_dpd = load(strcat(const.DPD.data_from_dpd_meas(2), const.com.output_EVM_with_dpd, ...
                'cur_model', num2str(cur_model_pow), '_samples_power=', num2str(samples_power), '_', num2str(APSK),  'APSK.txt.mat'));
            power_with_dpd = load(strcat(const.DPD.data_from_dpd_meas(2), const.com.output_pa_power_with_dpd, ...
                'cur_model', num2str(cur_model_pow), '_samples_power=', num2str(samples_power), '_', num2str(APSK),  'APSK.txt.mat'));
            power_wo_dpd = load(strcat(const.com.pa_meas_sig_folder_name, const.com.output_pa_power_wo_dpd, ...
                num2str(APSK),  'APSK.txt.mat'));
            EVM_wo_dpd = load(strcat(const.com.pa_meas_sig_folder_name, const.com.output_EVM_wo_dpd, ...
                num2str(APSK),  'APSK.txt.mat'));
            plot(power_with_dpd.d, EVM_with_dpd.d, 'c*');
            hold on
            plot(power_wo_dpd.d, EVM_wo_dpd.d);
            legend('with dpd', 'wo dpd');
            title(['cur model pow=' num2str(cur_model_pow) 'samples power' num2str(samples_power)]);
        end
    end
end