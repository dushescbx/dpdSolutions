function [results, param] = PAInOutData(dataFileName, MatPAModel, param, fig_en)
if MatPAModel
    [results, param] = PAMatModel(param, fig_en);
else
    [results ] =...
        PAMeasLoad('dpdLab/meas/x.mat', 'dpdLab/meas/yCorr_pindBm=-10.mat', param);
end