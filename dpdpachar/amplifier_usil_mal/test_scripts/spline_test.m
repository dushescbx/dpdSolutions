
x = 1:1:100;
x_less_step = 1:0.25:100;
step = 0.5;
step_less = 0.125;
y = 100*sin(x);


for step=0:0.1:1
    figure;
% y_less = sin(x_less_step);
xx = x + step;
% xx_less = x_less_step + step_less;
yy = spline(x,y,xx);
% yy_less = spline(x_less_step,y_less,xx_less);
plot(xx,yy);
hold on;
plot(xx,yy,'o');
hold on;
grid on;
grid minor;
plot(x,y);
plot(x,y,'x');
% plot(xx_less,yy_less);
legend('spline','spline','orig','orig');
end



% j = 1:1:4;
% jj = 1:0.1:4;
% jj_ar = 1:0.1:100;
% for ka=1:1:length(x)/4
%     yy_j(1+(ka-1)*31:1:31+(ka-1)*31) = spline(j,y(1+(ka-1)*4:1:4+(ka-1)*4),jj);
% end
% plot(jj_ar(1:length(yy_j)),yy_j);
% legend('


% figure;
% x = [ 0 1 2.5 3.6 5 7 8.1 10 ];
% y = sin(x);
% xx = 0:0.25:10;
% yy = spline(x,y,xx);
% plot(x,y,'o',xx,yy);