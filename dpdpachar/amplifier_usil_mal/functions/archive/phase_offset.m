function [angle_diff_conj] = phase_offset(ref,sig) %%angle_diff_conj,
min_len = min([length(sig) length(ref)]);
ref = ref(1:min_len);
sig = sig(1:min_len);
angle_diff_conj = mean(angle(ref.*conj(sig)))*180/pi;
% angle_dif = (angle(ref) - angle(sig))*180/pi;
% % angle_dif(angle_dif < 0) = 360 + angle_dif(angle_dif < 0);
% angle_dif(angle_dif < -180) = 360 + angle_dif(angle_dif < -180);
% angle_dif(angle_dif > 180) = -360 + angle_dif(angle_dif > 180);
% angle_diff_v_lob = mean(abs(angle_dif));

end