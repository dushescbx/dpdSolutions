function compare_scatterplots_dpd_wo_dpd( dpd_sym, wo_dpd_sym, evm, power, model_power)
figure;
subplot(1,2,1)
scatter(real(dpd_sym), imag(dpd_sym), 10, [0 0.5 0.5], 'filled');
title(['dpd symbols EVM=' num2str(evm) '% power =' num2str(power) 'model coef power=' num2str(model_power)])
axis tight
subplot(1,2,2)
scatter(real(wo_dpd_sym), imag(wo_dpd_sym), 10, [0 0.5 0.5], 'filled');
title(['wo DPD symbols'])
axis tight
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
end