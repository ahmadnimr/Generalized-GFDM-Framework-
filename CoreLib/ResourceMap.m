%% Resource Map
% map data to the big allocation matrix 
% indexing must be from 1, 
function D = ResourceMap(d, K_set, M_set, K,M)
% The allocation is with respect to subcarriers.
D = zeros(K,M);
K_on = length(K_set);
M_on = length(M_set);
D(K_set, M_set) = reshape(d, K_on, M_on);
end

