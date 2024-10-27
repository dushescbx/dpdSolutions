clear in_dbm out_dbm EVM
for dpd_on=0:1:1
    counter=0;
    if dpd_on==1
        dpd_or_not_dpd_text='True';
    else
        dpd_or_not_dpd_text='False';
    end
    %     hfin = fopen(['_' num2str(APSK) 'APSK_input=False_dpd_on=' dpd_or_not_dpd_text '.txt'],'r');
    hfin = fopen(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\in_pow_out_pow_evm_array_' ...
        num2str(APSK_ar(l)) 'APSK_PA_ON=' PA_ON_text '_dpd_on=' dpd_or_not_dpd_text '.txt'],'r');
    i=1;
    while ~feof(hfin)
        tline = fgetl(hfin);
        %         in_out_evm(1+dpd_or_not_dpd,:,i) = sscanf(tline,'in_dbm=%f;out_dbm=%f;EVM=%f');
        switch counter
            case 0
                out_dbm(1+dpd_on,i) = sscanf(tline,'out_dbm=%f');
                counter=counter+1;
            case 1
                EVM(1+dpd_on,i) = sscanf(tline,'EVM=%f');
                counter=counter+1;
            case 2
                in_dbm(1+dpd_on,i) = sscanf(tline,'in_dbm=%f');
                counter=0;
                i=i+1;
        end
        
        
    end
    fclose(hfin);
end

inp_pow_dpd=in_dbm(2,:);
outp_pow_dpd=out_dbm(2,:);
EVM_dpd=EVM(2,:);
inp_pow_wodpd=in_dbm(1,:);
outp_pow_wodpd=out_dbm(1,:);
EVM_wo_dpd=EVM(1,:);
figure;
plot(inp_pow_wodpd,outp_pow_wodpd);
hold on;
plot(inp_pow_dpd,outp_pow_dpd);
title('Сравнение выходной мощности при on/off dpd','FontName','Arial Cyr');
xlabel('Мощность на входе','FontName','Arial Cyr');
ylabel('Мощность на выходе','FontName','Arial Cyr');
legend('wo dpd','with dpd');
figure;
plot(outp_pow_wodpd,EVM_wo_dpd);
hold on;
plot(outp_pow_dpd,EVM_dpd);
legend('wo dpd','with dpd');
title('Сравнение EVM при on/off dpd','FontName','Arial Cyr');
xlabel('Мощность на выходе','FontName','Arial Cyr');
ylabel('EVM','FontName','Arial Cyr');