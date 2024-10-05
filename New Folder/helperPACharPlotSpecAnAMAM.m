function helperPACharPlotSpecAnAMAM(referencePower, measuredAMToAM)
%helperPACharPlotSpecAnAMAM Plot SpecAn AM/AM transfer function
%   helperPACharPlotSpecAnAMAM(REFP,AMAM) plots the AM/AM measurements,
%   AMAM, as a function of reference power, REFP.
%
%   See also PowerAmplifierCharacterizationExample.

%   Copyright 2020 The MathWorks, Inc.

plot(referencePower, referencePower + measuredAMToAM, '.')
grid on
xlabel('Input Power (dBm)')
ylabel('Output Power (dBm)')
title('AM/AM')
