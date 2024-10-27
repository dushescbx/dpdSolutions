fid = fopen('C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\in_pow_out_test.txt','wt');
ar(1)="in_dbm=4.14151" + newline;
ar(2)="in_dbm=1.3221";
fprintf(fid,'%s',ar);
fclose(fid);