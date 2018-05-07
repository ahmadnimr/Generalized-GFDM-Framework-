function [TD, FD, FD_opt, FD_r] = Complexity( K, M, K_on, M_on, N_p, U )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
N = M*K;
TD_fft = U*M_on*K*log2(U*K);
FD_fft = K_on*M*log2(M) + U*N*log2(U*N);
TD = zeros(1,3);
FD = zeros(1,3);
TD(1) = TD_fft + U*N*M_on;
TD(2) = TD_fft + U*N+ 2*U*N*log2(M);
TD(3) =  TD_fft + U*N*M_on;

FD(1) = FD_fft + N*K_on;
FD(2) = FD_fft + N+ 2*N*log2(K);
FD(3) =  FD_fft + N_p*K_on;
FD_opt = M*log2(M) + U*N*log2(U*N) + 2*M*K_on;
FD_r = K_on*M*log2(M)+K_on*N_p;
end

