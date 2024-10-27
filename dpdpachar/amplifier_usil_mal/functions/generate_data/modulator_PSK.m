function [frame_symbol]=modulator_PSK(actual_frame_modcod,frame_data)
%	вычисляем коэффициенты гамма в зависимости от текущего режима
if	actual_frame_modcod >=18 && actual_frame_modcod <= 23                        %16ФМ
    if actual_frame_modcod == 18		%при кодовой скорости 2/3
        gamma1 = 3.15;
        gamma2 = 0;
        gamma3 = 0;
    elseif actual_frame_modcod == 19	%при кодовой скорости 3/4
        gamma1 = 2.85;
        gamma2 = 0;
        gamma3 = 0;
    elseif actual_frame_modcod == 20	%при кодовой скорости 4/5
        gamma1 = 2.75;
        gamma2 = 0;
        gamma3 = 0;
    elseif actual_frame_modcod == 21	%при кодовой скорости 5/6
        gamma1 = 2.70;
        gamma2 = 0;
        gamma3 = 0;
    elseif actual_frame_modcod == 22	%при кодовой скорости 8/9
        gamma1 = 2.60;
        gamma2 = 0;
        gamma3 = 0;
    elseif actual_frame_modcod == 23	%при кодовой скорости 9/10
        gamma1 = 2.57;
        gamma2 = 0;
        gamma3 = 0;
    else								%аварийная ситация, обнуляем
        gamma1 = 0;
        gamma2 = 0;
        gamma3 = 0;
    end
    bit_per_symbol(actual_frame_modcod+1) = 4;
elseif	actual_frame_modcod >=24 && actual_frame_modcod <= 28                 %32ФМ
    if actual_frame_modcod == 24		%при кодовой скорости 3/4
        gamma1 = 2.84;
        gamma2 = 5.27;
        gamma3 = 0;
    elseif actual_frame_modcod == 25	%при кодовой скорости 4/5
        gamma1 = 2.72;
        gamma2 = 4.87;
        gamma3 = 0;
    elseif actual_frame_modcod == 26	%при кодовой скорости 5/6
        gamma1 = 2.64;
        gamma2 = 4.64;
        gamma3 = 0;
    elseif actual_frame_modcod == 27	%при кодовой скорости 8/9
        gamma1 = 2.54;
        gamma2 = 4.33;
        gamma3 = 0;
    elseif actual_frame_modcod == 28	%при кодовой скорости 9/10
        gamma1 = 2.53;
        gamma2 = 4.3;
        gamma3 = 0;
    else								%аварийная ситация, обнуляем
        gamma1 = 0;
        gamma2 = 0;
        gamma3 = 0;
    end
    bit_per_symbol(actual_frame_modcod+1) = 5;
elseif	(actual_frame_modcod >=29 && actual_frame_modcod <= 31) || actual_frame_modcod == 0       %64ФМ
    if actual_frame_modcod == 29		%при кодовой скорости 4/5
        gamma1 = 2.2;
        gamma2 = 3.6;
        gamma3 = 5.2;
    elseif actual_frame_modcod == 30	%при кодовой скорости 5/6
        gamma1 = 2.2;
        gamma2 = 3.5;
        gamma3 = 5;
    elseif actual_frame_modcod == 31	%при кодовой скорости 8/9
        gamma1 = 2.2;
        gamma2 = 3.5;
        gamma3 = 5;
    elseif actual_frame_modcod == 0 	%при кодовой скорости 9/10
        gamma1 = 2.2;
        gamma2 = 3.4;
        gamma3 = 4.8;
    else								%аварийная ситация, обнуляем
        gamma1 = 0;
        gamma2 = 0;
        gamma3 = 0;
    end
    bit_per_symbol(actual_frame_modcod+1) = 6;
elseif (actual_frame_modcod >=12 && actual_frame_modcod <= 17)								%для остальных 8ФМ гаммы не нужны
    gamma1 = 0;
    gamma2 = 0;
    gamma3 = 0;
    bit_per_symbol(actual_frame_modcod+1) = 3;
else
    gamma1 = 0;
    gamma2 = 0;
    gamma3 = 0;
    bit_per_symbol(actual_frame_modcod+1) = 2;
end

% на основе коэффицентов гамма и текущего режима вычисляем радиусы
if actual_frame_modcod >=1 && actual_frame_modcod <= 11										%4ФМ
    R1 = 1;
    R2 = 0;
    R3 = 0;
    R4 = 0;
elseif	actual_frame_modcod >=12 && actual_frame_modcod <= 17								%8ФМ
    R1 = 1;
    R2 = 0;
    R3 = 0;
    R4 = 0;
elseif	actual_frame_modcod >=18 && actual_frame_modcod <= 23								%16ФМ
    R1 = 2*sqrt(1/((3*gamma1^2)+1));
    R2 = 2*gamma1*sqrt(1/((3*gamma1^2)+1));
    R3 = 0;
    R4 = 0;
elseif	actual_frame_modcod >=24 && actual_frame_modcod <= 28								%32ФМ
    R1 = 2*sqrt(2)*sqrt(1/((3*gamma1^2)+(4*gamma2^2)+1));
    R2 = 2*sqrt(2)*gamma1*sqrt(1/((3*gamma1^2)+(4*gamma2^2)+1));
    R3 = 2*sqrt(2)*gamma2*sqrt(1/((3*gamma1^2)+(4*gamma2^2)+1));
    R4 = 0;
elseif	(actual_frame_modcod >=29 && actual_frame_modcod <= 31) || actual_frame_modcod == 0	%64ФМ
    R1 = 4*sqrt(1/((4*gamma1^2)+(5*gamma2^2)+(5*gamma3^2)+2));
    R2 = 4*gamma1*sqrt(1/((4*gamma1^2)+(5*gamma2^2)+(5*gamma3^2)+2));
    R3 = 4*gamma2*sqrt(1/((4*gamma1^2)+(5*gamma2^2)+(5*gamma3^2)+2));
    R4 = 4*gamma3*sqrt(1/((4*gamma1^2)+(5*gamma2^2)+(5*gamma3^2)+2));
else																			%аварийная ситуация
    R1 = 0;
    R2 = 0;
    R3 = 0;
    R4 = 0;
end

%     нормировка радиусов в соответсвии с разрядностью шины (16 разрядов, 1
%     знаковый, остальные - дробная часть
% if actual_frame_modcod >=1 && actual_frame_modcod <= 11										%4ФМ
%     R1 = R1/R1*NORMALIZE_COEFFICIENT;
% elseif	actual_frame_modcod >=12 && actual_frame_modcod <= 17								%8ФМ
%     R1 = R1/R1*NORMALIZE_COEFFICIENT;
% elseif	actual_frame_modcod >=18 && actual_frame_modcod <= 23								%16ФМ
%     R1 = R1/R2*NORMALIZE_COEFFICIENT;
%     R2 = R2/R2*NORMALIZE_COEFFICIENT;
% elseif	actual_frame_modcod >=24 && actual_frame_modcod <= 28								%32ФМ
%     R1 = R1/R3*NORMALIZE_COEFFICIENT;
%     R2 = R2/R3*NORMALIZE_COEFFICIENT;
%     R3 = R3/R3*NORMALIZE_COEFFICIENT;
% elseif	(actual_frame_modcod >=29 && actual_frame_modcod <= 31) || actual_frame_modcod == 0	%64ФМ
%     R1 = R1/R4*NORMALIZE_COEFFICIENT;
%     R2 = R2/R4*NORMALIZE_COEFFICIENT;
%     R3 = R3/R4*NORMALIZE_COEFFICIENT;
%     R4 = R4/R4*NORMALIZE_COEFFICIENT;
% else																			%аварийная ситуация
%     R1 = 0;
%     R2 = 0;
%     R3 = 0;
%     R4 = 0;
% end



% В зависимости от текущего МОДКОДа, конвертируем битовое слово в комплексный символ
if actual_frame_modcod >=1 && actual_frame_modcod <= 11									%4ФМ
    switch bitand(frame_data,bin2dec('11'))
        case bin2dec('00')
            frame_symbol = R1*exp(1i*pi/4);
        case bin2dec('01')
            frame_symbol =  R1*exp(1i*7*pi/4);
        case bin2dec('10')
            frame_symbol =  R1*exp(1i*3*pi/4);
        case bin2dec('11')
            frame_symbol =  R1*exp(1i*5*pi/4);
        otherwise
            frame_symbol = 0;
    end
elseif	actual_frame_modcod >=12 && actual_frame_modcod <= 17								%8ФМ
    switch bitand(frame_data,bin2dec('111'))
        
        case bin2dec('000')
            frame_symbol =	R1*exp(1i*pi/4);
        case bin2dec('001')
            frame_symbol =	R1*exp(1i*0);
        case bin2dec('010')
            frame_symbol =	R1*exp(1i*pi);
        case bin2dec('011')
            frame_symbol =  R1*exp(1i*5*pi/4);
        case bin2dec('100')
            frame_symbol =	R1*exp(1i*pi/2);
        case bin2dec('101')
            frame_symbol =	R1*exp(1i*7*pi/4);
        case bin2dec('110')
            frame_symbol =	R1*exp(1i*3*pi/4);
        case bin2dec('111')
            frame_symbol =	R1*exp(1i*3*pi/2);
        otherwise
            frame_symbol =	0;
    end
elseif	actual_frame_modcod >=18 && actual_frame_modcod <= 23								%16ФМ
    switch bitand(frame_data,bin2dec('1111'))
        case bin2dec('0000')
            frame_symbol =  R2*exp(1i*3*pi/12);
        case bin2dec('0001')
            frame_symbol = R2*exp(1i*7*pi/4);
        case bin2dec('0010')
            frame_symbol =  R2*exp(1i*9*pi/12);
        case bin2dec('0011')
            frame_symbol =  R2*exp(1i*15*pi/12);
        case bin2dec('0100')
            frame_symbol =  R2*exp(1i*pi/12);
        case bin2dec('0101')
            frame_symbol =  R2*exp(1i*23*pi/12);
        case bin2dec('0110')
            frame_symbol =  R2*exp(1i*11*pi/12);
        case bin2dec('0111')
            frame_symbol =  R2*exp(1i*13*pi/12);
        case bin2dec('1000')
            frame_symbol =  R2*exp(1i*5*pi/12);
        case bin2dec('1001')
            frame_symbol =  R2*exp(1i*19*pi/12);
        case bin2dec('1010')
            frame_symbol =  R2*exp(1i*7*pi/12);
        case bin2dec('1011')
            frame_symbol =  R2*exp(1i*17*pi/12);
        case bin2dec('1100')
            frame_symbol =  R1*exp(1i*pi/4);
        case bin2dec('1101')
            frame_symbol =  R1*exp(1i*7*pi/4);
        case bin2dec('1110')
            frame_symbol =  R1*exp(1i*3*pi/4);
        case bin2dec('1111')
            frame_symbol =	R1*exp(1i*5*pi/4);
        otherwise
            frame_symbol =	0;
    end
elseif	actual_frame_modcod >=24 && actual_frame_modcod <= 28								%32ФМ
    switch bitand(frame_data,bin2dec('11111'))
        case bin2dec('00000')
            frame_symbol =  R2*exp(1i*pi/4);
        case bin2dec('00001')
            frame_symbol =	R2*exp(1i*5*pi/12);
        case bin2dec('00010')
            frame_symbol =  R2*exp(1i*7*pi/4);
        case bin2dec('00011')
            frame_symbol =  R2*exp(1i*19*pi/12);
        case bin2dec('00100')
            frame_symbol =  R2*exp(1i*3*pi/4);
        case bin2dec('00101')
            frame_symbol =  R2*exp(1i*7*pi/12);
        case bin2dec('00110')
            frame_symbol =  R2*exp(1i*5*pi/4);
        case bin2dec('00111')
            frame_symbol =  R2*exp(1i*17*pi/12);
        case bin2dec('01000')
            frame_symbol =  R3*exp(1i*pi/8);
        case bin2dec('01001')
            frame_symbol =  R3*exp(1i*3*pi/8);
        case bin2dec('01010')
            frame_symbol =  R3*exp(1i*14*pi/8);
        case bin2dec('01011')
            frame_symbol =  R3*exp(1i*12*pi/8);
        case bin2dec('01100')
            frame_symbol =  R3*exp(1i*6*pi/8);
        case bin2dec('01101')
            frame_symbol =  R3*exp(1i*4*pi/8);
        case bin2dec('01110')
            frame_symbol =  R3*exp(1i*9*pi/8);
        case bin2dec('01111')
            frame_symbol =	R3*exp(1i*11*pi/8);
        case bin2dec('10000')
            frame_symbol =  R2*exp(1i*pi/12);
        case bin2dec('10001')
            frame_symbol =	R1*exp(1i*pi/4);
        case bin2dec('10010')
            frame_symbol =  R2*exp(1i*23*pi/12);
        case bin2dec('10011')
            frame_symbol =  R1*exp(1i*7*pi/4);
        case bin2dec('10100')
            frame_symbol =  R2*exp(1i*11*pi/12);
        case bin2dec('10101')
            frame_symbol =  R1*exp(1i*3*pi/4);
        case bin2dec('10110')
            frame_symbol =  R2*exp(1i*13*pi/12);
        case bin2dec('10111')
            frame_symbol =  R1*exp(1i*5*pi/4);
        case bin2dec('11000')
            frame_symbol =  R3*exp(1i*0);
        case bin2dec('11001')
            frame_symbol =  R3*exp(1i*2*pi/8);
        case bin2dec('11010')
            frame_symbol =  R3*exp(1i*15*pi/8);
        case bin2dec('11011')
            frame_symbol =	R3*exp(1i*13*pi/8);
        case bin2dec('11100')
            frame_symbol =  R3*exp(1i*7*pi/8);
        case bin2dec('11101')
            frame_symbol =	R3*exp(1i*5*pi/8) ;
        case bin2dec('11110')
            frame_symbol =  R3*exp(1i*8*pi/8);
        case bin2dec('11111')
            frame_symbol =	R3*exp(1i*10*pi/8);
        otherwise
            frame_symbol =	0;
    end
elseif	(actual_frame_modcod >=29 && actual_frame_modcod <= 31) || actual_frame_modcod == 0      %64ФМ
    switch bitand(frame_data,bin2dec('111111'))
        case bin2dec('000000')
            frame_symbol =  R2*exp(1i*25*pi/16);
        case bin2dec('000001')
            frame_symbol =  R4*exp(1i*35*pi/20);
        case bin2dec('000010')
            frame_symbol =  R2*exp(1i*27*pi/16);
        case bin2dec('000011')
            frame_symbol =  R3*exp(1i*35*pi/20);
        case bin2dec('000100')
            frame_symbol =  R4*exp(1i*31*pi/20);
        case bin2dec('000101')
            frame_symbol =  R4*exp(1i*33*pi/20);
        case bin2dec('000110')
            frame_symbol =  R3*exp(1i*31*pi/20);
        case bin2dec('000111')
            frame_symbol =  R3*exp(1i*33*pi/20);
        case bin2dec('001000')
            frame_symbol =  R2*exp(1i*23*pi/16);
        case bin2dec('001001')
            frame_symbol =  R4*exp(1i*25*pi/20);
        case bin2dec('001010')
            frame_symbol =  R2*exp(1i*21*pi/16);
        case bin2dec('001011')
            frame_symbol =  R3*exp(1i*25*pi/20);
        case bin2dec('001100')
            frame_symbol =  R4*exp(1i*29*pi/20);
        case bin2dec('001101')
            frame_symbol =  R4*exp(1i*27*pi/20);
        case bin2dec('001110')
            frame_symbol =  R3*exp(1i*29*pi/20);
        case bin2dec('001111')
            frame_symbol =  R3*exp(1i*27*pi/20);
        case bin2dec('010000')
            frame_symbol =  R1*exp(1i*13*pi/8);
        case bin2dec('010001')
            frame_symbol =  R4*exp(1i*37*pi/20);
        case bin2dec('010010')
            frame_symbol =  R2*exp(1i*29*pi/16);
        case bin2dec('010011')
            frame_symbol =  R3*exp(1i*37*pi/20);
        case bin2dec('010100')
            frame_symbol =  R1*exp(1i*15*pi/8);
        case bin2dec('010101')
            frame_symbol =  R4*exp(1i*39*pi/20);
        case bin2dec('010110')
            frame_symbol =  R2*exp(1i*31*pi/16);
        case bin2dec('010111')
            frame_symbol =  R3*exp(1i*39*pi/20);
        case bin2dec('011000')
            frame_symbol =  R1*exp(1i*11*pi/8);
        case bin2dec('011001')
            frame_symbol =  R4*exp(1i*23*pi/20);
        case bin2dec('011010')
            frame_symbol =  R2*exp(1i*19*pi/16);
        case bin2dec('011011')
            frame_symbol =  R3*exp(1i*23*pi/20);
        case bin2dec('011100')
            frame_symbol =  R1*exp(1i*9*pi/8);
        case bin2dec('011101')
            frame_symbol =  R4*exp(1i*21*pi/20);
        case bin2dec('011110')
            frame_symbol =  R2*exp(1i*17*pi/16);
        case bin2dec('011111')
            frame_symbol =  R3*exp(1i*21*pi/20);
        case bin2dec('100000')
            frame_symbol =  R2*exp(1i*7*pi/16);
        case bin2dec('100001')
            frame_symbol =  R4*exp(1i*5*pi/20);
        case bin2dec('100010')
            frame_symbol =  R2*exp(1i*5*pi/16);
        case bin2dec('100011')
            frame_symbol =  R3*exp(1i*5*pi/20);
        case bin2dec('100100')
            frame_symbol =  R4*exp(1i*9*pi/20);
        case bin2dec('100101')
            frame_symbol =  R4*exp(1i*7*pi/20);
        case bin2dec('100110')
            frame_symbol =  R3*exp(1i*9*pi/20);
        case bin2dec('100111')
            frame_symbol =  R3*exp(1i*7*pi/20);
        case bin2dec('101000')
            frame_symbol =  R2*exp(1i*9*pi/16);
        case bin2dec('101001')
            frame_symbol =  R4*exp(1i*15*pi/20);
        case bin2dec('101010')
            frame_symbol =  R2*exp(1i*11*pi/16);
        case bin2dec('101011')
            frame_symbol =  R3*exp(1i*15*pi/20);
        case bin2dec('101100')
            frame_symbol =  R4*exp(1i*11*pi/20);
        case bin2dec('101101')
            frame_symbol =	R4*exp(1i*13*pi/20);
        case bin2dec('101110')
            frame_symbol =  R3*exp(1i*11*pi/20);
        case bin2dec('101111')
            frame_symbol =  R3*exp(1i*13*pi/20);
        case bin2dec('110000')
            frame_symbol =  R1*exp(1i*3*pi/8);
        case bin2dec('110001')
            frame_symbol =  R4*exp(1i*3*pi/20);
        case bin2dec('110010')
            frame_symbol =  R2*exp(1i*3*pi/16);
        case bin2dec('110011')
            frame_symbol =  R3*exp(1i*3*pi/20);
        case bin2dec('110100')
            frame_symbol =	R1*exp(1i*pi/8);
        case bin2dec('110101')
            frame_symbol =  R4*exp(1i*pi/20);
        case bin2dec('110110')
            frame_symbol =  R2*exp(1i*pi/16);
        case bin2dec('110111')
            frame_symbol =  R3*exp(1i*pi/20);
        case bin2dec('111000')
            frame_symbol =  R1*exp(1i*5*pi/8);
        case bin2dec('111001')
            frame_symbol =  R4*exp(1i*17*pi/20);
        case bin2dec('111010')
            frame_symbol =  R2*exp(1i*13*pi/16);
        case bin2dec('111011')
            frame_symbol =  R3*exp(1i*17*pi/20);
        case bin2dec('111100')
            frame_symbol =  R1*exp(1i*7*pi/8);
        case bin2dec('111101')
            frame_symbol =  R4*exp(1i*19*pi/20);
        case bin2dec('111110')
            frame_symbol =  R2*exp(1i*15*pi/16);
        case bin2dec('111111')
            frame_symbol =  R3*exp(1i*19*pi/20);
        otherwise
            frame_symbol =	0;
    end
else
    frame_symbol =	0;
end
end
