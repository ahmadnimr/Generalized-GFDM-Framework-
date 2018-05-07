%Generate receiver window according to the type of receiver
function Wr = ReceiveWindow( Wt, rxType, SNR)
if nargin < 3
    SNR = 1E5;
end
if strcmp(rxType, 'ZF')
    Wr =1./Wt;
elseif strcmp(rxType, 'MMSE')
    Wr = conj(Wt)./(abs(Wt).^2 + 1./SNR);
elseif strcmp(rxType, 'MF')
    % not that MF in frequncy must have total norm of N
    Wr = conj(Wt);
end
end
