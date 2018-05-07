%type = 'TD', 'FD'
% w receiver window in time or frequency domain
% K_Set active subcarriers 
% D: data matrix K x M, zeros are for non allocated data
function D = GeneralDemodulator( X, K_set, W, type )
if strcmp(type,'TD')
    [M, K] = size(X);
    if M>1
        X = transpose(fft(X));
    else
        X = transpose(X);
    end
else
    [K, M] = size(X);
    if K>1
        X = ifft(X);
    end
end
% windowing
D = X.*W;
% dePrecoding
if K>1
    D = fft(D);
end
if M>1
    D(K_set,:) = transpose(ifft(transpose(D(K_set,:)))); % M x K
end
end

