close all
for k=1:1:2
    figure;
    x=0:1:10;
    y=10:1:20;
    plot(x,y);
    hold on;
    plot(y,x);
    title('��������� �������� �������� ��� on/off dpd','FontName','Arial Cyr');
    xlabel('�������� �� �����','FontName','Arial Cyr');
    ylabel('�������� �� ������','FontName','Arial Cyr');
    legend('wo dpd',['with dpd',num2str(k)]);
    
end