% W: KxM input window
% type = {'TD', 'FD'}
% gr = receive pulse. This pulse in time domain or frequency domain
% depending on the selected type
function gr = WindowToPulse( W, type)
[K,M] = size(W);

if strcmp(type,'TD')
    W = W.';
    if M>1
        gr = reshape(transpose(ifft(W)), K*M,1);
    else
        gr = reshape(transpose(W), K*M,1);
    end
else % FD
    if K>1
        gr = reshape(transpose(conj(W)), K*M,1);
    else
        gr = reshape(transpose(W), K*M,1);
    end
end
