function inOutTable = NaNReplace(Input, argType, figEn)
NaNInds = isnan(Input);
if argType == "Phase"
    inOutTable = Input;
    inOutTable(NaNInds) = 0;
else
    [nan_ind, nan_val] = max(find(NaNInds));
    L = length(Input);
    if argType == "OutputPower"
        dinP = mean(diff(Input(nan_ind+1:floor(0.8*L))));
    else
        dinP = mean(diff(Input(nan_ind+1:floor(0.8*L))));
    end
    y1 = Input(floor(L/2)) - dinP*floor(L/2);
    N = 0:L-1;
    inPint = y1 + dinP*N;
    inOutTable = Input;
    inOutTable(NaNInds) = inPint(NaNInds);
end
if argType == "InputPower"
    for i = 1 : nan_ind + 1
        if inOutTable(i) > inOutTable(i+1)
            inOutTable(i) = inOutTable(i+1) - dinP/2;
        end
    end
end
if  figEn
    %     figure;
    %     plot(diff(Input(nan_ind+1:end)));
    %     figure;
    %     plot(diff(diff(Input(nan_ind+1:end))));
    figure;
    plot(Input);
    hold on;
    if argType ~= "Phase"
        plot(inPint);
    end
    plot(inOutTable);
    title('NaNReplace');
    legend('orig', 'nan replaced');
end

end