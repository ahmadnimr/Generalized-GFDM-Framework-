clear all;
long = 1;
short = 2;
short2 = 3;

meas = cell(3,1);
code = 'CC-1-2';
pref = '.\CC\_1304_';
%pref = '.\TC\_1404_';
wv = {'OTFS-','GFDM-', 'OFDM-'};

flength = {'long-', 'short-', 'shortT2-'};

%% What to show 
frame_length = 1;
fD_index = [1, 2, 3];
nu_M = [0.0005, 0.005, 0.05, 0.1];
useFD = 1;
if ~useFD
betad = {'5\cdot 10^{-4}', '5\cdot 10^{-3}', '5\cdot 10^{-2}', '1\cdot 10^{-1}' };
else
betad = {' $$31.25~\mbox{Hz}$$', '$$312.5~\mbox{Hz}$$', ' $$3125~~\mbox{Hz}$$', '$$6250~~\mbox{Hz}$$' };
end
wv_index = [1, 2, 3];
wv_leg = {'OTFS$$~$$ ', 'GFDM ', 'OFDM '};

ylable = 'BER';

cols_set = {'b','r','k'};
mark_set = {'+','o','*','d'};

titl = [flength{min(frame_length,2)} code];

xlable = '$$ E_s/N_0$$ [dB]';

N_SNR = 10;
%%%%%%%%%%%%% Data collection
for Wv_i =1:3
    if Wv_i ~=2 && frame_length == 3
        fname = [pref wv{Wv_i} flength{2} code ];
    else
        fname = [pref wv{Wv_i} flength{frame_length} code ];
    end
    load(fname);
    meas{Wv_i} = imp_cell;
end

close all;
fig = figure(1);

x = SNR(1:N_SNR);

NfD = length(fD_index);

Nwf = length(wv_index);
Leg_cell = cell(NfD*Nwf,1);
cols = cell(NfD*Nwf,1);
mark = cell(NfD*Nwf,1);
Y = zeros(N_SNR,NfD*Nwf);

for i=0:Nwf-1
    for j=1:NfD
        
        imp_cell = meas{wv_index(i+1)}{fD_index(j)}{1};
        if ~useFD
            lgname = '$$(\beta_d = ';
        else
            lgname = '($$f_d =$$ ';
        end
        Leg_cell{j+i*NfD} = [wv_leg{wv_index(i+1)} lgname betad{fD_index(j)} ')'];
        
        cols{j+i*NfD} = cols_set{wv_index(i+1)};
        mark{j+i*NfD} = mark_set{fD_index(j)};
        if strcmp(ylable, 'BER')
            Y(:,j+i*NfD) = imp_cell.CodedBER(1:N_SNR);
            type = 'semilog' ;
        elseif strcmp(ylable, 'FER')
            Y(:,j+i*NfD) = imp_cell.FER(1:N_SNR);
            type = 'semilog' ;
        elseif strcmp(ylable, 'NMSE')
            type = 'lin' ;
            
            Y(:,j+i*NfD) = imp_cell.SymbolNMSE(1:N_SNR);
        end
    end
end

xrang = [x(1), x(end)];
[~,ax] = CompareMeasure( Y, x, Leg_cell,xlable, ylable, titl, xrang, fig,type,cols,mark );

%% Configiure view area 
ax.Title.Visible = 'off';
ax.Position = [0.12, 0.12, 0.865,.855];
%ax.Title.Position = [-4.7,18];

if strcmp(ylable, 'BER')
    if frame_length == 1
    ax.YLim = [2e-5,5e-1];
    else
        ax.YLim = [2e-5,2e-1];
    end
elseif strcmp(ylable, 'FER')
    if frame_length == 1
    ax.YLim = [8e-3,1];
    else
        ax.YLim = [5e-4,1];
    end
end

%fig.Position = [0, 0, 1200, 600 ];

%% Save file
flength = {'long', 'short', 'shortT2-'};

%saveas(fig, [flength{frame_length}, '_MMSE_' ylable '.eps'],'epsc' )
