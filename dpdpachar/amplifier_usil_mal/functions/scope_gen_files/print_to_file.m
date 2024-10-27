function print_to_file(x,fname)
fid=fopen(fname,'wt');

for ii=1:length(x)
    fprintf(fid,'%19.17f;%19.17f',real(x(ii,:)),imag(x(ii,:)));
    fprintf(fid,'\n');
end
fclose(fid);