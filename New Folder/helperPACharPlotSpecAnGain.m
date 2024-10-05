function helperPACharPlotSpecAnGain(referencePower, measuredAMToAM)
%helperPACharPlotSpecAnGain Plot SpecAn AM/AM gain
%   helperPACharPlotSpecAnGain(REFP,AMAM) plots the gain based on the AM/AM
%   measurements, AMAM as a function of reference power, REFP.
%
%   See also PowerAmplifierCharacterizationExample.

%   Copyright 2020 The MathWorks, Inc.

plot(referencePower, measuredAMToAM, '.')
grid on
xlabel('Input Power (dBm)')
ylabel('Gain (dB)')
title('Gain vs Input Power')

