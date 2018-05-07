g = [0,0,1,1,0,0,0,1];
x = [1 0 0 0 1 1 1 1 1 0 0 0 1 1 1 1];

[r, y] = CRC(x, g);

Q = length(g);
Ug = toint([1,g])
Ux = toint([x,zeros(1,Q)])
Ux1 = toint([x, zeros(1,Q)])

Ur = toint(r)
Uy = toint(y)

dm = floor(Ux/Ug)
rm = mod(Ux,Ug)
r1 = mod(Ux,Uy)
function val = toint(x)
% MSB first 
N = length(x);
x = reshape(x, 1,N);
val = sum(x.*2.^(N-1:-1:0));
end