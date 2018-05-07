% Get the modulation matrix of GFDM in the freuency domain
function Af = ModulationMatrixFrequency( gf, K, M, K_set, M_set)
Non = numel(K_set)*numel(M_set);
N = M*K;
Af = zeros(N,Non);
ind_n = (0:N-1)';
n = 1;
for m = M_set-1
    for k = K_set-1
        Af(:, n)= gf(mod(ind_n-k*M,N)+1).*exp(-1j*2*pi*m*ind_n/M);
        n = n+1;
    end
end

end

