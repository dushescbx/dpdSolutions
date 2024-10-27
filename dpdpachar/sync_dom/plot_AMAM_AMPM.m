function plot_AMAM_AMPM_with(power_data_out_from_model, power_data_out_from_scope, power_data_in_from_model, ...
    power_data_in_from_scope, angle_from_scope, angle_from_model, data_for_legend, PAmemory, PAorder)
%% AM/AM
figure;
hold on
plot(power_data_in_from_scope, power_data_out_from_scope);
plot(power_data_in_from_model, power_data_out_from_model);
legend(['meas' string(data_for_legend)]);
title(['AM/AM PA ord=' num2str(PAorder) ' PA mem=' num2str(PAmemory)]);
%% AM/PM
figure;
hold on
plot(power_data_in_from_scope, angle_from_scope);
plot(power_data_in_from_model, angle_from_model);
legend(['meas' string(data_for_legend)]);
title(['AM/PM PA ord=' num2str(PAorder) ' PA mem=' num2str(PAmemory)]);
end