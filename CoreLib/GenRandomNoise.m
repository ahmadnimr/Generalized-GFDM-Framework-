%% Generate Gaussian noise 
% N0: white noise variance
function v = GenRandomNoise(siz, N0)
v = sqrt(N0/2) * (randn(siz)+1j*randn(siz));
end
