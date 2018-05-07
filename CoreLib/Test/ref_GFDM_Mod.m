function x = ref_GFDM_Mod(D,g,K,M)
N = M*K;
tmp = zeros(N,1);
x  = zeros(N,1);
for m=0:M-1
    for k=0:K-1
        % Note that N_cp can be included here
        for n=0:N-1
            tmp(n+1) = D(k+1,m+1) * g(mod(n-m*K, N)+1)*exp(2*1j*pi*n*k/K);
        end
        x = x+ tmp;
    end
end
end