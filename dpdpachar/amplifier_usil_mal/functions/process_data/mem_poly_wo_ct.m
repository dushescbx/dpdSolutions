function x = mem_poly_wo_ct(coef,M,K,in_data)
in_data = in_data(:).';
x = zeros(1,length(in_data));
in_data = [ zeros(1,M) in_data ];

for i = 1 : length(in_data) - M
%     i
    u = in_data(i : i + M);
    %% memory polynomial w/o cross terms
    for m = 0 : M - 1
        for k = 0 : K - 1
            x(i) = x(i) + coef(m + 1, k + 1) * u(M - m) * abs(u(M - m)).^k;
%             x(i) = x(i) + coef(M - m, K - k) * u(M - m) * abs(u(M - m))^k;
        end
    end
end
end