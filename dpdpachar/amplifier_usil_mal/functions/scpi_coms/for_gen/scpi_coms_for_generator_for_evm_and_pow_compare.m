function [scpi_command_ar]=scpi_coms_for_generator_for_evm_and_pow_compare(save_file_name,x,current_dbm,DPD_ON,APSK)
run('const_for_scpi_comms.m');
%% КОМАНДЫ ДЛЯ ГЕНЕРАТОРА СИГНАЛА
i=1;

%% если dpd включен, то берем сформированные при помощи dpd символы, иначе идеальные
if DPD_ON==1
    scpi_command_ar(i)=strcat(":SOURce1:BB:ARBitrary:WAVeform:SELect " , '"' , ARBitrary_WAVeform_SELect,  num2str(x), 'APSK_sym_after_dpd_av_pow=' , num2str(current_dbm) , '.wv"');
    i=i+1;
else
    scpi_command_ar(i)=strcat(":SOURce1:BB:ARBitrary:WAVeform:SELect " , '"' ,  ARBitrary_WAVeform_SELect, num2str(x) , 'APSK_ref_symb.wv"');
    i=i+1;
end
%% выбираем формат демодуляции
scpi_command_ar(i)=strcat(":SOURce1:BB:DM:FORMat " , '"' , 'DM_FORMat_type' ,  num2str(x) , '"');
i=i+1;
%%
scpi_command_ar(i)=':SOURce1:BB:DM:STATe 1';
i=i+1;
scpi_command_ar(i)=':SOURce1:BB:ARBitrary:STATe 1';
i=i+1;
scpi_command_ar(i)=strcat(":SOURce1:BB:ARBitrary:TRIGger:SLENgth " , num2str(ARBitrary_TRIGger_SLENgth));
i=i+1;
scpi_command_ar(i)=':SOURce1:BB:ARBitrary:TRIGger:OUTPut1:MODE RAT';
i=i+1;
%% 
scpi_command_ar(i)=strcat(":SOURce1:FREQuency:CW " , num2str(FREQuency_CW));
i=i+1;
scpi_command_ar(i)=strcat(":SOURce1:BB:ARBitrary:TRIGger:OUTPut1:ONTime " , num2str(TRIGger_OUTPut1_ONTime));
i=i+1;
scpi_command_ar(i)=strcat(":SOURce1:BB:ARBitrary:TRIGger:OUTPut1:OFFTime " , num2str(TRIGger_OUTPut1_OFFTime));
i=i+1;
scpi_command_ar(i)=strcat(':SOURce1:IQ:STATe 1');
i=i+1;
scpi_command_ar(i)=strcat(":SOURce1:BB:ARBitrary:CLOCk " , num2str(ARBitrary_CLOCk));
i=i+1;
scpi_command_ar(i)=':SOURce1:MODulation:ALL:STATe 1';
i=i+1;
scpi_command_ar(i)=strcat(":SOURce1:POWer:POWer " , num2str(current_dbm));
i=i+1;
scpi_command_ar(i)=':OUTPut1:STATe 1';
i=i+1;
if x==2 %отключить iQ
    scpi_command_ar(i)=":TRIG:SEQ:SOUR:VAL IMM";
    i=i+1;
    scpi_command_ar(i)=":SENS:DDEM:SEAR:SYNC:STAT OFF";
    i=i+1;
end

