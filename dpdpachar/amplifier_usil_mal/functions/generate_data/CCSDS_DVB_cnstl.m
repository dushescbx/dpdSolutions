function [cnstl_IQ, cnstl_D] = CCSDS_DVB_cnstl(mod_scheme, rate)%;
% 'QPSK', '8PSK', '16APSK', '32APSK','64APSK_1'; % вид модуляции
% [cnstl_IQ, cnstl_D] = CCSDS_DVB_cnstl('16APSK', 4/5)%;
if ischar(mod_scheme)
    switch lower(mod_scheme)
        case 'qpsk'
            % [cnstl_I,cnstl_Q,cnstl_D] = CCSDS_DVB_cnstl_QPSK();
            [cnstl_IQ,cnstl_D] = CCSDS_DVB_cnstl_QPSK();
        case '8psk'
            % [cnstl_I,cnstl_Q,cnstl_D] = CCSDS_DVB_cnstl_8PSK();
            [cnstl_IQ,cnstl_D] = CCSDS_DVB_cnstl_8PSK();
        case '16apsk'
            if nargin == 2
                if isscalar(rate)
                    ptrn_r = [
                        2/3
                        3/4
                        4/5
                        5/6
                        8/9
                        9/10
                        ];
                    ptrn_g = [
                        3.15
                        2.85
                        2.75
                        2.70
                        2.60
                        2.57
                        ];
                    [~,ind] = min(abs(ptrn_r-rate));
                    g = ptrn_g(ind);
                    [cnstl_IQ,cnstl_D] = CCSDS_DVB_cnstl_16APSK(g);
                else
                    disp('ratio must be scalar!');
                end
            else
                error('ratio is missing!');
            end
        case '32apsk'
            if nargin == 2
                if isscalar(rate)
                    ptrn_r = [
                        3/4
                        4/5
                        5/6
                        8/9
                        9/10
                        ];
                    ptrn_g = [
                        2.84 5.27
                        2.72 4.87
                        2.64 4.64
                        2.54 4.33
                        2.52 4.30
                        ];
                    [~,ind] = min(abs(ptrn_r-rate));
                    g = ptrn_g(ind,:);
                    [cnstl_IQ,cnstl_D] = CCSDS_DVB_cnstl_32APSK(g);
                else
                    disp('ratio must be scalar!');
                end
            else
                error('ratio is missing!');
            end
        case '64apsk_1'
            % [cnstl_I,cnstl_Q,cnstl_D] = CCSDS_DVB_cnstl_QPSK();
            [cnstl_IQ,cnstl_D] = CCSDS_DVB_cnstl_64APSK_1();
        case '64apsk_2'
            % [cnstl_I,cnstl_Q,cnstl_D] = CCSDS_DVB_cnstl_QPSK();
            [cnstl_IQ,cnstl_D] = CCSDS_DVB_cnstl_64APSK_2();
        otherwise
            error('Valid constellation schemes are QPSK, 8PSK, 16APSK, 32APSK, 64apsk_1, 64apsk_2!');
    end
    %
    [~,cnstl_ind]=sort((2.^(0:size(cnstl_D,1)-1))*cnstl_D); % положение символов в созв
    cnstl_IQ = cnstl_IQ(cnstl_ind);
    cnstl_D = logical(cnstl_D(:,cnstl_ind));
else
    error('First input must be char!');
end
end%;
%-------------------------------------------------------------------------%
function [IQ,D] = CCSDS_DVB_cnstl_QPSK(~)%;
A=ones(1,4);  % амп в созвездии
P=(pi/4)+(pi/2)*(0:3);    % ф в созв
D=[    % биты символов в созв
    0 0
    1 0
    1 1
    0 1
    ]';
IQ=A.*exp(1i*P);
% I=real(IQ);
% Q=imag(IQ);
end%;
%-------------------------------------------------------------------------%
function [IQ,D] = CCSDS_DVB_cnstl_8PSK(~)%;
A=ones(1,8);  % амп в созвездии
P=(pi/4)*(0:7);    % ф в созв
D=[    % биты символов в созв
    0 0 1
    0 0 0
    1 0 0
    1 1 0
    0 1 0
    0 1 1
    1 1 1
    1 0 1
    ]';
IQ=A.*exp(1i*P);
% I=real(IQ);
% Q=imag(IQ);
end%;
%-------------------------------------------------------------------------%
function [IQ,D] = CCSDS_DVB_cnstl_16APSK(g)%;
r0=sqrt(4/(1+3*g^2));
A=[r0*ones(1,4),r0*g*ones(1,12)];  % амп в созвездии
P=[pi/4+(pi/2)*(0:3),pi/12+(pi/6)*(0:11)];    % ф в созв
D=[    % биты символов в созв
    1 1 0 0
    1 1 1 0
    1 1 1 1
    1 1 0 1
    0 1 0 0
    0 0 0 0
    1 0 0 0
    1 0 1 0
    0 0 1 0
    0 1 1 0
    0 1 1 1
    0 0 1 1
    1 0 1 1
    1 0 0 1
    0 0 0 1
    0 1 0 1
    ]';
IQ=A.*exp(1i*P);
% I=real(IQ);
% Q=imag(IQ);
end%;
%-------------------------------------------------------------------------%
function [IQ,D] = CCSDS_DVB_cnstl_32APSK(g)%;
r0=sqrt(8/(1+3*g(1)^2+4*g(2)^2));
A=[r0*ones(1,4),r0*g(1)*ones(1,12),r0*g(2)*ones(1,16)];  % амп в созвездии
P=[pi/4+(pi/2)*(0:3),pi/12+(pi/6)*(0:11),pi*0+(pi/8)*(0:15)];    % ф в созв
D=[    % биты символов в созв
    1 0 0 0 1
    1 0 1 0 1
    1 0 1 1 1
    1 0 0 1 1
    1 0 0 0 0
    0 0 0 0 0
    0 0 0 0 1
    0 0 1 0 1
    0 0 1 0 0
    1 0 1 0 0
    1 0 1 1 0
    0 0 1 1 0
    0 0 1 1 1
    0 0 0 1 1
    0 0 0 1 0
    1 0 0 1 0
    1 1 0 0 0
    0 1 0 0 0
    1 1 0 0 1
    0 1 0 0 1
    0 1 1 0 1
    1 1 1 0 1
    0 1 1 0 0
    1 1 1 0 0
    1 1 1 1 0
    0 1 1 1 0
    1 1 1 1 1
    0 1 1 1 1
    0 1 0 1 1
    1 1 0 1 1
    0 1 0 1 0
    1 1 0 1 0
    ]';
IQ=A.*exp(1i*P);
% I=real(IQ);
% Q=imag(IQ);
end%;
%-------------------------------------------------------------------------%
function [IQ,D] = CCSDS_DVB_cnstl_64APSK_1(~)%;
t=[8 16 20 20];
g=[2.2 3.6 5.0];
r0=sqrt(64/sum(t.*([1,g].^2)));
r=r0*[1,g];
ph0=pi./t;
A=[];
P=[];
for i=1:numel(t)
    A=[A,r(i)*ones(1,t(i))];  % амп в созвездии
    P=[P,ph0(i)+2*pi/t(i)*(0:t(i)-1)];
end
D=[    % биты символов в созв
    1 1 0 1 0 0
    1 1 0 0 0 0
    1 1 1 0 0 0
    1 1 1 1 0 0
    0 1 1 1 0 0
    0 1 1 0 0 0
    0 1 0 0 0 0
    0 1 0 1 0 0
    1 1 0 1 1 0
    1 1 0 0 1 0
    1 0 0 0 1 0
    1 0 0 0 0 0
    1 0 1 0 0 0
    1 0 1 0 1 0
    1 1 1 0 1 0
    1 1 1 1 1 0
    0 1 1 1 1 0
    0 1 1 0 1 0
    0 0 1 0 1 0
    0 0 1 0 0 0
    0 0 0 0 0 0
    0 0 0 0 1 0
    0 1 0 0 1 0
    0 1 0 1 1 0
    1 1 0 1 1 1
    1 1 0 0 1 1
    1 0 0 0 1 1
    1 0 0 1 1 1
    1 0 0 1 1 0
    1 0 1 1 1 0
    1 0 1 1 1 1
    1 0 1 0 1 1
    1 1 1 0 1 1
    1 1 1 1 1 1
    0 1 1 1 1 1
    0 1 1 0 1 1
    0 0 1 0 1 1
    0 0 1 1 1 1
    0 0 1 1 1 0
    0 0 0 1 1 0
    0 0 0 1 1 1
    0 0 0 0 1 1
    0 1 0 0 1 1
    0 1 0 1 1 1
    1 1 0 1 0 1
    1 1 0 0 0 1
    1 0 0 0 0 1
    1 0 0 1 0 1
    1 0 0 1 0 0
    1 0 1 1 0 0
    1 0 1 1 0 1
    1 0 1 0 0 1
    1 1 1 0 0 1
    1 1 1 1 0 1
    0 1 1 1 0 1
    0 1 1 0 0 1
    0 0 1 0 0 1
    0 0 1 1 0 1
    0 0 1 1 0 0
    0 0 0 1 0 0
    0 0 0 1 0 1
    0 0 0 0 0 1
    0 1 0 0 0 1
    0 1 0 1 0 1
    ]';
IQ=A.*exp(1i*P);
% I=real(IQ);
% Q=imag(IQ);
end%;
%-------------------------------------------------------------------------%
function [IQ,D] = CCSDS_DVB_cnstl_64APSK_2(~)%;
t=[4 12 20 28];
g=[2.4 4.3 7.0];
r0=sqrt(64/sum(t.*([1,g].^2)));
r=r0*[1,g];
ph0=pi./t;
A=[];
P=[];
for i=1:numel(t)
    A=[A,r(i)*ones(1,t(i))];  % амп в созвездии
    P=[P,ph0(i)+2*pi/t(i)*(0:t(i)-1)];
end
D=[    % биты символов в созв
    0 0 1 1 0 0
    0 0 1 1 1 0
    0 0 1 1 1 1
    0 0 1 1 0 1
    0 1 1 1 0 0
    1 1 1 1 0 0
    1 0 1 1 0 0
    1 0 1 1 1 0
    1 1 1 1 1 0
    0 1 1 1 1 0
    0 1 1 1 1 1
    1 1 1 1 1 1
    1 0 1 1 1 1
    1 0 1 1 0 1
    1 1 1 1 0 1
    0 1 1 1 0 1
    0 1 1 0 0 0
    1 1 1 0 0 0
    1 1 0 0 0 0
    1 1 0 1 0 0
    1 0 0 1 0 0
    1 0 0 1 1 0
    1 1 0 1 1 0
    1 1 0 0 1 0
    1 1 1 0 1 0
    0 1 1 0 1 0
    0 1 1 0 1 1
    1 1 1 0 1 1
    1 1 0 0 1 1
    1 1 0 1 1 1
    1 0 0 1 1 1
    1 0 0 1 0 1
    1 1 0 1 0 1
    1 1 0 0 0 1
    1 1 1 0 0 1
    0 1 1 0 0 1
    0 0 1 0 0 0
    1 0 1 0 0 0
    1 0 0 0 0 0
    0 0 0 0 0 0
    0 1 0 0 0 0
    0 1 0 1 0 0
    0 0 0 1 0 0
    0 0 0 1 1 0
    0 1 0 1 1 0
    0 1 0 0 1 0
    0 0 0 0 1 0
    1 0 0 0 1 0
    1 0 1 0 1 0
    0 0 1 0 1 0
    0 0 1 0 1 1
    1 0 1 0 1 1
    1 0 0 0 1 1
    0 0 0 0 1 1
    0 1 0 0 1 1
    0 1 0 1 1 1
    0 0 0 1 1 1
    0 0 0 1 0 1
    0 1 0 1 0 1
    0 1 0 0 0 1
    0 0 0 0 0 1
    1 0 0 0 0 1
    1 0 1 0 0 1
    0 0 1 0 0 1
    ]';
IQ=A.*exp(1i*P);
% I=real(IQ);
% Q=imag(IQ);
end%;
