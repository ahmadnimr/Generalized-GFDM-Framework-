Kt = [16, 1, 16];
Mt = [8, 16, 1];

for i =1:3
    K = Kt(i);
    M = Mt(i);
    N = M*K;
    K_set = 1:K;
    gf = randn(N,1) + 1j*randn(N,1);
    Wt = PulseToWindow( gf, K, M ,'FD');
    Wr = ReceiveWindow(Wt,'ZF');
    D = rand(K,M);        
   
        Xf = GeneralModulator(D, K_set, Wt, 'FD');
        D_e = GeneralDemodulator(Xf, K_set,Wr, 'FD');        
        err(i) = norm(D-D_e, 'fro');
end




