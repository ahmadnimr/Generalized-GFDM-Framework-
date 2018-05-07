function [meas_plot, ax] =  CompareMeasure( Y, x, Leg_cell,xlable, ylable, titl, xrang, fig, type, cols, mark)
Nw = size(Y,2);
x = x(:);
% figure settings

ax = axes('Parent', fig);
width = 1;
fsize = 14;
fname = 'Times New Roman';
if strcmp(type, 'semilog')
    meas_plot = semilogy(x,Y, 'Parent',ax,'LineWidth', width);
else
    meas_plot = plot(x,Y, 'Parent',ax,'LineWidth', width);
end
set(ax,'FontSize',fsize,'FontName','Times New Roman');

for nw = 1: Nw
    meas_plot(nw).Color = cols{mod(nw-1,Nw)+1};    
    if ~isempty(mark )    
      meas_plot(nw).Marker = mark{mod(nw-1,Nw)+1}; 
    end
end
grid(ax,'on');
ax.XLim = xrang;
legend(ax,Leg_cell,'FontName',fname,'Interpreter', 'latex' ,'Location','southwest');
ax.XLabel = xlabel(ax, xlable,'FontName',fname,'Interpreter', 'latex');
ax.YLabel = ylabel (ax,ylable,'FontName',fname,'Interpreter', 'latex');
ax.Title = title (ax,titl,'FontName',fname,'Interpreter', 'latex');

ax.Title.Rotation = 0;
ax.Title.HorizontalAlignment = 'left';
ax.FontSize = fsize;
ax.GridAlpha = 0.05;
ax.GridColor = [.08 .08 .08];


