function [] ...
    = paCharTest(table, tableDPD, PAGain)
if 1
    % close all
    figure;
    plot(table(:,1), table(:,2), '.')
    hold on
    plot(tableDPD(:,1), tableDPD(:,2) + PAGain, '.')
    grid on
    xlabel('Input Power (dBm)')
    ylabel('Output Power (dBm)')
    title('Output vs Input Power LUT');
    figure;
    plot(table(:,1), table(:,3), '.')
    hold on
    plot(tableDPD(:,1), tableDPD(:,3), '.')
    grid on
    xlabel('Input Power (dBm)')
    ylabel('Output phase (deg)')
    title('Output phase vs Input Power LUT');
end



end
