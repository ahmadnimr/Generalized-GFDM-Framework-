%% PSD estimatin
% of signal x with window Nw
function [Sx, f] = PSD_Estimation( x, Nw)
%PSD_ESTIMATION Summary of this function goes here
%   Detailed explanation goes here
f = (0:Nw-1)'./Nw;
NT = floor(length(x)/Nw);
X = zeros(Nw,NT);
X(1:length(x)) = x;
Xf = abs(fft(X)).^2;
Sx = mean(Xf,2)/Nw;
end

