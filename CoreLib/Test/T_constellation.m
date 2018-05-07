Mc = 16;
m = log2(Mc);
S = GrayCode(Mc);

diff = zeros(Mc,1);
for i=0:Mc-1
    diff(i+1) = sum(S(mod(i,Mc)+1,:)~=S(mod(i+1,Mc)+1,:));
end
pw = 2.^(0:m-1)';
ind = (~S)*pw;

const = QAMConstellation(Mc)