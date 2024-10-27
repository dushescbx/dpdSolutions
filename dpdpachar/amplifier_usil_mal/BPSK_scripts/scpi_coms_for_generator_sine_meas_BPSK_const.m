function [scpi_command_ar]=scpi_coms_for_generator_sine_meas_BPSK_const(x)
run('const_for_scpi_comms.m');


%%  ŒÃ¿Õƒ€ ƒÀﬂ √≈Õ≈–¿“Œ–¿ —»√Õ¿À¿
i=1;
scpi_command_ar(i)=strcat(":SOURce1:BB:ARBitrary:WAVeform:SELect " , '"' , ARBitrary_WAVeform_SELect , "BPSK_ref_symb_after_filter_for_conv_wv.wv" , '"');
i=i+1;
scpi_command_ar(i)=strcat(":SOURce1:BB:DM:FORMat " , '"'  ,'DM_FORMat_type',  num2str(x) , '"');
i=i+1;
scpi_command_ar(i)=':SOURce1:BB:DM:STATe 1';
i=i+1;
scpi_command_ar(i)=':SOURce1:BB:ARBitrary:STATe 1';
i=i+1;
scpi_command_ar(i)=strcat(":SOURce1:BB:ARBitrary:TRIGger:SLENgth ", num2str(ARBitrary_TRIGger_SLENgth));
i=i+1;
scpi_command_ar(i)=':SOURce1:BB:ARBitrary:TRIGger:OUTPut1:MODE RAT';
i=i+1;
scpi_command_ar(i)=strcat(":SOURce1:FREQuency:CW ", num2str(FREQuency_CW));
i=i+1;
scpi_command_ar(i)=strcat(":SOURce1:BB:ARBitrary:TRIGger:OUTPut1:ONTime " ,num2str(TRIGger_OUTPut1_ONTime));
i=i+1;
scpi_command_ar(i)=strcat(":SOURce1:BB:ARBitrary:TRIGger:OUTPut1:OFFTime " ,num2str(TRIGger_OUTPut1_OFFTime));
i=i+1;
scpi_command_ar(i)=strcat(':SOURce1:IQ:STATe 1');
i=i+1;
scpi_command_ar(i)=strcat(":SOURce1:BB:ARBitrary:CLOCk " ,num2str(ARBitrary_CLOCk));
i=i+1;
scpi_command_ar(i)=':SOURce1:MODulation:ALL:STATe 1';
i=i+1;
scpi_command_ar(i)=':OUTPut1:STATe 1';
i=i+1;
