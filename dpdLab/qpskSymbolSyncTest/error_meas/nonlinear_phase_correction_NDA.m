function d_out = nonlinear_phase_correction_NDA(y, y1, M)

%% подстройка фазы
% 
y_M = y.^M;

% theta_est = 1/(M) * angle(sum(y_M));
% RF Architectures and Digital Signal Processing Aspects of Digital Wireless Transceivers - Nezami
% p. 7-22 Но там ошибка, указано arg вместо atan
theta_est = 1/(M) * atan(sum(imag(y_M))/sum(real(y_M)));

angle_shift = exp(1i * theta_est)'; 

d_out = y.*angle_shift;

% theta_ang_est = 1/(M) * angle(sum(y_M)) * 180 / pi;
figure;
plot(y);
figure;
plot(y1);
% figure;
% plot(y_M);
% figure;
% plot(real(y_M));
% hold on
% plot(imag(y_M));