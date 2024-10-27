function [angle_diff_v_lob] = phase_offset(ref,sig) %%angle_diff_conj,

ref = ref(1:length(sig));
% angle_diff_conj = mean(angle(ref.*conj(sig)))*180/pi;
angle_dif = (angle(ref) - angle(sig))*180/pi;
angle_dif(angle_dif < 0) = 360 + angle_dif(angle_dif < 0);
angle_diff_v_lob = mean(angle_dif);

end