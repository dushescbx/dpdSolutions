function [] = conv_pames_FSW_dat(fname)%;

%
%%ВЫБОР ВХОДНЫХ ФАЙЛОВ
if (nargin<1)
[fname, pname] = uigetfile('*.dat','MultiSelect','on'); %вызов диалогового окна для выбора файлов
fname = fullfile(pname,fname); %fname хранит полный путь в файлам. Массив 1хN, N - кол-во выбранных файлов
end
if ~iscell(fname)
    fname = {fname}; %преобразовывает char в cell
end
%%
for i = 1:numel(fname)
    %
    hfin = fopen(fname{i},'r');
    n = 0;
    while ~feof(hfin) %идем до конца файла
        tline = fgetl(hfin); %считываем строку
        if (numel(tline)>7)&&... %ищем строку с Values
                strcmp(tline(1:7),'Values;')
            n = sscanf(tline,'Values;%d;'); %записываем в n число после Values;
            break;
        end
    end
    %
    data = nan(n,1);
    d = [];
    while (~feof(hfin))&&(numel(d)==0)
        tline = fgetl(hfin);
        d = sscanf(tline,'%g;%g;');
    end
    for j = 1:numel(data)
        d = sscanf(tline,'%g;%g;');
        data(j) = [1,1i]*d(:);
        tline = fgetl(hfin);
    end
    fclose(hfin);
    %%
    simin = timeseries(data);
    save([fname{i}, '.mat'],'simin');
end

end%;