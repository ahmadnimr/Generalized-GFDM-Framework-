clear all;
long = 1;
short = 2;
short2 = 3;

meas = cell(3,1);
pref = 'TC/Doppler_1504_';
%pref = 'CC/Doppler_1404_';
wv = {'OTFS-','GFDM-', 'OFDM-'};
code = 'TC-1-2';
flength = {'long-', 'short-', 'shortT2-'};

%% What to show 
frame_length = 2;
SNR = [18 20 22 ] ;
snr_index = [1, 3];
nu_M = [0.0005, 0.005, 0.05, 0.1];
useFD = 1;

snr_leg = {'($$18$$ dB)', '($$20$$ dB)', '($$22$$ dB)' };

wv_index = [1, 2, 3];
wv_leg = {'OTFS$$~$$ ', 'GFDM ', 'OFDM '};

ylable = 'FER';

cols_set = {'b','r','k'};
mark_set = {'+','o','*','d'};

titl = [flength{min(frame_length,2)} code];

xlable = '$$ f_D$$ [Hz]';

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

NfD = length(fD);
x = fD(1:NfD);
Nsnr = length(snr_index);


Nwf = length(wv_index);
Leg_cell = cell(Nsnr*Nwf,1);
cols = cell(Nsnr*Nwf,1);
mark = cell(Nsnr*Nwf,1);
Y = zeros(NfD,Nsnr*Nwf);

for i=0:Nwf-1
    for j=1:Nsnr
        
        imp_cell = meas{wv_index(i+1)}{snr_index(j)}{1};     
        Leg_cell{j+i*Nsnr} = [wv_leg{wv_index(i+1)}  snr_leg{snr_index(j)} ')'];
        
        cols{j+i*Nsnr} = cols_set{wv_index(i+1)};
        mark{j+i*Nsnr} = mark_set{snr_index(j)};
        if strcmp(ylable, 'BER')
            Y(:,j+i*Nsnr) = imp_cell.CodedBER(1:NfD);
            type = 'semilog' ;
        elseif strcmp(ylable, 'FER')
            Y(:,j+i*Nsnr) = imp_cell.FER(1:NfD);
            type = 'semilog' ;
        elseif strcmp(ylable, 'NMSE')
            type = 'lin' ;
            
            Y(:,j+i*Nsnr) = imp_cell.SymbolNMSE(1:NfD);
        end
    end
end

xrang = [x(1), x(end)];
[~,ax] = CompareMeasure( Y, x, Leg_cell,xlable, ylable, titl, xrang, fig,type,cols,mark );

%% Configiure view area 
ax.Title.Visible = 'off';
ax.Position = [0.12, 0.12, 0.865,.855];
ax.Legend.Location = 'southeast';
%fname = 'Times New Roman';
%lgd = legend('line1','line2','line3');
% [lgd,icons,plots,txt] =legend(ax,Leg_cell,'FontName',fname,'Interpreter', 'latex' ,'Location','southwest');
% for n = 4:9
%     icons(n).Visible = 'off';
% end
% for n = 10:2:27
%     icons(n).Visible = 'off';
% end
%ax.Title.Position = [-4.7,18];
% if strcmp(ylable, 'BER')
    ax.YLim = [1e-4,2e-1];
% elseif strcmp(ylable, 'FER')
%     ax.YLim = [1e-4,1];
% end

%fig.Position = [0, 0, 1200, 600 ];

%% Save file
saveas(fig, ['Doppler_FER.eps'],'epsc' )
