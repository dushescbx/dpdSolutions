function [raw_data, ref_real_data, trace_data] = load_ref_data(apsk, power)

dir = 'C:\Users\Konstantinov_PA\Desktop\amplifier\27-03';
% apsk_raw = load([dir '\ampl_scripts\output_input_signals\_' num2str(apsk) 'APSK' num2str(power) 'dbm_DPD_on=False_pa_on=True_raw.dat.mat']);
% raw_data = apsk_raw.simin.data(:);

apsk_trace = load([dir '\ampl_scripts\output_input_signals\_' num2str(apsk) 'APSK' num2str(power) 'dbm_DPD_on=False_pa_on=True_trace.dat.mat']);
trace_data = apsk_trace.simin.data(:);

apsk_ref = load([dir '\amplifier_usil_mal\_' num2str(apsk) 'APSK_ref_symb_before_transm_filter.mat']);
apsk_ref = complex(apsk_ref.I,apsk_ref.Q);
ref_real_data = apsk_ref(1:length(raw_data)/4);

end