function D = ref_GFDM_DeMod(x,gr,K,M)
N = M*K;
D  = zeros(K,M);
for m=0:M-1
    for k=0:K-1
        % Note that N_cp can be included here
        for n=0:N-1
           D(k+1,m+1) = D(k+1,m+1) + x(n+1)* conj(gr(mod(n-m*K,N)+1))*exp(-2*1j*pi*n*k/K);
        end
    end
end
end