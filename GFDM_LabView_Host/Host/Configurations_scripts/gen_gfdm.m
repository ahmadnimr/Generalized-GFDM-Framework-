function [K,M, N, N_cp, N_cs, N_on, Wt, Wrf, w_cs, N_s, K_set, M_set] =  gen_gfdm(K,M,N_cp,N_cs,alpha, select, sub0ff)
N = M*K;
g = Filter(K,M,alpha);
gf = fft(g);
if sub0ff ==1 
M_set = int32(mod(1:M-1, M)'+1);
else
M_set = int32(mod(0:M-1, M)'+1);
end
if (select == 1)
    
    % To acheive 20 MHz with FS of 30.27 Mhz
    % K_on = 10/30.72*K
    % two subcarriers are guard and Dc is off
    
    K_set = int32( mod([0:K-1 ],K)'+1);
    M_on = int32(length(M_set));
    K_on = int32(length(K_set));
    N_on = M_on*K_on;
elseif (select == 2)

    % To acheive 20 MHz with FS of 30.27 Mhz
    % K_on = 10/30.72*K
    % two subcarriers are guard and Dc is off
    K_on = K/2;
    K_on2 = floor(K_on/2);
    K_set = int32( mod([1:K_on2,-K_on2:-1 ],K)'+1);
    
    M_on = int32(length(M_set));
    K_on = int32(length(K_set));
    N_on = M_on*K_on;
    
else
    K = 64;
    M = 16;
    Fs = 30.72;
    B = 20;
    M_set = int32(mod(1:M-1, M)'+1);
    % To acheive 20 MHz with FS of 30.27 Mhz
    % K_on = 10/30.72*K
    % two subcarriers are guard and Dc is off
    K_on = floor(B/Fs*K)-3;
    K_on2 = floor(K_on/2);
    K_set = int32( mod([1:K_on2,-K_on2:-1 ],K)'+1);
    M_on = int32(length(M_set));
    K_on = int32(length(K_set));
    N_on = M_on*K_on;
    N = M*K;
    gf = zeros(N,1);
    gf(1:M/2) = 1;
    gf(end-(0:M/2-1)) = 1;
    gf = gf*sqrt(N)/ norm(gf);
    g = ifft(gf);
    % Tx window
    if M>1
        Wt = fft(transpose(reshape(g,K,M)));
    else
        Wt = transpose(reshape(g,K,M));
    end
    %
    if K>1
        Wtf = fft(transpose(reshape(gf,M,K)));
    else
        Wtf = transpose(reshape(gf,M,K));
    end
end
% Tx window
if M>1
    Wt = fft(transpose(reshape(g,K,M)));
else
    Wt = transpose(reshape(g,K,M));
end
%
if K>1
    Wtf = fft(transpose(reshape(gf,M,K)));
else
    Wtf = transpose(reshape(gf,M,K));
end

Wrf = 1./Wtf;
K = int32(K);
M = int32(M);
N = int32(N);
N_cp = int32(K/2);
N_cs = int32(K/2);
w_cs = zeros(N_cs,1);
N_s = N+N_cp+N_cs;

end