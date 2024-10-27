clear all;
fid_outp=fopen(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\_output_power_arr.txt'],'w');
a=[-24.1703071594000 -23.1729393005000 -22.1713771820000 -21.1667804718000];
fprintf(fid_outp,'%+2.5f\n',a);
fclose(fid_outp);