%% test signal params
param.f1 = 1.8e6;
param.f2 = 2.6e6;
param.sN = 1e6;
param.SR = 100e6;
%% saved data file
switch param.MatPARealSigSel
    case 0
        param.PAModel.bw = 3e6;
        param.dataFileName = 'PACharSavedDataTones';
    case 1
        param.PAModel.bw = 15e6;
        param.dataFileName = 'PACharSavedData15MHz';
    case 2
        param.PAModel.bw = 40e6;
        param.dataFileName = 'PACharSavedData40MHz';
    case 3
        param.PAModel.bw = 100e6;
        param.dataFileName = 'PACharSavedData100MHz';
end