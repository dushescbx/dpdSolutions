function compare_scatterplots(symbol_synch_data, rx_filter_out, trace_data, APSK, power, evm, evm_no_sync, del_vec)
figure;
subplot(1,3,1)
scatter(real(rx_filter_out), imag(rx_filter_out), 10, [0 0.5 0.5], 'filled');
title(['unsync symbols EVM=' num2str(evm_no_sync) '%'])
axis tight
subplot(1,3,2)
scatter(real(symbol_synch_data), imag(symbol_synch_data), 10, [0 0.5 0.5], 'filled');
title(['sync symbols ' num2str(APSK) 'APSK power=' num2str(power) ' EVM=' num2str(evm) '% delay =' num2str(del_vec) ])
axis tight
subplot(1,3,3)
scatter(real(trace_data), imag(trace_data), 10, [0 0.5 0.5], 'filled');
title('trace data')
axis tight
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
end