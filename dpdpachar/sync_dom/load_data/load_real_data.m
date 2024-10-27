function [real_data,ref_real_data,trace_data] = load_real_data(raw_or_iq, APSK, power, direct)
if APSK > 2
    if raw_or_iq == 1
        apsk_raw = load([direct '\ampl_scripts\output_input_signals\_' num2str(APSK) 'APSK' num2str(power) 'dbm_DPD_on=False_pa_on=True_raw.dat.mat']);
        real_data(:) = apsk_raw.simin.data(18 : floor(length(apsk_raw.simin.data)/4)); %1e5/4  + 17
        real_data = real_data.';       
    else
        apsk_raw = load([direct '\ampl_scripts\output_input_signals\_' num2str(APSK) 'APSK' num2str(power) 'dbm_DPD_on=False_pa_on=True_iq.mat']);
        real_data(:) = apsk_raw.iq_data(161 : 4 * floor(length(apsk_raw.iq_data)/4)); %4e4/4  + 160
        real_data = real_data.';
    end
    
    apsk_trace = load([direct '\ampl_scripts\output_input_signals\_' num2str(APSK) 'APSK' num2str(power) 'dbm_DPD_on=False_pa_on=True_trace.dat.mat']);
    offset = 5;
    % apsk_trace.simin.data(:,:,1:20)
    trace_data(:) = apsk_trace.simin.data(1 + offset : length(real_data)/4 + offset);
    trace_data = (trace_data).';
    
    
    apsk_ref = load([direct '\amplifier_usil_mal\_' num2str(APSK) 'APSK_ref_symb_before_transm_filter.mat']);
    apsk_ref = complex(apsk_ref.I,apsk_ref.Q);
    ref_real_data = apsk_ref(1:length(trace_data));
    ref_real_data = (ref_real_data);
else
    if raw_or_iq == 1
        apsk_raw = load([direct '\ampl_scripts\output_input_signals\_BPSK_pow=' num2str(power) '_raw.dat.mat']);
        real_data(:) = apsk_raw.simin.data(18 : floor(length(apsk_raw.simin.data)/4)); %1e5/4  + 17
        real_data = real_data.';
    else
        apsk_raw = load([direct '\ampl_scripts\output_input_signals\_BPSK_pow=' num2str(power) '_iq.mat']);
        real_data(:) = apsk_raw.iq_data(161 : floor(length(apsk_raw.iq_data)/4)); %4e4/4  + 160
        real_data = real_data.';
        
        
    end
    
    apsk_trace = load([direct '\ampl_scripts\output_input_signals\_BPSK_pow=' num2str(power) '_trace.dat.mat']);
    offset = 18;
    % apsk_trace.simin.data(:,:,1:20)
    trace_data(:) = apsk_trace.simin.data(1 + offset : length(real_data)/4 + offset);
    trace_data = (trace_data).';
    
    
    apsk_ref = load([direct '\amplifier_usil_mal\_BPSK_ref_symb_before_transm_filter.mat']);
    apsk_ref = complex(apsk_ref.I,apsk_ref.Q);
    ref_real_data = apsk_ref(1:length(trace_data));
    ref_real_data = (ref_real_data);
end




% name_of_block = [ num2str(APSK) 'APSK' num2str(power) 'dbm_DPD_on=False_pa_on=True_' ];
% %% загружаем необработанные raw или iq данные
% if raw_or_iq == 1
%     
%     apsk_raw = load(file_name_real_data);
%     real_data(:) = apsk_raw.simin.data(18 : floor(length(apsk_raw.simin.data)/4)); %1e5/4  + 17
%     real_data = real_data.';
%     
% else
%     
%     apsk_raw = load([direct '\ampl_scripts\output_input_signals\_' num2str(APSK) 'APSK' num2str(power) 'dbm_DPD_on=False_pa_on=True_iq.mat']);
%     real_data(:) = apsk_raw.iq_data(161 : floor(length(apsk_raw.iq_data)/4)); %4e4/4  + 160
%     real_data = real_data.';
%       
% end
% 
% %% загружаем trace данные
% apsk_trace = load([direct '\ampl_scripts\output_input_signals\_' num2str(APSK) 'APSK' num2str(power) 'dbm_DPD_on=False_pa_on=True_trace.dat.mat']);
% offset = 5;
% % apsk_trace.simin.data(:,:,1:20)
% trace_data(:) = apsk_trace.simin.data(1 + offset : length(real_data)/4 + offset);
% trace_data = (trace_data).';
% %% загружаем ref данные
% 
% apsk_ref = load([direct '\amplifier_usil_mal\_' num2str(APSK) 'APSK_ref_symb_before_transm_filter.mat']);
% apsk_ref = complex(apsk_ref.I,apsk_ref.Q);
% ref_real_data = apsk_ref(1:length(trace_data));
% ref_real_data = (ref_real_data);

