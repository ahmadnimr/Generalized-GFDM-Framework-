function g = Filter(K,M,alpha)
if mod(M,2) == 0
shift = 0.5;
else
shift = 0.0;
end
N = K*M;
%alpha;
f=(-1/2:1/N: (1/2-1/N))'+shift/N;
g_f = zeros(length(f),1);
ind = abs(f)<= (1-alpha)/(2*K);
g_f(ind) = 1;
ind = ((abs(f)> (1-alpha)/(2*K))& (abs(f) <= (1+alpha)/(2*K)));
f1 = f(ind);
 g_f(ind)= 1/2*(1-sin(pi/2*(2*K/alpha*(abs(f1)-1/(2*K)))));
g_f = fftshift(g_f);
g = ifft(g_f);

end

