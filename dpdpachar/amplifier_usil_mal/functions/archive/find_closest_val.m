% input_1=[7.73641329372854e-05 9.73956729161694e-05 0.000122613887632960 0.000154361738980007 0.000194329915810668 0.000244646869285871 0.000307992160659869 0.000387739157688103 0.000488134678761221 0.000614525151470478 0.000773641329372849 0.000973956729161696 0.00122613887632959 0.00154361738980007 0.00194329915810671 0.00244646869285873 0.00307992160659870 0.00387739157688098 0.00488134678761215 0.00614525151470486 0.00773641329372846];
% input_1=10*log10(input_1./1e-3);
% input_2=[-5 (0:8)];
% output_ar_1=[0.00470127014714170 0.00551733219676721 0.00654143263736344 0.00786448870334722 0.00961855166496899 0.0119896263201824 0.0152283188860343 0.0196495444470176 0.0256047739718549 0.0334029985913010 0.0431594548580316 0.0545822357352618 0.0667835158856834 0.0783086843408011 0.0876149783494170 0.0940216720833932 0.0986160925692709 0.104052612444367 0.112343527409243 0.123016717571112 0.155353950544678];
% output_ar_1=10*log10(output_ar_1/1e-3);
% output_ar_2=[12 17 18 19 19.5 20 20 20 20 20];
%%������� ������� �������� ������� ������� � input_1 � ������� �������� � input_2,
%���������� ������ ��������, ����� ����������� ��� �������� �������
%�� �������� ��������, ����� �� �������, �� ������� ������ �����������
%��� �������� ��������. �.�. �� ������ ����� ������ output_1, ������� ������ �������
%��������� ������ output_2
% !!! ������ _2 ��������, ��� ��� ������� �������� ������.

function diff_av=find_closest_val(input_1,input_2,output_ar_1,output_ar_2) %
min_index=zeros(1,length(input_2));
for i=1:1:length(input_2)
    %     if (output_2(i)>0)
    %     output=input_1-input_2(i);
    %     else
    %         output=output_1+output_2(i);
    %     end
    [~,min_index(i)]=min(abs(input_1-input_2(i)));
end
diff_av=mean(abs(output_ar_1(min_index)-output_ar_2));
end