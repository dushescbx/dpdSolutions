function [d] = conv_data_from_FSW(fname)%;
% prompt='input_or_output_file';
if (nargin<1)
    [fname, pname] = uigetfile('*.txt','MultiSelect','on'); %вызов диалогового окна для выбора файлов
    fname = fullfile(pname,fname); %fname хранит полный путь в файлам. Массив 1хN, N - кол-во выбранных файлов
end
if ~iscell(fname)
    fname = {fname}; %преобразовывает char в cell
end

for i = 1:numel(fname)
    %
    hfin = fopen(fname{i},'r');    
    k=1;
    d = [];
    while (~feof(hfin))%&&(numel(d)==0
        tline = fgetl(hfin);
        d(k) = str2double(tline);
        k=k+1;
    end
    fclose(hfin);
    save([fname{i}, '.mat'],'d');
end

end

