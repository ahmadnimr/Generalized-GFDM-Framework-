function Xf = FDMAdemaping( Xf_o, ind, Nu, n0)
% Map to frequency bins
% ind: the index of the non-zero samples of Xf_in
% n0 the shift
[N, Nb] = size(Xf_o);
Xf = zeros(Nu, Nb);
Xf(ind+1,:) = Xf_o(mod(ind+n0,N)+1,:);
end

