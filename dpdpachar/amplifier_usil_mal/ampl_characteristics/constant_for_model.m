BW =50e6;
Tstep = 1;
dataRatePA = 1/15.36e6;
FrameLength = 128;
model_sim_time=1e5;

PAorder = 5;
PAmemory = 5;
% RPEM algorithm parameters
DPDorder = 5;
DPDmemory = 5;

MK=DPDorder*DPDmemory;
L0=0.99;
L_init=0.99;
P0=0.01*complex(eye(MK));
input_arr=[0:15];
num_dem=0;
filter_num=[ .25]*exp(j*pi/4);     % phase offset
filter_den=[1 -.75*(1+j)/sqrt(2)]; % complex denominator
umax_inv=1;
phase_off=0;
i=1;
f=1;
ji=1;
gain=1;
Ga=1;
NORMALIZE_COEFFICIENT=1;
APSK=32;


av_power=12:1:15;


[mode_sel, M_gen]=constellation_mode(APSK);
gain_db=[1 1.5 2 6.5 2];%24.5 - m2dbm 25 - m3dbm 25.5 - m4dbm 26 - m6dbm 27 - m10dbm
P0_ar=[1e-2 1e0; 1e0 1e-1; 1 1; 1e5 1e5; 1e5 1e1;];
modcod=[1,12,18,24,30];
psk=[4 8 16 32 64];
offset=0;%%сдвиг характеристики усилителя
%% моделируем усилитель
diff_min=1e3;
difference=1e3;

init_coef=0.333;
% init_coef=1.6667;
% av_power=-10:2:-10;
% av_power=-10:2:-10;
Le=4;
M=Le+1;

