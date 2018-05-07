function [ K_set, M_set, Wt, Wfr, Vg, rchan, EsN0, N0, imp, params, N_run, N_SNR] = Generate_common_fD( K,M,NB, SNR, N_run1,ChType, fD, fs, isOFDM )
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
rchan = GenFadingChannel( ChType, fD, fs);
EsN0 = 10.^(SNR/10);
N0 = 1./EsN0;

%% Measuremnt
N_SNR = length(SNR);

for n_snr = 1:N_SNR
    imp{n_snr} = CreateMeasurments();
end
params.N_useful = 1:N;  % only the useful FD samples
params.Nb = NB;

%% Evalution
if N_run1 > 0
    N_run = max(10*N_run1*(1:N_SNR),N_run1*2.^(1:N_SNR));
else
    N_run = 10*ones(1,N_SNR);
end
end

