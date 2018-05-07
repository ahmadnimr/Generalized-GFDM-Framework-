%% Generate Fading channels
% ChType = EPA, EVA, TGn, FLAT
function rchan = GenFadingChannel( ChType, fD, fs)
%GENFADINGCHANNEL Summary of this function goes here
%   Detailed explanation goes here
EPAT = [0, 30, 70, 90, 110, 190, 410]*1E-9;
EVAT = [0, 30, 150, 310, 370, 710, 1090, 1730, 2510]*1E-9;

EPAP = [0, -1, -2, -3, -8, -17.2, -20.8];
EVAP = [0, -1.5, -1.4, -3.6, -0.6, -9.1, -7.0, -12.0 -16.9];

tau = [0 10 20 30 40 50 60 70 80]*1e-9;   % Path delays, in seconds

% Average path gains of cluster 1, in dB
pdb1 = [0 -5.4 -10.8 -16.2 -21.7 -inf -inf -inf -inf];
% Average path gains of cluster 2, in dB
pdb2 = [-inf -inf -3.2 -6.3 -9.4 -12.5 -15.6 -18.7 -21.8];
% Total average path gains for both clusters, in dB
pdb = 10*log10(10.^(pdb1/10) + 10.^(pdb2/10));

switch ChType
    case 'EPA'
        pathDelays = EPAT;
        avgPathGains = EPAP;
    case 'EVA'
        pathDelays = EVAT;
        avgPathGains = EVAP;
    case 'TGn'
         pathDelays = tau;
        avgPathGains = pdb;
    otherwise
        pathDelays = 0;
        avgPathGains = 1;
end
rchan = comm.RayleighChannel('SampleRate',fs, ...
    'PathDelays',pathDelays, ...
    'AveragePathGains',avgPathGains, ...
    'MaximumDopplerShift',fD,...
    'RandomStream','mt19937ar with seed', ...
    'Seed',22);
end