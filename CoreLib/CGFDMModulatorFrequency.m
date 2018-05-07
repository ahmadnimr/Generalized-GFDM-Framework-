%%conventional Modulator in frequency
function Xf = CGFDMModulatorFrequency(D, K_set, gp, gn, shift)
if nargin < 5
    shift = 1;
end
if shift == 1
    ln = 0;
    lp = 1;
else
    ln=1;
    lp = 0;
end
[K,M] = size(D);
K_on = length(K_set);
M1 = length(gn);
M2 = length(gp);
gn = reshape(gn,1, M1);
gp = reshape(gp,1, M2);
if M>1
    DMf = transpose(fft(transpose(D(K_set,:))));
else
    DMf = D(K_set,:);
end
K_set = K_set-1; % restor indexing from 0

Xf = zeros(K,M);
if M1>0
    m1 = mod(-M1:-1,M)+1;
    Xf(mod(K_set-ln,K)+1,m1) = repmat(gn,K_on,1).*DMf(:,m1);
end
if M2>0
    m2 = 1:M2;
    Xf(mod(K_set+lp,K)+1, m2) = Xf(mod(K_set+lp,K)+1, m2) + repmat(gp,K_on,1).*DMf(:,m2);
end
end
