clear all;
close all;

%%загружаем константы
run('constant_for_model.m');


diff_prev_a=1e3;
%% загрузка выходных данных -5 0 2 3 4 5 10
for a=7.5:0.5:8.5%0.5:0.5:1
    diff_prev_b=1e3;
    for b=10.5:1:11.5%7.5:0.5:8.5
        diff_prev_c=1e3;
        for c=14:0.5:15%13:0.5:14
            diff_prev_d=1e3;
            for d=16:0.5:17%16:0.5:17
                diff_prev_e=1e3;
                close all;
                for e=17:0.5:18%18.5:0.5:19
                    diff_prev_f=1e3;
                    for f=17:0.5:18%18.5:0.5:19
                        
                        % av_output_power_array=[ 10.25 18.25 19 20.5 20.5 18.5];
                        av_output_power_array=[ a b c d e f];
                        %% загрузка входных данных
                        data_in=data_in_form(offset);
                        %%формирование выходных данных
                        data_out=data_out_form(av_output_power_array);
                        
%                         h = rcosdesign(0.25,6,4);
                        %% коэфы усилителя
                        a_coef = fit_memory_poly_model(data_in,data_out,PAmemory,PAorder,'MemPoly');
                        save('a_coef.mat','a_coef');
                        
                        for i=1:1:length(av_power)
                            
                            load('File1_001raw_001.DAT.mat');
                            data_wo_pa_wo_filt=simin;
                            load('File1_001_001.DAT.mat');
                            av_input_power=mean(abs(simin.data).^2);
                            av_input_power_expected=1e-3*10^(av_power(i)/10);
                            diff=av_input_power_expected/av_input_power;%на сколько дбм изменить входной сигнал
                            simin.data=simin.data*sqrt(diff);
                            av_input_power=10*log10(mean(abs(simin.data).^2/1e-3))
                            
                            sim('dpd_static_verify_01_04_find_opt_volterra_20_05.slx');
                            data_in_ar_power(i)=mean(abs(data_in)).^2;
                            data_out_ar_power(i)=mean(abs(data_out)).^2;
                            abb=180/pi*angle(data_in);
                            abb1=180/pi*angle(data_out);
%                             data_in_ar_angle(i)=180/pi*mean(angle(data_in));
                            data_diff_ar_angle(i)=180/pi*mean(angle(data_out-data_in));
                        end
                        
                        %% строим графики
                        figure
                        plot(10*log10(data_in_ar_power/1e-3),10*log10(data_out_ar_power/1e-3),'-o');%
                        hold on;
                        plot([ 0 3 7 10 13 15],([8.15 10.9 14.5 16.3 17.35 17.75]));
                        % plot(10*log10(data_in_ar_power),10*log10(data_out_ar_power),'-o');%dB
                        grid on;
                        grid minor;
                        title('Характеристика усилителя','FontName','Arial Cyr');
                        xlabel('P_в_х , dBm','FontName','Arial Cyr');
                        ylabel('P_в_ы_х , dBm','FontName','Arial Cyr');
                        % xlabel('P_в_х , dB','FontName','Arial Cyr');
                        % ylabel('P_в_ы_х , dB','FontName','Arial Cyr');
                        figure
                        plot(10*log10(data_out_ar_power/1e-3),data_diff_ar_angle,'-o');%
                        hold on;
%                         plot([ 0 3 7 10 13 15],([8.15 10.9 14.5 16.3 17.35 17.75]));
                        % plot(10*log10(data_in_ar_power),10*log10(data_out_ar_power),'-o');%dB
                        grid on;
                        grid minor;
                        title('Характеристика усилителя','FontName','Arial Cyr');
                        xlabel('P_в_ы_х , dBm','FontName','Arial Cyr');
                        ylabel('phi_в_ы_х - phi_в_х , градусы','FontName','Arial Cyr');                        
                        
                        difference=find_closest_val(10*log10(data_in_ar_power/1e-3),[  0 3 7 10 13 15 ],10*log10(data_out_ar_power/1e-3),[8.15 10.9 14.5 16.3 17.35 17.75]);
                        if difference<diff_min
                            diff_min=difference;
                            diff_min_params=av_output_power_array;
                            save('diff_min_params.mat','diff_min_params');
                        end
                        
                        if diff_prev_f<difference
                            break;
                        end
                        diff_prev_f=difference;
                    end
                    if (diff_prev_e==1e3)
                        diff_prev_e=difference;
                    elseif diff_prev_e<difference
                        diff_prev_e=difference;
                        break;
                    else
                        diff_prev_e=difference;
                    end
                    
                end
                if (diff_prev_d==1e3)
                    diff_prev_d=difference;
                elseif diff_prev_d<difference
                    diff_prev_d=difference;
                    break;
                else
                    diff_prev_d=difference;
                end
                
                
            end
            
            if (diff_prev_c==1e3)
                diff_prev_c=difference;
            elseif diff_prev_c<difference
                diff_prev_c=difference;
                break;
            else
                diff_prev_c=difference;
            end
            
        end
        
        if (diff_prev_b==1e3)
            diff_prev_b=difference;
        elseif diff_prev_b<difference
            diff_prev_b=difference;
            break;
        else
            diff_prev_b=difference;
        end
        
    end
    
    if (diff_prev_a==1e3)
        diff_prev_a=difference;
    elseif diff_prev_a<difference
        diff_prev_a=difference;
        break;
    else
        diff_prev_a=difference;
    end
    
end


% figure
% plot(real(data_in_ar),real(data_out_ar));%,'-o'
% grid on;
% title('Характеристика усилителя','FontName','Arial Cyr');
% xlabel('U_в_х , V','FontName','Arial Cyr');
% ylabel('U_в_ы_х , V','FontName','Arial Cyr');
