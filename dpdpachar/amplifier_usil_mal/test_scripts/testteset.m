% APSK=[4 8 16 32 64];
% ftpobj=ftp('10.105.31.74');
% dir(ftpobj)
% cd(ftpobj,'user');
% mkdir(ftpobj,'ref_waveforms')
% cd(ftpobj,'ref_waveforms');
% for i=APSK
%     mput(ftpobj,['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier_usil_mal\_' num2str(i) 'APSK_ref_symb.wv']);
% end
% save('\\FSW26-104146\Temp\test.mat','APSK');
load('\\FSW26-104146\Temp\test.dat');