function [results, param] = PAInOutData(dataFileName, MatPAModel, param, fig_en)
if MatPAModel
    [results, param] = PAMatModel(param, fig_en);
else
    [results, param.overSamplingRate ] = PAMeasLoad(dataFileName);
end