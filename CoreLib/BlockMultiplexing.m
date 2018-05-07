%% Block multiplexing 
% The block in X are transmitted with overlap and add of No samples
% No > 0, ovelapping
% No < 0, Zero padding
function [xt, Ns] = BlockMultiplexing(X, No)
[Nt, Nb] = size(X);
Ns = Nt-No;
N_sig = Ns*(Nb-1)+ Nt;
%x = X(:);
xt = zeros(N_sig,1);
xt(1:Nt) = X(:,1);
for nb=1:Nb-1
    xt((1:Nt)+nb*Ns) =  xt((1:Nt)+nb*Ns)+X(:,nb+1);
end
end