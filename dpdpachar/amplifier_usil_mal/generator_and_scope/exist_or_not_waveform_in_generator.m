% const = constant_for_scope_and_generator();
function exist_or_not_waveform_in_generator(const)
%% ñîåäèíÿåìñÿ ñ ãåíåğàòîğîì
% close(gen_ftp_obj)
%% ÏÎÄÊËŞ×ÀÅÌÑß Ê ÃÅÍÅĞÀÒÎĞÓ
gen_ftp_obj = ftp(const.gen.ip,const.gen.username,const.gen.password);
%% ÏÅĞÅÕÎÄÈÌ Â ÏÀÏÊÓ USER
cd(gen_ftp_obj,'user');
mkdir(gen_ftp_obj, const.com.ref_wv_folder_name);
cd(gen_ftp_obj,const.com.ref_wv_folder_name);
%% ÃÅÍÅĞÀÖÈß ÑÎÇÂÅÇÄÈÉ, ÅÑËÈ ÈÕ ÍÅÒ
% ïğîâåğÿåì åñòü ëè ïàïêà ñ èñõîäíûìè ñèãíàëàìè íà êîìïüşòåğå
if (exist(const.com.ref_wv_folder_name, 'dir') ~= 7)
    mkdir(const.com.ref_wv_folder_name);
end
for APSK = const.sig.APSK
    ref_sample_filename = strcat(const.sig.ref_sample_filename(1),...
        num2str(APSK), const.sig.ref_sample_filename(2), '.mat');
    if (~exist(strcat(const.com.ref_wv_folder_name, '\', ref_sample_filename), 'file'))
        generating_constellations(const, APSK);
    end
end
%% ÇÀÃĞÓÆÀÅÌ ÑÎÇÂÅÇÄÈß ÍÀ ÃÅÍÅĞÀÒÎĞ
%% ÇÀÃĞÓÆÀÅÌ ÏÀÏÊÓ Â ÃÅÍÅĞÀÒÎĞ
mput(gen_ftp_obj, [ const.com.ref_wv_folder_name '\*.wv' ]);
close(gen_ftp_obj)