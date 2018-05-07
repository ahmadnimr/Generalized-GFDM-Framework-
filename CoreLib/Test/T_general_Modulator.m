Kt = [16, 1, 16];
Mt = [8, 16, 1];

err_F_T = zeros(3,1);
err_T_ref = zeros(3,1);
err_D= zeros(3,1);
err_gr= zeros(3,1);
err_Dt= zeros(3,1);
err_Df= zeros(3,1);

for i =1:3
    K = Kt(i);
    M = Mt(i);
    N = M *K;
    
    D = rand(K,M);
    
    gt = randn(N,1) + 1j*randn(N,1);
    K_set = 1:K;
    Wt = PulseToWindow( gt, K, M, 'TD');
    
    Wft= PulseToWindow( fft(gt), K, M, 'FD');
    
    Xf = GeneralModulator(D, K_set, Wft, 'FD');
    xf = reshape(Xf.',N,1);
    X = GeneralModulator(D, K_set, Wt,'TD');
    xt = reshape(X.',N,1);
    Wr = ReceiveWindow( Wt, 'ZF');
    gr = WindowToPulse( conj(Wr), 'TD');
     
    Wfr = ReceiveWindow( Wft, 'ZF');
    gfr = WindowToPulse( conj(Wfr), 'FD');
     
    xt_ref = ref_GFDM_Mod(D,gt,K,M);
    D_e =  ref_GFDM_DeMod(xt_ref,gr,K,M);
    Dt_e =  GeneralDemodulator( X, K_set, Wr, 'TD' );
    Df_e =  GeneralDemodulator( Xf, K_set, Wfr, 'FD' );
    err_F_T(i)   = norm(xf-fft(xt), 'fro');
    err_T_ref(i) = norm(xt_ref-xt, 'fro');
    err_D (i)    = norm(D-D_e, 'fro');
    err_Dt (i)   = norm(D-Dt_e, 'fro');
    err_Df (i)   = norm(D-Df_e, 'fro');
    err_gr (i)   = norm(gr-ifft(gfr), 'fro');
end




