function [modOut_rrc_interp,...
    modOut_rrc_interpFiltered, ...
    param] = ...
    QAM_mod(amplifier, ...
    gain, M, pindBm, DataLen,...
    param, PAModel, fig_en)


refConst = qammod([0:M-1],M);
axisLimits = [-gain gain];
constdiag = comm.ConstellationDiagram("NumInputPorts",2, ...
    "ChannelNames",["Linear" "Nonlinear"],"ShowLegend",true, ...
    "ReferenceConstellation",refConst, ...
    "XLimits",axisLimits,"YLimits",axisLimits);

pin = 10.^((pindBm-30)/10); % dBm2Watts
% data = randi([0 M-1],1e3,1);
N = param.PAModel.DataLen...
    /param.PAModel.sps/param.PAModel.interpFactor;
data = randi([0 M-1],...
    ceil(N-param.Nsync), 1);
% data = [zeros(param.Nsync, 1); data]; param.syncData
data = [param.syncData; data]; 
modOut = qammod(data,M,"UnitAveragePower",true)...
    *sqrt(pin*amplifier.ReferenceImpedance*...
    param.PAModel.sps);
[modOut_rrc, param.PAModel] = tx_rrc_filter(param.PAModel,...
    modOut);
modOut_rrc_interp = ...
    spline(1:length(modOut_rrc),...
    modOut_rrc, 1:1/param.PAModel.interpFactor:...
    length(modOut_rrc));
% modOut_rrc_interp = ...
%     modOut_rrc_interp(1:DataLen);
% pa filter
if PAModel == 1
       modOut_rrc_interpFiltered = filter(param.PAModel.Filter.num, ...
        param.PAModel.Filter.den, ...
        modOut_rrc_interp);
       PAInputSignal_powFiltered = mean(abs(modOut_rrc_interpFiltered).^2);
    PAInputSignalFiltered_norm = 1/sqrt(PAInputSignal_powFiltered) * modOut_rrc_interpFiltered;
    pin = 10.^((pindBm-30)/10); % dBm2Watts
    modOut_rrc_interpFiltered = PAInputSignalFiltered_norm*sqrt(pin*amplifier.ReferenceImpedance);
else
    modOut_rrc_interpFiltered = [];
end

Pow = 10*log10(mean(abs(modOut_rrc_interp).^2 ...
    /amplifier.ReferenceImpedance))+30;
if fig_en
    %     figure;
    %     plot((modOut_rrc_interp));
    figure;
    plot(real(modOut_rrc_interp));
    hold on
    plot(imag(modOut_rrc_interp));
    xlabel('samples (n)')
    ylabel('Mag (V)')
    title('modOut rrc interp');
    figure;
    %     plot((modOut_rrc));
    hold on;
    plot((modOut_rrc_interp), '.');
    title('modOut rrc interp');
    % % %     figure;
    % % %     plot(1:length(modOut_rrc), real(modOut_rrc));
    % % %     hold on
    % % %     plot(1:1/param.PAModel.interpFactor:length(modOut_rrc),...
    % % %         real(modOut_rrc_interp));
    % % %     plot(1:length(modOut_rrc), imag(modOut_rrc));
    % % %     plot(1:1/param.PAModel.interpFactor:length(modOut_rrc),...
    % % %         imag(modOut_rrc_interp));
end
end