Kt = [16, 1, 16];
Mt = [8, 16, 1];


for i =1:3
    K = Kt(i);
    M = Mt(i);
    N = M *K;
    gt = randn(N,1) + 1j*randn(N,1);
    
    D = rand(K,M);
    K_set = 1:K;
    Wt = PulseToWindow( gt, K, M ,'TD');
    Wr = ReceiveWindow(Wt,'ZF');
    D = rand(K,M);        
   
        Xf = GeneralModulator(D, K_set, Wt, 'TD');
        D_e = GeneralDemodulator(Xf, K_set,Wr, 'TD');        
        err(i) = norm(D-D_e, 'fro');
end




