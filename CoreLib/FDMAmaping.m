function Xf = FDMAmaping( Xf_in, ind, N, n0)
% Map to frequency bins
% ind: the index of the non-zero samples of Xf_in
% n0 the shift
Xf = zeros(N, size(Xf_in, 2));
Xf(mod(ind+n0,N)+1,:) = Xf_in(ind+1,:);
end

