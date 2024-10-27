%% ������ � ���������(����� �������)

run('download_power_arrays.m');
data_in=zeros(0,0);
data_out=zeros(0,0);
data_out_from_model=zeros(0,0);
data_out_from_scope=zeros(0,0);
for i=1:1:length(input_ar.d)
    
    %% �������� ������� ������
    
%     %% ������ �� ���� ��������� �������
%     load(['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier_usil_mal\' num2str(APSK_ar(f)) 'APSK_ref_symb_timeseries.mat']);
%     data_in_ADD=ref_sym_symbols.data(1:ARBitrary_TRIGger_SLENgth);
%     %         scatterplot(data_in_ADD);
%     data_in_ADD=scale_power(data_in_ADD(:),input_ar.d,i);
%     
%  
%     %% ����������� ������� ��������� ������ ��������;
    
%     data_in=[data_in; data_in_ADD(1:length(data_in_ADD)-17)];
      %% �������� ������� ������
    
    %% ������ �� ���� ��������� ������� ����� ����������� �������
    load(['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier_usil_mal\_' num2str(APSK_ar(f)) 'APSK_ref_symb_after_filter.mat']);
    data_in_ADD=ref_sym;
    %% ������������ � ������������ � ������� ���������
    data_in_ADD=scale_power(data_in_ADD,input_ar.d,i);
    
    %         scatterplot(data_in_ADD);
    %% ����������� ������� �������� IQ ������ ��������;
    
    data_in=[data_in; data_in_ADD(18:4*ARBitrary_TRIGger_SLENgth)];
      
    

    
    %% ��������� ������� ��������� �� �����������
    load(['C:\Users\Konstantinov_PA\Desktop\amplifier\ampl_scripts\output_input_signals\_' num2str(APSK_ar(f)) 'APSK'  num2str(input_ar.d(i)) 'dbm_DPD_on=False_pa_on=True_raw.dat.mat'])
    data_out_ADD=simin.data;
%             scatterplot(simin.data);
    %% ������������ � ������������ � �������� ���������
    data_out_ADD=scale_power(data_out_ADD(:),output_ar.d,i);
    
    %% ����������� �������� �������� ������
    data_out=[ data_out(:); data_out_ADD(18:length(data_in_ADD)) ];
    %         scatterplot(data_out_ADD);
    
    
    
    
end

%% ���������� ��������� �������� � �������
plot_time_graph_and_spectrum(data_in,data_out);

data_out_from_scope=data_out;
%% ��������� ������������� ��� ������ ���������
a_coef = fit_memory_poly_model(data_in(1:length(data_out)),data_out,PAmemory,PAorder,'MemPoly')
save(['a_coef_' num2str(APSK_ar(f)) 'APSK_raw.mat'],'a_coef');


%% ������������� ��������� ��� ������ ������ ��������� � a_coef
shag=current_dbm_ar(2)-current_dbm_ar(1);
current_dbm_ar_for_ampl_char=[current_dbm_ar(1:end) ];%current_dbm_ar(end)+shag current_dbm_ar(end)+2*shag current_dbm_ar(end)+3*shag current_dbm_ar(end)+4*shag
data_in_from_model=zeros(0,0);
data_out_from_model=zeros(0,0);

for i=1:1:length(current_dbm_ar_for_ampl_char)
    load(['a_coef_' num2str(APSK_ar(f)) 'APSK_raw.mat'],'a_coef');
     clear simin
    %% ��������� ��������� �������
    load(['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier_usil_mal\_' num2str(APSK_ar(f)) 'APSK_ref_symb_after_filter.mat']);
    simin.data=ref_sym(18:4e4-2,1);
    simin.time=0:length(simin.data)-1;
    
    %% ������������ ��� �������� ��������
    simin.data=scale_power(simin.data,current_dbm_ar_for_ampl_char,i);
    simin=timeseries(simin.data,simin.time);
    
    sim('dpd_static_verify_simin_data_no_filter.slx');
    %% ���������� ������� � �������� �������� � ������
    data_in_ar_power(i)=mean(abs(data_in)).^2;
    data_out_ar_power(i)=mean(abs(data_out_model)).^2;
    
    data_out_from_model=[ data_out_from_model(:); data_out_model(1:4*ARBitrary_TRIGger_SLENgth) ];
    data_in_from_model=[data_in_from_model; ref_sym(18:4e4-2,1)];
    %% ����������� �������� ������
    data_in_ar=[ data_in_ar(:); data_in(1:4e4)];
    data_out=[ data_out(:); data_out_model(1:4e4) ];
end
    

plot_time_graph_and_spectrum(data_in_from_model,data_out_from_model);
compare_constellations(data_out_from_model,data_out);
%     data_out_from_model=data_out_from_model(11:end);
%     data_out_from_scope=data_out_from_scope(6:end);
