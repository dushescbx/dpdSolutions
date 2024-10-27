function shifted_sym = shift_of_symb_finder(unshifted_sym, ref_data, figure_on)
%% ������� ����������� ����� �� 4�� ��������
for i = 1:4
    %% ������� ���������� ����� �������� ��������� � ���������� �����������������
    corr_ar(i) = max(abs(xcorr(ref_data,unshifted_sym(i:4:end))));
    %% ������� EVM ����� �������� ��������� � ���������� �����������������
%     evm_ar(i)=evm_meas(ref_data(1:length(unshifted_sym(i:4:end))),unshifted_sym(i:4:end));
    %% ������ ���������� ���������
    if figure_on == 1
        scatterplot(unshifted_sym(i:4:end));
        title(['sym with shift=' num2str(i)]);
    end
end
%% ���� ������������� ��������������� ������, �� ������� �� min EVM, ���� ��������, �� �� max ����������
% if mat_or_real == 1
%     [M,I] = min(evm_ar);
% else
    [M,I] = max(corr_ar);
% end
%% ������� ���������� �����
shifted_sym = unshifted_sym(I : 4 : end);
%% ������ ���������� ��������� ���������� �������
if figure_on == 1
    scatterplot(shifted_sym);
    title(['sym with opt shift=' num2str(I)]);
end
end