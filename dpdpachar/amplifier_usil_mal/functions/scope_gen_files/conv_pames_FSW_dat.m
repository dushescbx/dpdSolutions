function [] = conv_pames_FSW_dat(fname)%;

%
%%
if (nargin<1)
[fname, pname] = uigetfile('*.dat','MultiSelect','on');
fname = fullfile(pname,fname);
end
if ~iscell(fname)
    fname = {fname};
end
%%
for i = 1:numel(fname)
    %
    hfin = fopen(fname{i},'r');
    n = 0;
    while ~feof(hfin)
        tline = fgetl(hfin);
        if (numel(tline)>7)&&...
                strcmp(tline(1:7),'Values;')
            n = sscanf(tline,'Values;%d;');
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
        data_re(j) = [1]*d(1,1);
        data_im(j) = [1]*d(2,1);
        tline = fgetl(hfin);
    end
    fclose(hfin);
    %%
    simin = timeseries(complex(data_re,data_im));
    save([fname{i}, '.mat'],'simin');

end

end%;