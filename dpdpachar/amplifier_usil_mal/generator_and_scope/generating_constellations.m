function generating_constellations(const, APSK)

%% тсмйжхъ дкъ онксвемхъ mode_sel дкъ цемепюжхх яхмупнмхгхпсчыху яхлбнкнб
[mode_sel, M_gen]=constellation_mode(APSK);
options = simset('SrcWorkspace','current');
%% цемепхпсел TIMESERIES янгбегдхъ
sim('model_for_generating_constellations_ref_files.slx', [], options);
ref_sym.data(:)=ref_sym.data;
%% ядбхцюел бпелеммни пъд
ref_sym_symbols.data(1+const.sig.num_of_zeros:const.mod.model_sim_time)=...
    ref_sym.data(1:const.mod.model_sim_time-const.sig.num_of_zeros);
%% бярюбкъел яхмупнмхгхпсчысч онякеднбюрекэмнярэ
ref_sym_symbols.data(1:1:const.sig.num_of_zeros) = ...
    ones*complex_num_for_symbol(APSK,mode_sel);
ref_sym_symbols.time=ref_sym.time(1:length(ref_sym_symbols.data));
ref_sym_symbols=timeseries(ref_sym_symbols.data,ref_sym_symbols.time);
%% янупюмъел хглемеммши бпелеммни пъд

I=real(ref_sym_symbols.data(:));
Q=imag(ref_sym_symbols.data(:));
fc = const.SCPI.DDEM_SRAT;

ref_sym_filename = strcat(const.sig.ref_symb_filename(1),...
    num2str(APSK), const.sig.ref_symb_filename(2), '.mat');
save(strcat(const.com.ref_wv_folder_name, '\', ref_sym_filename), 'I', 'Q', 'fc');
Convert_Mat2Wv_function(char(strcat(const.com.ref_wv_folder_name, '\', ref_sym_filename)), const.gen.ip);
%% опносяйюел вепег тхкэрп опхондмърнцн йняхмсяю
ref_samples=tx_filter(complex(I,Q));
% sim('model_for_generating_constellations_ref_files_2.slx');
% ref_samples=ref_samples(1:4*length(ref_sym_symbols.data));
scatterplot(ref_sym_symbols.data)
%% напегюел дюммше

%% янгдюел MAT тюик я I Q fc, ДКЪ ЙНМБЕПРЮЖХХ mat Б wv ТНПЛЮР
I=real(ref_samples);
Q=imag(ref_samples);
fc = const.SCPI.DDEM_SRAT * const.SCPI.samples_per_symbol_ratio;
ref_sample_filename = strcat(const.sig.ref_sample_filename(1),...
    num2str(APSK), const.sig.ref_sample_filename(2), '.mat');
save(strcat(const.com.ref_wv_folder_name, '\', ref_sample_filename), 'I','Q','fc');
Convert_Mat2Wv_function( char(strcat(const.com.ref_wv_folder_name, '\', ref_sample_filename)), const.gen.ip );
scatterplot(ref_samples);
