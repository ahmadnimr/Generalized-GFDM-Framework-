K = 16;
M = 8;
N = K*M;
alpha = 0;

psFunc = CreatePulse;

[~, gf_rc] = psFunc.ISIFree(K, M, alpha, psFunc.FuncRC, 'real', 0.5);
%[~, gf_rc] = psFunc.ISIFreeMatched(K, M, alpha,psFunc.FuncRC,psFunc.FuncXia,0, 0.5 )
gf_rc = sqrt(N)/norm(gf_rc)*gf_rc;

g = ifft(gf_rc);
g = g/norm(g);

GFDM_func = Create_GFDM_functions;
out = GFDM_func.GenMatrices(g,K,M);
Af = out.Gf_M;
Af_inv = out.Gf_M'/N;

gf = fft(g);

Wt = PulseToWindow( g, K, M, 'TD');
Wft= PulseToWindow( gf, K, M, 'FD');
Wfr = ReceiveWindow( Wft, 'ZF');
rxType = 'ZF';
EsN0 = 10;
hf = randn(N,1)+1j*randn(N,1);
hf_eq = ReceiveWindow( hf, rxType, EsN0);
Pi = transpose((hf_eq.*hf -1));
Pn = transpose(hf_eq);
temp = abs(Af_inv .* repmat(Pi, N,1)).^2 + abs(Af_inv .* repmat(Pn, N,1)).^2/EsN0;
EsNo_vec =  1./sum(temp, 2)/N;
Vg = ifft(Wfr);
v_snr = ComputeSNR( Vg, hf, hf_eq, EsN0  );

err = norm(v_snr-EsNo_vec);