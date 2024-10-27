function [mode_sel,M]=constellation_mode(input)
switch input
    case 4
        mode_sel=1;
        M=2;
    case 8
        mode_sel=12;
        M=3;
    case 16
        mode_sel=18;
        M=4;
    case 32
        mode_sel=24;
        M=5;
    case 64
        mode_sel=29;
        M=6;
    otherwise
        mode_sel=24;
        M=5;
end
end