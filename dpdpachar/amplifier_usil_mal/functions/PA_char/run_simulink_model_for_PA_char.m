function [] = run_simulink_model_for_PA_char(APSK,model_sim_time,av_pow_min,av_pow_max,shag_tcikla)
run('constant_for_model.m');
load('a_coef.mat');
ji=1;
for av_power=av_pow_min:1:av_pow_max
    % av_power=-7+7:1:3+7;
    gain_db=gain_db_opt(ji)-shag_tcikla/2:shag_tcikla/2:gain_db_opt(ji)+shag_tcikla/2;
    load(['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier_usil_mal\' num2str(APSK) 'APSK_ref_symb_timeseries.mat']);
    simin.time=ref_sym1.time;
    simin.data=ref_sym1.data;
    simin=timeseries([simin.data],[simin.time]);
    % load('C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier - копи€ (3) - копи€ - копи€ - копи€ - копи€\New folder\Temp\_-3dbm_DPD_on=False_input=False.DAT.mat');
    %без усилител€
    av_input_power=mean(abs(simin.data).^2);
    av_input_power_expected=1e-3*10^(av_power(1)/10);
    diff=av_input_power_expected/av_input_power;%на сколько дбм изменить входной сигнал
    simin.data=simin.data*sqrt(diff);
    av_input_power=10*log10(mean(abs(simin.data).^2/1e-3))
    for Le=1:1:length(gain_db) %% мен€ем коэф. усилени€ в цепи обр.св€зи
        close all
        
        k=1;
        f=1;
        init_coef(f,k)=0.5;
        for f=1:1:5 %мен€ем C0 (начальные коэффы DPD)
            k=1;
            init_coef(f+1,k)=init_coef(f,k)/2;
            P0(f,k,1:MK,1:MK)=(4e1)*complex(eye(MK));
            for k=1:1:5 %мен€ем P0
                init_coef(f,k+1)=init_coef(f,k);
                P0(f,k+1,:,:)=P0(f,k,:,:)./2;
                %% запуск модели
                P_current=reshape(P0(f,k,:,:),MK*MK,1);
                sim('Copy_of_dpd_static_verify_01_04_find_opt_volterra_20_05.slx');
                %             sim('dpd_pa_model_for_find_opt_consts.slx');
                
                %% вычисление EVM, построение созвездий
                x=length(ref_sig);
                
                av_power_ref_sig(f,k)=mean(abs(ref_sig.^2));%средн€€ мощность опорного сигнала
                av_power_with_dpd_ar(f,k)=mean(abs(out_sig_with_dpd.^2));%средн€€ мощность с предисказителем
                av_power_wo_dpd_ar(f,k)=mean(abs(out_sig_wo_dpd.^2));%средн€€ мощность без предисказител€
                
                norm_out_ref_sig=ref_sig./sqrt(av_power_ref_sig(f,k));%нормирование символов по мощности
                norm_out_sig_with_dpd=out_sig_with_dpd./sqrt(av_power_with_dpd_ar(f,k));%нормирование символов по мощности
                norm_out_sig_wo_dpd=out_sig_wo_dpd./sqrt(av_power_wo_dpd_ar(f,k));%нормирование символов по мощности
                
                EVM_with_dpd(f,k)=evm_meas(norm_out_ref_sig(x/divider:end),norm_out_sig_with_dpd(x/divider:end))
                EVM_wo_dpd(f,k)=evm_meas(norm_out_ref_sig(x/divider:end),norm_out_sig_wo_dpd(x/divider:end));
                
                
            end
            
            
            
        end
        
        diff_btw_av_pow=abs(av_power_with_dpd_ar-av_power_wo_dpd_ar)./av_power_wo_dpd_ar*100;
        EVM_plus_av_pow=(1-((EVM_wo_dpd-EVM_with_dpd)./EVM_wo_dpd));
        min_val_ar=EVM_plus_av_pow+diff_btw_av_pow;
        [min_val,min_ind]=min(min_val_ar(:));
        [min_ind_row,min_ind_col]=ind2sub(size(EVM_plus_av_pow),min_ind);
        
        P_min_ar(Le,1)=init_coef(min_ind_row,min_ind_col);
        P_min_ar(Le,2)=EVM_with_dpd(min_ind_row,min_ind_col);
        P_min_ar(Le,3)=EVM_wo_dpd(min_ind_row,min_ind_col);
        P_min_ar(Le,4)=av_power_wo_dpd_ar(min_ind_row,min_ind_col);
        P_min_ar(Le,5)=av_power_with_dpd_ar(min_ind_row,min_ind_col);
        P_min_ar(Le,6)=P0(min_ind_row,min_ind_col,1,1);
        P_min_ar(Le,7)=min_val;
        
        
    end
    
    [min_val_fin,min_ind_fin]=min(P_min_ar);
    min_val_fin=min_val_fin(end);
    min_ind_fin=min_ind_fin(end);
    
    init_coef_opt(ji)=P_min_ar(min_ind_fin,1)
    P0_opt(ji)=P_min_ar(min_ind_fin,6)
    gain_db_opt_sec(ji)=gain_db(min_ind_fin)
    av_power_ar(ji)=av_power;
    opt_constants=[ init_coef_opt; P0_opt; gain_db_opt_sec; av_power_ar;];
    ji=ji+1;
end
save('opt_constants.mat','opt_constants');
end