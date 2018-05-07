%% Windowing 
% Window over symbol 
% N_Cs length of Cs used for edges of the window.
function X = Windowing(X, w, Ncs)
Nb = size(X,2);
% Widow works only on the edges
for nb=1:Nb
    X(1:Ncs,nb) = w(1:Ncs).*X(1:Ncs,nb);
    X(end+1-(1:Ncs),nb) = w(end+1-(1:Ncs)).*X(end+1-(1:Ncs),nb);
end
end