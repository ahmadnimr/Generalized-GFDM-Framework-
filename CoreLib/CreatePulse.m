% For creating conventional GFDM pulse shapes
function ps = CreatePulse
ps.FuncRC = @FuncRC;
ps.FuncXia = @FuncXia;
ps.Func0 = @Func0;
ps.ISIFree = @ISIFree;
ps.ISIFreeMatched = @ISIFreeMatched;
ps.Cond = @Cond;
ps.CondTh = @CondTh;
ps.NeTh = @NeTh;
ps.IfTh = @IfTh;
ps.IfApprox = @IfApprox;
ps.Psd = @Psd;
ps.Capacity = @Capacity;
ps.TEST = @TEST;
end
function y = FuncRC(x)
%y = -sign(x).*abs(sin(pi/2*x)).^(2);
y =-sin((pi/2*x));
end
function y = FuncXia(x)
y = x;
end
function y = Func0(x)
y = zeros(size(x)) ;
end

function [g_t, g_f, f_m] = ISIFree(K, M, alpha,Func,type, shift )
%K: number of samples per (sub)symbol, M: number of (sub)symbols
% alpha: roll-off factor
% Func: increasing function from -1 to 1;
% shift sampling shift
N = K*M;
%alpha;
f=(-1/2:1/N: (1/2-1/N))'+shift/N;
g_f = zeros(length(f),1);
ind = abs(f)<= (1-alpha)/(2*K);
g_f(ind) = 1;
ind = ((abs(f)> (1-alpha)/(2*K))& (abs(f) <= (1+alpha)/(2*K)));
f1 = f(ind);
if(strcmp(type, 'complex'))
    g_f(ind)= 1/2*(1+exp(1j*pi/2*sign(f1).*(Func(2*K/alpha*(abs(f1)-1/(2*K)))+1)));
else
    g_f(ind)= 1/2*(1+Func(2*K/alpha*(abs(f1)-1/(2*K))));
end
g_f = sqrt(N)*g_f/norm(g_f);
g_f = fftshift(g_f);
g_t = ifft(g_f);
f_m = 2*g_f(1:M)-1;
end

function [g_t, g_f, f_m] = ISIFreeMatched(K, M, alpha,AFunc,PhFunc,phaseIndex, shift )
%K: number of samples per (sub)symbol, M: number of (sub)symbols
% alpha: roll-off factor
% Func: increasing function from -1 to 1;
% shift sampling shift
% phase index, 0, 1,2,3,
N = K*M;
%alpha;
f=(-1/2:1/N: (1/2-1/N))'+shift/N;
g_f = zeros(length(f),1);
ind = abs(f)<= (1-alpha)/(2*K);
g_f(ind) = 1;
ind = ((abs(f)> (1-alpha)/(2*K))& (abs(f) <= (1+alpha)/(2*K)));
f1 = f(ind);
g_f(ind)= exp(1j*sign(f1).*(pi/2*(PhFunc(2*K/alpha*(abs(f1)-1/(2*K))))+ phaseIndex/2)).*sqrt(1/2*(1+AFunc(2*K/alpha*(abs(f1)-1/(2*K)))));

g_f = fftshift(g_f);
g_t = ifft(g_f);
f_m = 2*abs(g_f(1:M)).^2-1;
end

function [cnd, Lg, Lg_Abs] = Cond(g, K,M)

GFDM_func = Create_GFDM_functions;
Lg = diag(GFDM_func.PulseToDiag(g,K,M));
Lg_Abs = abs(Lg);
cnd = max(Lg_Abs)/min(Lg_Abs);
end
function [cnd, s_max, s_min] = CondTh(M, alpha, lambda, Func, type)
% 0<= lambda <= 0.5
I = find(lambda>0.5);
lambda(I) = 1-lambda(I);
if mod(M,2)==0
    arg = 2*lambda./(alpha*M);
else
    arg = (1-2*lambda)./(alpha*M);
end
if(strcmp(type, 'ISI_complex'))    
    cnd = abs(1./tan(pi/4*Func(arg)));
    s_max = 1+cos(pi/2*Func(arg));
    s_min = 1-cos(pi/2*Func(arg));
elseif(strcmp(type, 'ISI_real'))
    cnd = abs(1./Func(arg));
    s_max = 1;
    s_min = Func(arg).^2;
elseif(strcmp(type, 'Matched'))
    s_max = 1+sqrt(1-Func(arg).^2);
    s_min = 1-sqrt(1-Func(arg).^2);
    cnd = abs(Func(arg))./(1-sqrt(1-Func(arg).^2));
end
ind = arg>1;
cnd(ind)=1;
end

function NE = NeTh(f_m, type)
if(strcmp(type, 'ISI_real'))
    bm = 0.5*(1+f_m.^2);
    NE = mean(bm)*mean(1./abs(f_m));
elseif(strcmp(type, 'Matched'))
    NE = mean(1./abs(f_m));
end
end

function IF = IfTh(f_m, type)
M = length(f_m);
if(strcmp(type, 'ISI_real'))
    am = 0.5*(1-f_m.^2);
    bm = 0.5*(1+f_m.^2);   
    IF = M*sum(bm.^2+1/2*am.^2)/(sum(bm))^2-1;
elseif(strcmp(type, 'Matched'))
   IF = 1/2-1/2*mean((f_m).^2);
end
end

function IF = IfApprox(alpha, Func, type)

f2 = @(x) Func(x).^2;
c2 = 1 - 0.5*integral(f2,-1,1); 

f4 = @(x) Func(x).^4;
c4 = 1 - 0.5*integral(f4,-1,1); 

if(strcmp(type, 'ISI_real'))
   IF = 0.5*(-2*c2^2*alpha.^2 +(6*c2-3*c4)*alpha)./(2-c2*alpha).^2;
elseif(strcmp(type, 'Matched'))
   IF = 0.5*c2*alpha;
end
end


function [px, sx] = Psd(Lg, K,M, M_set,K_set, P, shift)
if nargin <7
    shift = 0;
end
N = K * M;
GFDM_func = Create_GFDM_functions;
hlp = GFDM_func.HelperMatrices(K,M);
G =  hlp.L_M*sparse(diag(Lg))*hlp.R_M;
if shift ~= 0
    G = sparse(diag(exp(1j*2*pi*shift*(0:N-1)'/N)))*G;
end

Nfft = P*K*M;
N_set = reshape(1:K*M,K,M);
N_sub = N_set(K_set, M_set);
sx = abs(sum(G(:,N_sub),2)).^2;
px = sum(abs(fft(G(:,N_sub), Nfft)).^2,2);
end

function cap = Capacity (Lg_Abs,snr)
cap = zeros(length(snr),1);
N = length(Lg_Abs);
for n=1: length(snr)
    cap(n) = 1/N/2*sum(log2(1+Lg_Abs.^2*snr(n)));
end
end

function pass = TEST(ps)
pass = true;
    function printstatus(current, status)
        if ~status
            fprintf('%s%s\n',current, '.... Fail');
            pass = false;
        else
            fprintf('%s%s\n',current, '.... Pass');
        end
    end
current_test = ' Pulse shpae functions';
fprintf('%s%s\n',current_test, '.... Test');
M = 8;
K = 22;
shift = .3;
alpha = .4;
%M_set = 3:7;
%K_set = 1;
N = M*K;
lambda = (0.01:0.01:0.5-0.01)';
%snr = 100:10:1000;
%ps.FuncRC = @FuncRC;

[g1, g1f] = ps.ISIFree(K, M, alpha, ps.FuncRC, 'real', shift);
s_real = sum(g1f(1:M) + (g1f(N-(M-1:-1:0))));
[g2, g2f] = ps.ISIFree(K, M, alpha, ps.FuncXia, 'complex', shift);
s_comp = sum(g2f(1:M) + (g2f(N-(M-1:-1:0))));
[g, gf] = ps.ISIFree(K, M, alpha, ps.FuncRC, ps.FuncXia, shift);
s_match = sum(abs(g2f(1:M)).^2 + abs((g2f(N-(M-1:-1:0)))).^2);

status = (s_real-M<10^-10)&(s_comp-M<10^-10)&(s_match-M<10^-10);
printstatus(current_test,status);

current_test = ' test Cond number ISI free Real';
fprintf('%s%s\n',current_test, '.... Test');
cond_th = CondTh(M, alpha, lambda, ps.FuncRC, 'ISI_real');
N_lam = length(lambda);
cond_sim = zeros(N_lam,1);
for n=1:N_lam
    g = ps.ISIFree(K, M, alpha, ps.FuncRC, 'real', lambda(n));
    cond_sim(n) = ps.Cond(g, K,M);
end
diff = norm(cond_th-cond_sim);
status = diff < 10^(-10);
printstatus(current_test,status);

current_test = ' test Cond number ISI free Complex';
fprintf('%s%s\n',current_test, '.... Test');
[cond_th, s_max, s_min] = CondTh(M, alpha, lambda, ps.FuncXia, 'ISI_complex');
N_lam = length(lambda);
cond_sim = zeros(N_lam,1);
s_max0 = zeros(N_lam,1);
s_min0 = zeros(N_lam,1);

for n=1:N_lam
    [g, gf] = ps.ISIFree(K, M, alpha, ps.FuncXia, 'complex', lambda(n));
    [cond_sim(n),~, Lg_Abs] = ps.Cond(g, K, M);     
    s_max0(n) = K*max(Lg_Abs)^2;
    s_min0(n) = K*min(Lg_Abs)^2;
end

diff = norm(cond_th-cond_sim);
status = diff < 10^(-10);
printstatus(current_test,status);

figure(1)
plot(lambda, cond_th, 'blue', lambda, cond_sim, 'red');
legend('Th','Num');
title('cond numebr Xia')


current_test = ' test Cond number Matched ';
fprintf('%s%s\n',current_test, '.... Test');
[cond_th, s_max, s_min] = CondTh(M, alpha, lambda, ps.FuncRC, 'Matched');
N_lam = length(lambda);
cond_sim = zeros(N_lam,1);
s_max0 = zeros(N_lam,1);
s_min0 = zeros(N_lam,1);

for n=1:N_lam
    [g, gf] = ps.ISIFreeMatched(K, M, alpha, ps.FuncRC, ps.FuncXia, 0, lambda(n));
    [cond_sim(n),~, Lg_Abs] = ps.Cond(g, K, M);     
    % scaled singular 
    s_max0(n) = K*max(Lg_Abs)^2;
    s_min0(n) = K*min(Lg_Abs)^2;
end

diff = norm(cond_th-cond_sim);
status = diff < 10^(-10);
printstatus(current_test,status);

figure(2)
plot(lambda, cond_th, 'blue', lambda, cond_sim, 'red');
legend('Th','Num');
title('cond numebr RRC')

if(pass)
    fprintf('Test ... [passe] .. \n');
end

end
