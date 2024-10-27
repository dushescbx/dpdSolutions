%% тсмйжхъ оепедювх дюммшу мю цемепюрнп
function ftp_connect_and_download_to_gen_bpsk_symb(directory)
%% гюдюел оюпнкэ х кнцхм
username='instrument';
password='instrument';
%% ондйкчвюеляъ й цемепюрнпс
ftpobj=ftp('10.105.31.119',username,password);
% dir(ftpobj)
%% оепеундхл б оюойс USER
cd(ftpobj,'user');
%% янгдюел оюойс ref_waveforms
mkdir(ftpobj,'ref_waveforms')
%% оепеундхл б оюойс ref_waveforms
cd(ftpobj,'ref_waveforms');
%% гюцпсфюел тюик б цемепюрнп
mput(ftpobj,[directory '\amplifier_usil_mal\_BPSK_ref_symb_after_filter_for_conv_wv.wv']);
mput(ftpobj,[directory '\amplifier_usil_mal\_BPSK_ref_symb_before_transm_filter.wv']);

