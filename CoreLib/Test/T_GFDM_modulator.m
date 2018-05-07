Kt = [16, 1, 16];
Mt = [8, 16, 1];
M1t = [6, 1, 0];
M2t = [6, 0, 1];
err_T_shift = zeros(3,1);
err_T_ref = zeros(3,1);
err_T_shift2= zeros(3,1);
err_gr= zeros(3,1);
for i =1:3
    K = Kt(i);
    M = Mt(i);
    M1 = M1t(i);
    M2 = M2t(i);
    N = M *K;
    
    D = zeros(K,M);
if K>1
    K_set = [1 , 3, 4];
else
     K_set = 1;
end

    D(K_set, :) = rand(length(K_set),M);
    gn = randn(1,M1);
    gp = randn(1,M2);
    
    gf = zeros(N,1);
    gf(1:M2) = gp;
    gf(end-(M1-1:-1:0)) = gn;
    
    Xf = ModulatorGFDMFrequency(D, K_set, gp, gn, 0);
    xt = ifft(reshape(Xf.', N,1));
    gt = ifft(gf);
    xt_ref = ref_GFDM_Mod(D,gt,K,M);   
    err_T_ref(i) = norm(xt_ref-xt, 'fro');
   
    %with shift
     gf = zeros(N,1);
    gf(M+(1:M2)) = gp;
    gf(M-(M1-1:-1:0)) = gn;
    
    Xf = ModulatorGFDMFrequency(D, K_set, gp, gn, 1);
    xt = ifft(reshape(Xf.', N,1));
    gt = ifft(gf);
    xt_ref = ref_GFDM_Mod(D,gt,K,M);   
    err_T_shift(i) = norm(xt_ref-xt, 'fro');
    
     %with shift
     gf = zeros(N,1);
     if K>1
     gf(1:2*M) = rand(2*M,1);
    gp = gf(M+(1:M));
    gn = gf(1:M);
     else
    gf(1:M) = rand(M,1);
    gp = [];
    gn = gf(1:M);
     end
    
    Xf = ModulatorGFDMFrequency(D, K_set, gp, gn, 1);
    xt = ifft(reshape(Xf.', N,1));
    gt = ifft(gf);
    xt_ref = ref_GFDM_Mod(D,gt,K,M);   
    err_T_shift2(i) = norm(xt_ref-xt, 'fro');
    
end




