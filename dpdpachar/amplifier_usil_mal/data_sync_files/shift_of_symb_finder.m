function shifted_sym = shift_of_symb_finder(unshifted_sym, ref_data, figure_on)
%% находим оптимальный сдвиг из 4ех отсчетов
for i = 1:4
    %% находим коррел€цию между опорными символами и сдвинутыми синхронизируемыми
    corr_ar(i) = max(abs(xcorr(ref_data,unshifted_sym(i:4:end))));
    %% находим EVM между опорными символами и сдвинутыми синхронизируемыми
%     evm_ar(i)=evm_meas(ref_data(1:length(unshifted_sym(i:4:end))),unshifted_sym(i:4:end));
    %% строим сигнальное созвездие
    if figure_on == 1
        scatterplot(unshifted_sym(i:4:end));
        title(['sym with shift=' num2str(i)]);
    end
end
%% если математически сгенерированные данные, то считаем по min EVM, если реальные, то по max коррел€ции
% if mat_or_real == 1
%     [M,I] = min(evm_ar);
% else
    [M,I] = max(corr_ar);
% end
%% находим правильный сдвиг
shifted_sym = unshifted_sym(I : 4 : end);
%% строим сигнальное созвездие сдвинутого сигнала
if figure_on == 1
    scatterplot(shifted_sym);
    title(['sym with opt shift=' num2str(I)]);
end
end