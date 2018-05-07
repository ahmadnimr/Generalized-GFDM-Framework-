%% CP/CS insertion
% $$ X = X_0(<n-N_{cp}>_N,:),~ n = 0,\cdots, N+N_{cp}+N_{cs}-1  $$
function X = AddCpCs( X0, N, Ncp, Ncs)
No = Ncp+ Ncs;
Nt = N+No;
nt = 0:Nt-1;
X = X0(mod(nt-Ncp, N)+1,:);
end

