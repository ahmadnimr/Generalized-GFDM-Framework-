% Apply channel on signal arranged in Ns x NB samples
% Ncp is CP length 
function [ He, Y ] = ApplyChannel( rchan, X, Ncp)
release(rchan);
rchan.Seed = rchan.Seed+1;
[Ns, NB] = size(X);
D = zeros(Ns,NB);
%% Estimate the channel appling a pulse
D(Ncp+1,:) = 1;
He = zeros(size(D));
for nb=1:NB
    He(:,nb) = step(rchan, D(:,nb));
end
%% reset the channel to first state which correspond to the estimation
reset(rchan);
y = step(rchan, X(:));
Y = reshape(y,Ns, NB);
end

