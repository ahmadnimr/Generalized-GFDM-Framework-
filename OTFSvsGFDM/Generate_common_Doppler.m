function [ K_set, M_set, Wt, Wfr, Vg, EsN0, N0, imp, params, N_run, N_fD] = Generate_common_Doppler( K,M,NB, SNR, N_run1, fD, isOFDM )
K_set = 1:K;
M_set = 1:M;
N = M*K;
% TX and RX window
psFunc = CreatePulse;
alpha = 0.0;
if ~isOFDM
    [~, gf_rc] = psFunc.ISIFree(K, M, alpha, psFunc.FuncRC, 'real', 0.5);
    gf_rc = sqrt(N)/norm(gf_rc)*gf_rc;
    g = ifft(gf_rc);
else % GFDM
    g = ones(N,1);
end
g = g/norm(g);

gf = fft(g);
Wt = PulseToWindow( g, K, M, 'TD');
Wft= PulseToWindow( gf, K, M, 'FD');
Wfr = ReceiveWindow( Wft, 'ZF');
Vg = ifft(Wfr);

%% chanel params
N_fD = length(fD);

EsN0 = 10.^(SNR/10);
N0 = 1./EsN0;

%% Measuremnt


for n_fd = 1:N_fD
    imp{n_fd} = CreateMeasurments();
end
params.N_useful = 1:N;  % only the useful FD samples
params.Nb = NB;

%% Evalution
if N_run1>0
    N_run = N_run1*(N_fD:-1:1);
else
    N_run = 10*ones(1,N_SNR);
end
end

