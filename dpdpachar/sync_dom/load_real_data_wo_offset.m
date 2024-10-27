function [real_data,ref_real_data,trace_data] = load_real_data_wo_offset(raw_or_iq, APSK, power, direct)
%% задаем пути к файлам
%% если raw данные
if raw_or_iq == 1
    %% если не BPSK, а qpsk 8apsk, 16 apsk
    if APSK > 2
        name_of_block_real_data = [ direct '\ampl_scripts\output_input_signals\_' num2str(APSK) 'APSK' num2str(power) 'dbm_DPD_on=False_pa_on=True_raw.dat.mat' ];
    else
        name_of_block_real_data = [ direct '\ampl_scripts\output_input_signals\_BPSK_pow=' num2str(power) '_raw.dat.mat' ];
    end
else
    %% если iq данные
    if APSK > 2
        name_of_block_real_data = [ direct '\ampl_scripts\output_input_signals\_' num2str(APSK) 'APSK' num2str(power) 'dbm_DPD_on=False_pa_on=True_iq.mat' ];
    else
        name_of_block_real_data = [ direct '\ampl_scripts\output_input_signals\_BPSK_pow=' num2str(power) '_iq.mat' ];  
    end
end

%% загружаем необработанные raw или iq данные
if raw_or_iq == 1
    
    apsk_raw = load(name_of_block_real_data);
    real_data(:) = apsk_raw.simin.data(1 : floor(length(apsk_raw.simin.data)/4)); %1e5/4  + 17
    real_data = real_data.';
    
else
    
    apsk_raw = load(name_of_block_real_data);
    real_data(:) = apsk_raw.iq_data(1 : floor(length(apsk_raw.iq_data)/4)); %4e4/4  + 160
    real_data = real_data.';
    
end

%% задаем пути к файлам
if APSK > 2
    name_of_block_trace_data = [ direct '\ampl_scripts\output_input_signals\_' num2str(APSK) 'APSK' num2str(power) 'dbm_DPD_on=False_pa_on=True_trace.dat.mat' ];
else
    name_of_block_trace_data = [ direct '\ampl_scripts\output_input_signals\_BPSK_pow=' num2str(power) '_trace.dat.mat' ];
end

%% загружаем trace данные
apsk_trace = load(name_of_block_trace_data);
offset = 0;
% apsk_trace.simin.data(:,:,1:20)
trace_data(:) = apsk_trace.simin.data(1 + offset : length(real_data)/4 + offset);
trace_data = (trace_data).';

%% загружаем ref данные
%% задаем пути к файлам
if APSK > 2
    name_of_block_ref_data = [direct '\amplifier_usil_mal\_' num2str(APSK) 'APSK_ref_symb_before_transm_filter.mat'];
else
    name_of_block_ref_data = [direct '\amplifier_usil_mal\_BPSK_ref_symb_before_transm_filter.mat'];
end
%% загружаем ref данные
apsk_ref = load(name_of_block_ref_data);
apsk_ref = complex(apsk_ref.I,apsk_ref.Q);
ref_real_data = apsk_ref(1:length(trace_data));
ref_real_data = (ref_real_data);














