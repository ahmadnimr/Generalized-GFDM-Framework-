fs = 30.72e6;
fs = 40e6;
fD = 300;
L = 192;
ChType = 'EVA';
rchan = GenFadingChannel( ChType, fD, fs);
L= 41;
x = zeros(L,1);
x(1) = 1;
H = zeros(L,1000);
for i = 1:1000   
H(:,i) = genChannel(rchan, L);
end

N = 64*16;
Hf = mean(abs(fft(H,N).^2),2);
plot(Hf);


function h = genChannel(rchan, L)
x = zeros(L,1);
x(1) = 1;
    reset(rchan);
    release(rchan);
    % change the seed to get different realization
    rchan.Seed = rchan.Seed+1;
   h = step(rchan, x);
end