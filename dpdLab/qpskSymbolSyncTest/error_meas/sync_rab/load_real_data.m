function [real_data,ref_real_data,trace_data] = load_real_data(raw_or_iq)

dir = 'C:\Users\Konstantinov_PA\Desktop\amplifier\27-03';

if raw_or_iq == 1
    apsk_raw = load([dir '\ampl_scripts\output_input_signals\_32APSK7dbm_DPD_on=False_pa_on=True_raw.dat.mat']);
    real_data(:) = apsk_raw.simin.data(1:4e4);
    real_data = real_data';
else
    apsk_raw = load([dir '\ampl_scripts\output_input_signals\_32APSK7dbm_DPD_on=False_pa_on=True_iq.mat']);
    real_data(:) = apsk_raw.iq_data(1:4e4);
    real_data = real_data';
end

apsk_trace = load([dir '\ampl_scripts\output_input_signals\_32APSK7dbm_DPD_on=False_pa_on=True_trace.dat.mat']);
trace_data(:) = apsk_trace.simin.data(1:1e4);
trace_data = trace_data'; 


apsk_ref = load([dir '\amplifier_usil_mal\_32APSK_ref_symb_before_transm_filter.mat']);
apsk_ref = complex(apsk_ref.I,apsk_ref.Q);
ref_real_data = apsk_ref(1:length(trace_data));
ref_real_data = ref_real_data';

end