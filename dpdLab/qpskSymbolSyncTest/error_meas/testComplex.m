N = 1e4;
a = exp(1i*2*pi*rand(1, N));
figure; plot(a, '*');
b = (a.').*a';