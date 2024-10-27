          %% ������ �������� �������� � ����������� �� ������� !!!�� ������!!! � ���������
    figure(f1);
    plot(10*log10(data_in_ar_power_after_filt_iq/1e-3),10*log10(data_out_ar_power_after_filt_iq/1e-3),'-o');%
    hold on;
    grid on;
    
    %% ������ �������� �������� � ����������� �� ������� !!!�� ������!!! � ���������
    plot(10*log10(data_in_ar_power/1e-3),10*log10(data_out_ar_power/1e-3),'-*');%
    hold on;
    grid on;
        %% ������ �������� �������� � ����������� �� ������� !!!�� ���������� ���������� � �����������!!!

    plot(input_ar.d,output_ar.d);
 
    
    plot(10*log10(data_in_ar_power_after_filt/1e-3),10*log10(data_out_ar_power_after_filt/1e-3),'-o');%
    %% ������ �������������� ���������
    grid on;
    grid minor;
    title(['�������������� ���������'],'FontName','Arial Cyr');
    xlabel('P_�_� , dBm','FontName','Arial Cyr');
    ylabel('P_�_�_� , dBm','FontName','Arial Cyr');
    legend('kusochnaya char','char by volterra before filt �������','char by volterra after filt �������','char by symbols from scope','char by model sine','char by sine meas from scope with marker', 'char by sine meas from scope with vsa');
    