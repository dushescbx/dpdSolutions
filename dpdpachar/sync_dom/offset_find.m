function data_out = offset_find(data_in, data_in_ref)

%% находим сдвиг данных
%% определ€ем максимальную длину из сдвигаемых и ref данных
max_len = max([length(data_in) length(data_in_ref)]);
%% находим коррел€цию
correl = abs(xcorr(data_in,data_in_ref));
%% находим максимум коррел€ции
[M, I] = max(correl);
% %% строим график коррел€ции
% plot(correl);
% title('correl');
%% сдвигаем данные
data_out = data_in(I - max_len + 1 : end);

end