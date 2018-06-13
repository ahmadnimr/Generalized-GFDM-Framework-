function [d, pre_cp, pref64, pre64]  = gen_pre(select, Ncs, Ncp, S, R)
M = 2;
K = 64;
N = K*M;
d = zeros(K,1);
k = double((0:K-1)');
d0 = sqrt(64)*[1, -1, -1, -1, -1,-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1, 
    -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, 1, -1, 1, 
    -1, -1, -1, -1, 1, -1, -1, 1, -1, 1, -1, -1, -1, -1, 1]'; 

if(select == 1)
d(1:K) = d0(1:K); 

elseif (select == 2)
d = d0
S = 25;
s = double( (1:S)');
K2 = floor(K/2);
d(K2+(1:S)) = d(K2+(1:S)).*sin(pi/2*s/S);
d(K2-(0:S-1)) = d(K2-(0:S-1)).*sin(pi/2*s/S);

else
 Kd = double(K);
 Rd = double(R);
d = sqrt(64)*exp(-1j*pi*Rd*k.*(k+1)/Kd);
Sd = double(S);
s = double( (1:S)');
K2 = floor(K/2);
d(K2+(1:S)) = d(K2+(1:S)).*sin(pi/2*s/Sd);
d(K2-(0:S-1)) = d(K2-(0:S-1)).*sin(pi/2*s/Sd);
end

pre64 = ifft(d)/4;

pre = repmat(pre64,2,1);
pref64 = 2*fft(pre(1:K));

No = Ncp+ Ncs;
Nt = N+No;
nt = 0:Nt-1;
pre_cp = pre(mod(nt-Ncp, N)+1);

end
