            
function data_out=scale_power(data_in,power_ar,i)
%% ÌÀÑØÒÀÁÈĞÓÅÌ Â ÑÎÎÒÂÅÒÑÒÂÈÈ Ñ ÂÕÎÄÍÎÉ ÌÎÙÍÎÑÒÜŞ
            av_input_power=mean(abs(data_in).^2);
            av_input_power_expected=1e-3*10^((power_ar(i))/10);%1e-3*
            diff=av_input_power_expected/av_input_power;%íà ñêîëüêî äáì èçìåíèòü âõîäíîé ñèãíàë
            data_out=data_in*sqrt(diff);
%             av_input_power=10*log10(mean(abs(data_out).^2)/1e-3);
end