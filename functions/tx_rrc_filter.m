function [s_out, param] = tx_rrc_filter(param, s_in)
% Design raised cosine filter with given order in symbols
param.rctFilt3 = comm.RaisedCosineTransmitFilter(...
    'Shape',                  'Square root', ...
    'RolloffFactor',          param.beta, ...
    'FilterSpanInSymbols',    param.Nsym, ...
    'OutputSamplesPerSymbol', param.sps);
% Upsample and filter.
% % % % bNorm = coeffs(param.rctFilt3);
% % % % bSum = bNorm.Numerator./max(bNorm.Numerator);
% % % fvtool(bSum)
% % % % bSum = bNorm.Numerator./sum(bNorm.Numerator);
% % % fvtool(bSum)
% % % % youtR = upfirdn([real(s_in); ...
% % % %     zeros(param.Nsym/2, 1)], bSum, param.sps);
% % % % youtI = upfirdn([imag(s_in); ...
% % % %     zeros(param.Nsym/2, 1)], bSum, param.sps);
% % % % s_out = complex(youtR, youtI);
% % % % s_out = s_out(param.sps*param.Nsym/2+1:end - param.sps*param.Nsym + param.sps - 1);
yc_r = param.rctFilt3([real(s_in); zeros(param.Nsym/2, 1)]);
yc_i = param.rctFilt3([imag(s_in); zeros(param.Nsym/2, 1)]);
s_out = complex(yc_r, yc_i);
% Correct for propagation delay by removing filter transients
s_out = s_out(param.sps*param.Nsym/2+1:end);

if param.sps == 1
    s_out = s_in;
end
% %
% % figure;
% % plot(real(s_outTest))
% % hold on
% % plot(real(s_out))