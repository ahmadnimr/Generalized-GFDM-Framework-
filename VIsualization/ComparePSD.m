function [psd_plot] =  ComparePSD( Af_cell, Leg_cell, U, M, R, fig, xrang)
% R resolution R/N
% M subcarrier spacing in samples
% U upsampling 

Nw = length(Af_cell);
[N, Non] = size(Af_cell{1});
NU = N*U;
n_in = -N/2:N/2-1;
S = zeros(NU*R,Nw);
for nw = 1: Nw 
    AfU = zeros(NU, Non);
    % upsampling considering FFT interpolation which is accurate if 
    AfU(mod(n_in, NU)+1,:) =  Af_cell{nw}(mod(n_in, N)+1,:);
    AU = sqrt(U)*ifft(AfU);
    S(:,nw) = 10*log10(fftshift(Psd_th( AU, R)));
end
k=((0:U*R*N-1)-U*R*N/2)/M/R; % subcarrier index
K = N/M;
% figure settings
cols = {'b','r','m','k'};
ax = axes('Parent', fig);
width = 1;
fsize = 14;
fname = 'Times New Roman';
psd_plot = plot(k,S, 'Parent',ax,'LineWidth', width);
set(ax,'FontSize',fsize,'FontName','Times New Roman');
ax.Position = [0.105, 0.130, .88,.87];
for nw = 1: Nw 
    psd_plot(nw).Color = cols{mod(nw-1,4)+1};
     
end
grid(ax,'on');
ax.XLim = xrang;
ax.XTick = xrang(1):xrang(2);   
ax.YLim = [-80,1];
legend(ax,Leg_cell,'FontName',fname);   
ax.XLabel = xlabel(ax,'Subcarrier index ','FontName',fname); 
ax.YLabel = ylabel (ax,'PSD[dB]','FontName',fname);
ax.FontSize = fsize;



