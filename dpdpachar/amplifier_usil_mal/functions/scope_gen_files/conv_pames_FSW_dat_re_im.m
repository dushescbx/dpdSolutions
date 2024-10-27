function [] = conv_pames_FSW_dat(fname)%;

%
%%����� ������� ������
if (nargin<1)
[fname, pname] = uigetfile('*.dat','MultiSelect','on'); %����� ����������� ���� ��� ������ ������
fname = fullfile(pname,fname); %fname ������ ������ ���� � ������. ������ 1�N, N - ���-�� ��������� ������
end
if ~iscell(fname)
    fname = {fname}; %��������������� char � cell
end
%%
for i = 1:numel(fname)
    %
    hfin = fopen(fname{i},'r');
    n = 0;
    while ~feof(hfin) %���� �� ����� �����
        tline = fgetl(hfin); %��������� ������
        if (numel(tline)>7)&&... %���� ������ � Values
                strcmp(tline(1:7),'Values;')
            n = sscanf(tline,'Values;%d;'); %���������� � n ����� ����� Values;
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