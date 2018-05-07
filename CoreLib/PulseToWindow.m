% Wt: KxM output window
% type = {'TD', 'FD'}
% gr = a pulse. This pulse in time domain or frequency domain
% depending on the selected type
function Wt = PulseToWindow( g, K, M, type)
if strcmp(type,'TD')
    
    if M>1
        Wt = K*fft(transpose(reshape(g, K,M)));
    else
        Wt = K*transpose(reshape(g, K,M));
    end    
    Wt = Wt.';
else % FD
    if K>1
        Wt = K*ifft(transpose(reshape(g, M,K)));
    else
        Wt = transpose(reshape(g, M,K));
    end
end
