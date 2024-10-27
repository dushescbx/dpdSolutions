function coef = fit_memory_poly_model(x, y, lengthVector, memorylen, degree)
% Copyright 2013-2014 The MathWorks, Inc.

% From "A generalized memory polynomical model for digital predistortion of
% RF power amplifiers", Morgan, Ma, Kim, Zierdt, and Pastalan, IEEE Trans
% Sig Proc, 54(10)

% Note the memory polynomial in the paper is undefined for the first
% memorylen samples, as n - m < 0 and hence undefined. We simply ignore the first memorylen samples. 
% Note that the input vector x must be at least lengthVector + memorylen
% long.
% x_terms has lengthVector rows and number of columns corresponding to kernels
x_terms = zeros(lengthVector,degree*memorylen);

for n = 1:lengthVector %cycle through training vector   
    for k = 1:degree %cycle through exponents    
        %A=[   a00 a01 a02 ... a0(M-1) , a10 a11 a12 ... a1(M-1 ), ... , a(K-1)0 a(K-1)1 a(K-1)(M-1))   ]
        x_terms(n,(k - 1)*memorylen+(1:memorylen)) = (x(n:(n + memorylen-1)).*(abs(x(n:(n + memorylen -1))).^(k - 1))).';    
    end
end
%Use MATLAB \ operator to generate least squares solution to overdetermined
%problem
coef = x_terms\y(memorylen-1+(1:lengthVector));

