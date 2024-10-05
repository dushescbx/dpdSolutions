function varargout = helperPACharMemPolyModel(proc,varargin)
%helperPACharMemPolyModel Memory polynomial helper function
% Helper function to perform various functionality for power amp example.
% Each of the cases below returns a single variable.
%
% coefficientMatrix =
%  helperPACharMemPolyModel('coefficientFinder',x,y,memLen,degLen,modType)
%
% outputSignal =
%  helperPACharMemPolyModel('signalGenerator',x,coefMat,modType)
%
% signalError =
%  helperPACharMemPolyModel('errorMeasure',x,y,coefMatFit,modType)
%

% Copyright 2017-2020 The MathWorks, Inc.

% Check number of outputs
nargoutchk(1, 1)

switch proc
    case 'coefficientFinder'
        % Procedure to compute the coefficient matrix given input and
        % output signals, memory length, degree, and model type

        % modType
        %   memPoly:   Memory polynomial
        %   ctMemPoly: Cross-term memory polynomial

        % Check number of inputs and assign values
        narginchk(6,6)
        x       = varargin{1};
        y       = varargin{2};
        memLen  = varargin{3};
        degLen  = varargin{4};
        modType = varargin{5};

        % Length of input vector
        xLen = length(x);
        x = x(:);
        y = y(:);

        % Compute input variable term for each entry in coefficient matrix
        switch modType
          case 'memPoly'
            xrow = reshape((memLen:-1:1)' + (0:xLen:xLen*(degLen-1)),1,[]);
            xVec = (0:xLen-memLen)' + xrow;
            xPow = x.*(abs(x).^(0:degLen-1));
            xVec = xPow(xVec);
          case 'ctMemPoly'
            absPow = (abs(x).^(1:degLen-1));
            partTop1 = reshape((memLen:-1:1)'+(0:xLen:xLen*(degLen-2)), ...
                1,[]);
            topPlane = reshape(                                         ...
                [ones(xLen-memLen+1,1),                                 ...
                absPow((0:xLen-memLen)' + partTop1)].',                 ...
                1,memLen*(degLen-1)+1,xLen-memLen+1);
            sidePlane = reshape(x((0:xLen-memLen)' + (memLen:-1:1)).',  ...
                memLen,1,xLen-memLen+1);
            cube = sidePlane.*topPlane;
            xVec = reshape(cube,memLen*(memLen*(degLen-1)+1),           ...
                xLen-memLen+1).';
        end

        % Use MATLAB \ operator to generate a least-squares solution to the
        % overdetermined problem. Reshape xTerms where a row is each term
        % of the coefficient matrix expanded along columns at a particular
        % instant of time.
        coef = xVec\y(memLen:xLen);

        % Output coefficient matrix (coefMat)
        varargout{1} = reshape(coef,memLen,numel(coef)/memLen);

    case 'signalGenerator'
        % Generate output signal for narrowband power amplifier using an
        % input signal

        % Check number of inputs and assign values
        narginchk(4,4)
        x       = varargin{1};
        coefMat = varargin{2};
        modType = varargin{3};

        % Handle setup constants
        [memLen, numCols] = size(coefMat);
        memLenM1 = memLen-1;
        coefReshaped = reshape(coefMat,1,memLen*numCols);
        xLen = length(x);
        y = zeros(xLen,1);

        % modType
        %   memPoly:   Memory polynomial
        %   ctMemPoly: Cross-Term memory
        switch modType
            case 'memPoly'
                degLen = numCols;
                for timeIdx = memLen:xLen
                    % Common input variable entry terms for all rows in
                    % coefficient matrix
                    xTerms = zeros(1,memLen*degLen);
                    xTime = x(timeIdx-(0:memLenM1));
                    xTerms(1,1:memLen) = xTime;
                    for degIdx = 2:degLen
                        degIdxM1 = degIdx-1;
                        startPos = degIdxM1*memLen+1;
                        endPos = startPos+memLenM1;
                        xTerms(1,startPos:endPos) =                     ...
                            xTime.*(abs(xTime).^degIdxM1);
                    end
                    y(timeIdx) = coefReshaped*xTerms(:);
                end
            case 'ctMemPoly'
                degLen = round(((numCols-1)/memLen)+1);
                degLenM1 = degLen-1;
                for timeIdx = memLen:xLen
                    % Common input variable entry terms for all rows in
                    % coefficient matrix
                    xTime = x(timeIdx-(0:(memLenM1)));
                    xRow = [1 zeros(1,numCols-1)];
                    for powIdx = 1:degLenM1
                        startPos = 2+memLen*(powIdx-1);
                        endPos = startPos+memLenM1;
                        xRow(startPos:endPos) = abs(xTime).^powIdx;
                    end
                    % Generate all individual terms for output signal
                    xTerms = xTime(:)*xRow;
                    % Multiply each term by appropriate coefficient
                    y(timeIdx) = coefReshaped*xTerms(:);
                end
                % Output generated output signal
        end
        varargout{1} = y;

    case 'errorMeasure'
        % Compute coefMat and output signal error measures

        % Check number of inputs and assign values
        narginchk(5,5)
        x          = varargin{1};
        y          = varargin{2};
        coefMatFit = varargin{3};
        modType    = varargin{4};

        memLen = size(coefMatFit,1);
        y_prediction = zeros(size(y));
        y_prediction(:) = helperPACharMemPolyModel('signalGenerator',  ...
            x, coefMatFit, modType);
        M = abs(y(memLen:end));
        difference = abs(y(memLen:end)-y_prediction(memLen:end))./M;

        % Output error measure (errSig)
        varargout{1} = rms(difference)*100;
end
end