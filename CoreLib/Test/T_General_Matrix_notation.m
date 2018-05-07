%% Test parameters
K = 32;
K_set = 1:3:K;
Ku = length(K_set);
M = 16;
N = M*K;

% pulse shape
g = randn(N,1)+1j*randn(N,1);
gf = fft(g,N);

% DFt matricea
FM = dftmtx(M);
FK = dftmtx(K);
FN = dftmtx(N);
% Windows 
% ZAK transform time
Zgt = transpose(FM* reshape(g,K,M).');
% ZAK transform Frequency
Zgf = 1/K*FK'* reshape(gf,M,K).';

% random data
D = zeros(K,M);
D(K_set,:) = randn(Ku,M)+1j*randn(Ku,M);

% reference signal 
xref = ref_GFDM_Mod(D,g,K,M);

%% Test matrix 
%1. precoding 

Ds = 1/K*FK'*D*FM;

%------- time domain generation
% 2. windowing
% time                     % freq
Xt = K*Zgt.*Ds;           Xf = K*Zgf.*Ds;
% 3. transformation 
% time                     % freq
VxMK = 1/M*FM'*Xt.';     VxfKM = FK*Xf;
% 4. allocation
% time                     % freq
x = reshape(VxMK.',N,1); xf =  reshape(VxfKM.',N,1);

% DFT for                 % freq
                          xft = 1/N*FN'*xf;
%% Error check 

err = norm(xref-x);
disp(['error time-domain - ref ' num2str(err)]);

err = norm(xref-xft);
disp(['error frequency-domain - ref ' num2str(err)]);

