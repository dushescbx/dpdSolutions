function y=complex_num_for_symbol(APSK,mode_sel)
switch APSK
    case 4
        y=modulator_PSK(mode_sel,0);
    case 8
        y=modulator_PSK(mode_sel,0);
    case 16
        y=0.224478343233825 + 0.224478343233825i;
    case 32
        y=0.134175859807694 + 0.134175859807694i;
    case 64
        y=0.184775906502257 + 0.076536686473018i;
    otherwise
        y=modulator_PSK(mode_sel,0);
end

