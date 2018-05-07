%% Block demultiplexing
% extract blocks of length Nt 
% it is used to separate blocks before processing
% Ns block spacing
function Yr = BlockDemultiplexing(y, Ns, No)
Nt = No+Ns;
Ny = length(y);
Nb = ceil((Ny-No)/Ns);
Yr = zeros(Nt, Nb);
for nb=0:Nb-1
    Yr(:,nb+1) =  y((1:Nt)+nb*Ns);
end
end
