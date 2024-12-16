function [result]...
    = demodSignals(paIn, paOut, ...
    dpdPaOut, symbolRef, param, ...
    dpdData)
%% test signals
symbolRef = symbolRef./max(abs(symbolRef));
paInDemod = demod(paIn, symbolRef, param);
paOutDemod = demod(paOut, symbolRef, param);
dpdDataDemod = demod(dpdData, symbolRef, param);

paInDemod = paInDemod./max(abs(paInDemod));
paOutDemod = paOutDemod./max(abs(paOutDemod));
dpdDataDemod = dpdDataDemod./max(abs(dpdDataDemod));
if param.MatPAModel
    dpdPaOutDemod = demod(dpdPaOut, symbolRef, param);
    dpdPaOutDemod = dpdPaOutDemod./max(abs(dpdPaOutDemod));
end
%% EVM
offset = 10;
if param.MatPAModel
    [result.evm_rmsDpdPa] = evm_measNew...
        (symbolRef(1+offset:end-offset), dpdPaOutDemod(1+offset:end-offset));
else
    result.evm_rmsDpdPa = [];
end
[result.evm_rmsPa] = evm_measNew...
    (symbolRef(1+offset:end-offset), paOutDemod(1+offset:end-offset));
[result.evm_rmsPaIn] = evm_measNew(symbolRef(1+offset:end-offset),...
    paInDemod(1+offset:end-offset));
[result.evm_rmsDPD] = evm_measNew(symbolRef(1+offset:end-offset),...
    dpdDataDemod(1+offset:end-offset));
%% inband power meas
[result.ydbpaInInBand, result.ydbpaInOutBand] =...
    inOutBandPowerMeas(paIn,...
    param.PAModel.sps, param.PAModel.interpFactor);
[result.ydbpaOutInBand, result.ydbpaOutOutBand] =...
    inOutBandPowerMeas(paOut,...
    param.PAModel.sps, param.PAModel.interpFactor);
[result.ydbdpdPaOutInBand, result.ydbdpdPaOutOutBand] =...
    inOutBandPowerMeas(dpdPaOut,...
    param.PAModel.sps, param.PAModel.interpFactor);
%% ACPR meas
result.ACPRpaIn = result.ydbpaInOutBand - result.ydbpaInInBand;
result.ACPRpaOut = result.ydbpaOutOutBand - result.ydbpaOutInBand;
result.ACPRdpdPaOut = result.ydbdpdPaOutOutBand - result.ydbdpdPaOutInBand;
end