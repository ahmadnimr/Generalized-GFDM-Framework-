%% Resource Demap
% extract allocated data
function d = ResourceDemap(D, K_set, M_set)
K_on = length(K_set);
M_on = length(M_set);
d = reshape(D(K_set, M_set), M_on*K_on,1);
end
