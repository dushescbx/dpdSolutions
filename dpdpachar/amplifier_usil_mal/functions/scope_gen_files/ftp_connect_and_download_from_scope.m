function ftp_connect_and_download_from_scope(APSK,inp,dpd_on_off,power)
% ftpobj=ftp('10.105.31.74');
load(['\\FSW26-104146\Temp\_' num2str(APSK) 'APSK' num2str(power) 'dbm_DPD_on=' num2str(dpd_on_off) '_pa_on=' num2str(inp) '.dat']);
load(['\\FSW26-104146\Temp\_' num2str(APSK) 'APSK' num2str(power) 'dbm_DPD_on=' num2str(dpd_on_off) '_pa_on=' num2str(inp) '.jpeg']);
end