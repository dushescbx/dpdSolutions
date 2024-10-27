function compare_constellations(data_out_from_model,data_out_from_scope, data_out_from_sim)
%% строим графики
procent = 100;

if length(data_out_from_scope)>length(data_out_from_model)
    dlina=length(data_out_from_model);
else
    dlina=length(data_out_from_scope);
end
% dlina = 1e5;
x=180/pi*(angle(data_out_from_model(1:dlina))-angle(data_out_from_scope(1:dlina)));
for ka=1:1:length(x)
    if x(ka)>180
        x(ka)=360-x(ka);
    elseif x(ka)<-180
        x(ka)=360+x(ka);
    end
end
figure;
plot(x);
title("angle error");


data_out_from_model=scale_power(data_out_from_model(1:dlina),0,1);
data_out_from_scope=scale_power(data_out_from_scope(1:dlina),0,1);

% ampl_comp=((abs(data_out_from_model(1:dlina)-data_out_from_scope(1:dlina))));
% EVM_comp = evm_meas(data_out_from_model(1:dlina), data_out_from_scope(1:dlina))
% for i=1:1:length(ampl_comp)
%     if ampl_comp(i)>=50
%         title("angle error");
%     end
% end
% figure;
% plot(ampl_comp);
% title("abs error");
% mean_abs_error = mean(ampl_comp)

figure;
plot(abs(data_out_from_model));
hold on;
plot(abs(data_out_from_scope));
title("abs of sigs");
legend('data from model','measured data');

data_out_from_model = rx_filter(data_out_from_model(1:5e5));
scatterplot(data_out_from_model);
title("data from model");
data_out_from_scope = rx_filter(data_out_from_scope(1:5e5));
scatterplot(data_out_from_scope);
title("data from scope");

% figure;
% plot(imag(data_out_from_model));
% hold on;
% plot(imag(data_out_from_scope));
% title("imag part of sigs");
% legend('data from model','measured data');
% 
% scatterplot(data_out_from_model);
% title('data from model');
% scatterplot(data_out_from_scope);
% title('data from scope');
% scatterplot(data_out_from_sim);
% title('data from sim');
end