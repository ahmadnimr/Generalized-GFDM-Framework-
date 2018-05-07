%% PSD 
% theoritical PSD of filter matrix G
function S = Psd_th( G, R)
% R is the resolution 
N = size(G,1);
S = real(sum(abs(fft(G, N*R)).^2,2)/N);
end

