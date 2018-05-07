% General modulator
%type = 'TD', 'FD'
% w transmitter window in time or frequency domain
% K_Set active subcarriers 
% D: data matrix K x M, zeros are for non allocated data
function X = GeneralModulator( D, K_set, W, type )
% Precoding
[K,M] = size(D);
% Precoding
Dp = zeros(K,M);
if M>1
    Dp(K_set,:) = transpose(fft(transpose(D(K_set,:)))); % M x K
else
    Dp(K_set,:) = D(K_set,:); % M x K
end

if K>1
    Dp = ifft(Dp);
end
% windowing
X = Dp.*W;
% domain specific
if strcmp(type,'TD')
    if M>1
        X = ifft(X.');
    else
        X = X.';
    end
else
    if K>1
        X = fft(X);
    end
end
end

