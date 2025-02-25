function [results, param] = PAMatModel(param, fig_en)


%% PA apporx model
switch param.MatPAModelSel
    case 0 % Cubic poly
        amplifier = comm.MemorylessNonlinearity("Method","Cubic polynomial", ...
            "LinearGain",param.PAModel.Cubic.gain,"AMPMConversion",...
            param.PAModel.Cubic.AMPMConversion,...
            "ReferenceImpedance",param.PAModel.RefImp);
    case 1 % Memory model (Wiener)
        amplifier = comm.MemorylessNonlinearity("Method","Saleh model", ...
            "InputScaling", param.PAModel.Saleh.InputScaling,...
            "AMAMParameters", param.PAModel.Saleh.AMAMParameters,...
            "AMPMParameters", param.PAModel.Saleh.AMPMParameters,...
            "OutputScaling", param.PAModel.Saleh.OutputScaling,...
            "ReferenceImpedance",param.PAModel.RefImp);
end
%% PA input signal
[modOut_interp,...
    PAInputSignalFiltered, ...
    param] = ...
    PAInputSignalSel(amplifier, ...
    param.PAModel.Cubic.gain, param.PAModel.M, ...
    param.PAModel.pindBm, param.PAModel.DataLen,...
    param, param.MatPAModelSel, fig_en);
%% amplify signal
modOut_interp = reshape(modOut_interp, [], 1);
if param.MatPAModelSel == 1
    PAInputSignalFiltered = reshape(PAInputSignalFiltered, [], 1);
    ampOut = amplifier(PAInputSignalFiltered);
else
    ampOut = amplifier(modOut_interp);
end
if fig_en
    plot(amplifier);
    figure; plot(ampOut, '.');
end
%% add noise
noisyLinOut = awgn(ampOut(:,1), param.PAModel.snr,"measured");

figure; spectrumPlot(1, noisyLinOut, 1);
figure; spectrumPlot(1, ampOut(:,1), 1);
% noisyNonLinOut = awgn(ampOut(:,2),param.PAModel.snr,"measured");
% constdiag(noisyLinOut,noisyNonLinOut);
%% results
[results, param] = resultsGen(param, modOut_interp, noisyLinOut);
%%
param.amplifier = amplifier;
