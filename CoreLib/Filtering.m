%% Filter on Block
% filter the wole block (filtering might include CP)
function Xh = Filtering(X, h)
[Nt, Nb] = size(X);
Nh = length(h)+Nt-1;
Xh = zeros(Nh,Nb);
for nb=1:Nb
    Xh(:,nb) = conv(h,X(:,nb));
end
end