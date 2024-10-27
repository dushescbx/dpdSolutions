function APSK_out=psk_or_apsk(apsk_in)
switch apsk_in
    case 2
        APSK_out="PSK";
    case 4
        APSK_out="PSK";
    case 8
        APSK_out="PSK";
    case 16
        APSK_out="APSK";
    case 32
        APSK_out="APSK";
end
end
