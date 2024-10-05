X = randi([-5,5],100,1);
[N,edges,bin] = histcounts(X,'BinMethod','integers');
count = nnz(bin==3);