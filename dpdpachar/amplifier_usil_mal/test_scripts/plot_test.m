close all
for k=1:1:2
    figure;
    x=0:1:10;
    y=10:1:20;
    plot(x,y);
    hold on;
    plot(y,x);
    title('Сравнение выходной мощности при on/off dpd','FontName','Arial Cyr');
    xlabel('Мощность на входе','FontName','Arial Cyr');
    ylabel('Мощность на выходе','FontName','Arial Cyr');
    legend('wo dpd',['with dpd',num2str(k)]);
    
end