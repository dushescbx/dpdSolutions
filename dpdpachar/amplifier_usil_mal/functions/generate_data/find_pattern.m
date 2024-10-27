function pattern_out=find_pattern(apsk_in)
switch apsk_in
    case "2apsk"
        pattern_out="'pattern_2_apsk'";
    case "4apsk"
        pattern_out="'pattern_4_apsk'";
    case "8apsk"
        pattern_out="'pattern_8_apsk'";
    case "16apsk"
        pattern_out="'pattern_16_apsk'";
    case "32apsk"
        pattern_out="'pattern_32_apsk'";
end
end
