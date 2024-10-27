function data_out = offset_find(data_in, data_in_ref)

%% ������� ����� ������
%% ���������� ������������ ����� �� ���������� � ref ������
max_len = max([length(data_in) length(data_in_ref)]);
%% ������� ����������
correl = abs(xcorr(data_in,data_in_ref));
%% ������� �������� ����������
[M, I] = max(correl);
% %% ������ ������ ����������
% plot(correl);
% title('correl');
%% �������� ������
if (I - max_len >= 0)
    data_out = data_in(I - max_len + 1 : end);
else
    data_out = data_in;
end
end