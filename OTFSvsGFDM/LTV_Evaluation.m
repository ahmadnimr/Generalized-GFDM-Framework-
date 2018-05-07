
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
nu_M = [0.0005, 0.005, 0.05];
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


SNR = 4:2:24;
N_run1 = 0;
tic

seed = 12345;
fpre = 'LTV_1504_';

%% OTFS
for l_f =1:2
    ChCode = GenerateCode( CodeType, payloadSize(l_f),Nspf(l_f),Mc);
    tic
    for i = 1:length(fD)
        imp_cell{i} = OTFS_LTV(Ko, Mo, Ncp, ChCode, N_run1, SNR, rxType, ChType, fs, fD(i), seed, Nf_OTFS(l_f));
    end
    toc
    disp(['OTFS' num2str([l_f, i])])
    save([fpre 'OTFS-' frame_type{l_f} '-' CodeType]);
end
%% OFDM
is_OFDM = 1;
for l_f =1:2
    ChCode = GenerateCode( CodeType, payloadSize(l_f),Nspf(l_f),Mc);
    tic
    for i = 1:length(fD)
        imp_cell{i} = GFDM_LTV(OFDM_K(l_f), 1, Ncp, ChCode, N_run1, SNR, rxType, ChType, fs, fD(i), seed, is_OFDM);
    end
    disp(['OFDM' num2str([l_f, i])])
    toc
    save([fpre 'OFDM-' frame_type{l_f} '-' CodeType]);
end

%% GFDM
is_OFDM = 0;
for l_f =1:2
    ChCode = GenerateCode( CodeType, payloadSize(l_f),Nspf(l_f),Mc);
    tic
    for i = 1:length(fD)
        imp_cell{i} = GFDM_LTV(GFDM_K(l_f), GFDM_M(l_f), Ncp, ChCode, N_run1, SNR, rxType, ChType, fs, fD(i), seed, is_OFDM);
    end
    disp(['GFDM' num2str([l_f, i])])
    toc
    save([fpre 'GFDM-' frame_type{l_f} '-' CodeType]);
end
