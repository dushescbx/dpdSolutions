clear all
close all
load('x.mat');
% load('y.mat');

x = x./max(x);
figure; plot(x);
%% params
timeShiftVal = 0.1; %% -1 ... 1
%%
t = 0 : length(x) - 1;
tNew = t + timeShiftVal;
xNew = spline(t, x, tNew);
xNew = circshift(xNew, length(xNew)/2);
%%
% figure;
% plot(t, real(x), '-*');
% hold on
% plot(tNew, real(xNew), '-o');
figure; plot(abs(xcorr(xNew, x)));
%% timing syncronize
[d_out, timeOffset] = timingSynchronize(xNew,...
    x, 1);
%%
figure; plot(abs(xcorr(d_out, x)));
% figure;
% plot(t, real(x), '-*');
% hold on
% plot(t, real(d_out), '-o');
%%