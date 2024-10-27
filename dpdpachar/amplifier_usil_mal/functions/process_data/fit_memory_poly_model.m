function a_coef = fit_memory_poly_model(x, y, memLen, degLen,modType)
x=x(:);
y=y(:);
xLen=length(x);
switch modType
    case 'MemPoly'
        xrow=reshape((memLen:-1:1)'+(0:xLen:xLen*(degLen-1)),1,[]);
        xVec=(0:xLen-memLen)'+xrow;
        xPow=x.*(abs(x).^(0:degLen-1));
        xVec=xPow(xVec);
    case 'ctMemPoly'
        absPow=(abs(x).^(1:degLen-1));
        partTop1=reshape((memLen:-1:1)'+(0:xLen:xLen*(degLen-2)),1,[]);
        topPlane=reshape([ones(xLen-memLen+1,1),absPow((0:xLen-memLen)'+partTop1)].',...
        1,memLen*(degLen-1)+1,xLen-memLen+1);
        sidePlane=reshape(x((0:xLen-memLen)'+(memLen:-1:1)).',memLen,1,xLen-memLen+1);
        cube=sidePlane.*topPlane;
        xVec=reshape(cube,memLen*(memLen*(degLen-1)+1),xLen-memLen+1).';
end
coef=xVec\y(memLen:xLen);
a_coef=reshape(coef,memLen,numel(coef)/memLen);

