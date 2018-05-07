% Low complex computation of the SNR vector after demodulator
% Considering demodulator in Frequency domain 
% Vg = ifft(Wfr) 
% hf estimated channel 
% hf_eq: equalization channel: is generated using ReceiveWindow i.e. MMSE, ZF, MF
% EsN0: Es/N0
% isOFDM = true is used with OFDM to reduce complexity 
%% Important: the rsults are vaild for orthogonal Window only...
function v_snr = ComputeSNR( Vg, hf, hf_eq, EsN0 ,isOFDM )
[K,M] = size(Vg);
N = K*M;
Heq = transpose(reshape(hf_eq, M, K));
Hi = transpose(reshape(hf_eq.*hf-1, M, K));
if isOFDM
    Pn = abs(Vg(1)*Heq).^2;
    Pi = abs(Vg(1)*Hi).^2;
else
Pn = Power(Heq, Vg);
Pi = Power(Hi, Vg);
end
v_snr =1./ repmat(N*Pi+ Pn*N/EsN0, M,1);
end

function P = Power(H, Vg)
%Vg = ifft(Wfr);
% Z = 1/M*FK(W.*(1/K*FK' *(H.*V)))FM'
% Zm = [FK*diag(w(:,m)FK'/K vm.*hm]
% U = ZFM'/M;
[K,M] = size(Vg);
P = zeros(K,1);
for k = 0:K-1
    P(k+1) =  norm(H.*shiftMat(Vg, k), 'fro')^2;
end
P = P/M^2;
end
function Vgs = shiftMat(Vg, k)
K = size(Vg,1);
k_in = mod((0:K-1)-k, K)+1;
Vgs = Vg(k_in,:); 
end