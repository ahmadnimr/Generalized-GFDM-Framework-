K = 32;
M = 1;
P = -M/2:M/2-1;
Ncp = 0;
Ncs = 0;
N = K*M;
Ns = N+Ncp+Ncs;
%n0= Ncp;
n0 = 0;
gf = ones(length(P),1);
m = 0; 
k = 0;
U = 4;
w = ones(Ns,1)/Ns;
K_set = -K/4:K/4;
M_set = 1;
Non = length(K_set)*length(M_set);
Sx_th = zeros(N*U,1);
Sx2_th = zeros(N*U,1);
for k = K_set
    for m = M_set
[Skm0, f0] = PsdSubcarrier2( gf, P, k, m, K, M, n0, Ns, U);
Sx2_th = Sx2_th+PsdSubcarrier2( gf, P, k, m, K, M, n0, Ns, U);
Sx_th = Sx_th + Skm0;
    end
end



Nb = 2048*10;
Don = 2*(randi([0,1],Non,Nb)-0.5);
X = Modulator(Don, K, M, K_set, M_set, gf,P,1);
Xo = AddCpCs( X, N, Ncp, Ncs);
x = Xo(:);
Nfft =  Ns*U;
[Sx, f1] = PSD_Estimation( x, Nfft);
S0_th = sum(fftshift(Sx_th))/Ns*1/(N*U);
S0_th2 = sum(fftshift(Sx2_th))/Ns*1/(N*U);
S0 = sum(fftshift(Sx))*1/(Nfft);
close all
figure(1)
plot(f0, 10*log10(fftshift(Sx_th)/Ns/S0_th))
hold on
plot(f0, 10*log10(fftshift(Sx2_th)/Ns/S0_th2))
hold on
plot(f1,10*log10(fftshift(Sx/S0)));
legend('th','th2','Es')
 