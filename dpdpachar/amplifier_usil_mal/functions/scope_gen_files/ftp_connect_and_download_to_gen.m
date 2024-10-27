%% тсмйжхъ оепедювх дюммшу мю цемепюрнп
function ftp_connect_and_download_to_gen(APSK, ref, av_power, direct, const, ftpobj_gen)
%% гюдюел оюпнкэ х кнцхм
username='instrument';
password='instrument';
%% ондйкчвюеляъ й цемепюрнпс
ftpobj_gen=ftp('10.105.31.119',username,password);
% dir(ftpobj)
%% оепеундхл б оюойс USER
cd(ftpobj_gen,'user');
%% янгдюел оюойс ref_waveforms
mkdir(ftpobj_gen,'ref_waveforms')
%% оепеундхл б оюойс ref_waveforms
cd(ftpobj_gen,'ref_waveforms');
%% гюцпсфюел тюик б цемепюрнп
for i=APSK
    if ref==1
        mput(ftpobj_gen,[direct 'amplifier_usil_mal\_' num2str(i) ...
            'APSK_ref_symb_after_filter_for_conv_wv.wv']);
        mput(ftpobj_gen,[direct 'amplifier_usil_mal\_' num2str(i) ...
            'APSK_ref_symb_before_transm_filter.wv']);
    else
        mput(ftpobj_gen,[direct 'amplifier_usil_mal\_'...
            num2str(i) 'APSK_sym_after_dpd_av_pow=' num2str(av_power) '.wv']);    
    end
    %     mput(ftpobj,['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier_usil_mal\_'...
    %         num2str(i) 'APSK_ref_symb_after_filter.wv']);
    %     for ka=0:1:3
    %          mput(ftpobj,['C:\Users\Konstantinov_PA\Desktop\amplifier\amplifier_usil_mal\_'...
    %              num2str(i) 'APSK_ref_symb_ka=' num2str(ka) '.wv']);
    %     end
end


