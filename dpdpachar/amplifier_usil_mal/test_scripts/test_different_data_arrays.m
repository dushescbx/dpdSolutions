clear all;
close all;
run('constant_for_model.m');
load('a_coef.mat');
simulation_data=timeseries([],[]);

for i=-20:1:-5
    
    load(['C:\Users\Konstantinov_PA\Desktop\amplifier\_13_11\Temp\_8APSK'  num2str(i)  'dbm_DPD_on=False_input=True.DAT.mat']);
    simin.time=simin.time+length(simulation_data.time);
    simulation_data=append(simulation_data,simin);
    
end

 sim('amplifier_char_meas.slx');