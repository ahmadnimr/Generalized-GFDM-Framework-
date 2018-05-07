
clear all;
clear all;
long = 1;
short = 2;
short2 = 3;

meas = cell(3,1);
pref = '.\CC\_1304_';
wv = {'OTFS-','GFDM-', 'OFDM-'};
code = 'CC-1-2';
flength = {'long-', 'short-', 'shortT2-'};

%% What to show
frame_length = 1;
fD_index = 4;
SNR_ind = 8;

nu_M = [0.0005, 0.005, 0.05, 0.1];
useFD = 1;
if ~useFD
    betad = {'5\cdot 10^{-4}', '5\cdot 10^{-3}', '5\cdot 10^{-2}', '1\cdot 10^{-1}' };
else
    betad = {' $$31~\mbox{Hz}$$', '$$312\mbox{ Hz}$$', ' $$3.1\mbox{ KHz}$$', '$$6.2\mbox{KHz}$$' };
end
wv_index =  [3,2,1];
wv_leg = {'OTFS$$~$$ ', 'GFDM ', 'OFDM '};


cols_set = {'b','r','k'};
mark_set = {};

%titl = [flength{min(frame_length,2)} code];

xlable = 'Symbol index $$ n $$';

ylable = 'SNR [dB]';

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
Ns = 2048;
x = 1:Ns;

NfD = length(fD_index);

Nwf = length(wv_index);
Leg_cell = cell(NfD*Nwf,1);
cols = cell(NfD*Nwf,1);
mark = cell(NfD*Nwf,1);
Y = zeros(Ns,NfD*Nwf);

for i=0:Nwf-1
    for j=1:NfD
        
        imp_cell = meas{wv_index(i+1)}{fD_index(j)}{1};
        if ~useFD
            lgname = '$$(\beta_d = ';
        else
            lgname = '($$f_d =$$ ';
        end
        Leg_cell{j+i*NfD} = [wv_leg{wv_index(i+1)}];
        
        cols{j+i*NfD} = cols_set{wv_index(i+1)};
        %mark{j+i*NfD} = mark_set{fD_index(j)};
        
        Y(:,j+i*NfD) = -imp_cell.PerSymbolNMSE(1:Ns,SNR_ind);
        
        type = 'lin' ;

    end
end
if ~useFD
    lgname = '($$\beta_d = ';
else
    lgname = '($$f_d =$$';
end
titl = [lgname betad{fD_index} ', $$E_s/N_0 =' num2str(SNR(SNR_ind)) ' \mbox{ dB} $$'];

xrang = [x(1), x(end)];
[~,ax] = CompareMeasure( Y, x, Leg_cell,xlable, ylable, titl, xrang, fig,type,cols,[] );

%% Configiure view area
ax.Title.Visible = 'on';
ax.Position = [0.12, 0.12, 0.865,.855];

%ax.Title.Position = [-4.7,18];
if strcmp(ylable, 'BER')
    ax.YLim = [1e-5,5e-1];
elseif strcmp(ylable, 'FER')
    ax.YLim = [1e-3,1];
end

%fig.Position = [0, 0, 1200, 600 ];

%% Save file
saveas(fig, 'perSymSNR.eps','epsc' )
