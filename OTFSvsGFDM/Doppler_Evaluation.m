clear all;

close all;

rxType = 'MMSE';
% OTFS parameters 
Mo = 128;
Ko = 16;
No = Mo*Ko;
% Channel parameters
ChType = 'EVA';
fs = 8e6 ;
Ncp = 32;
nu_M = 0.005:0.005:0.05;
%nu_M = [0.0000:0.005:0.01];
fD = nu_M*fs/Mo;

CodeType = 'TC-1-2';
Mc = 16;


GFDM_M = [Mo, 8, Ko ];
GFDM_K = [Ko, Ko, 8];

OFDM_K = [No, Mo];

long = 1;
short = 2;
short_2 = 3;
% all GFDM and OTFS uses the Rc(0)

Wv = {'GFDM-long', 'OFDM-long', 'GFDM-short', 'OFDM-short'};
ncps = 8; % number of bit per symbols 
Nf_OTFS = [1, Ko];
Nspf = [No, Mo, Mo];

payloadSize = 2*Nspf/ncps-[8,1,1];
frame_type = {'long', 'short', 'shortT2'};

SNR = [18 20 22 ] ;
N_run1 = 100*[1 1 1; 10 10 10 ];

seed = 12345;
fpre = 'Doppler_1504_';

%% OTFS
for l_f = 2
    ChCode = GenerateCode( CodeType, payloadSize(l_f),Nspf(l_f),Mc);
    tic
    for i = 1:length(SNR)
        imp_cell{i} = OTFS_LTV_Doppler(Ko, Mo, Ncp, ChCode, N_run1(1,i), SNR(i), rxType, ChType, fs, fD, seed, Nf_OTFS(l_f));        
    disp(['OTFS' num2str([l_f, i])])
    end
    toc
    save([fpre 'OTFS-' frame_type{l_f} '-' CodeType]);
end
%% OFDM
is_OFDM = 1;
for l_f = 2
    ChCode = GenerateCode( CodeType, payloadSize(l_f),Nspf(l_f),Mc);
    tic
    for i = 1:length(SNR)
        imp_cell{i} = GFDM_LTV_Doppler(OFDM_K(l_f), 1, Ncp, ChCode, N_run1(l_f,i), SNR(i), rxType, ChType, fs, fD, seed, is_OFDM);        
       disp(['OFDM' num2str([l_f, i])])
    end
    toc
    save([fpre 'OFDM-' frame_type{l_f} '-' CodeType]);
end

%% GFDM
is_OFDM = 0;
for l_f = 2
    ChCode = GenerateCode( CodeType, payloadSize(l_f),Nspf(l_f),Mc);
    tic 
    for i = 1:length(SNR)
        imp_cell{i} = GFDM_LTV_Doppler(GFDM_K(l_f), GFDM_M(l_f), Ncp, ChCode, N_run1(l_f,i), SNR(i), rxType, ChType, fs, fD, seed, is_OFDM);        
        disp(['GFDM' num2str([l_f, i])])
    end
    toc
    save([fpre 'GFDM-' frame_type{l_f} '-' CodeType]);
end   
toc


