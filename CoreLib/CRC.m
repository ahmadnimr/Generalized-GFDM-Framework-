function [ r, y ] = CRC( x, g )
% x: input bits index zero is MSB
% g: polynomial index zero is MSB
% r: reminder  index zero is MSB
% y: div index zero is MSB
K = length(x);
Q = length(g);

r = zeros(1,Q);
y = zeros(1,K); % div result is already in MSB first
% reverse g for indexing 
g = flip(g); 
for m=1:K
y(m) = xor(r(Q),x(m));     
for q=Q:-1:2
    r(q) = xor(r(q-1), and(g(q), y(m)));
end    
r(1) = and(g(1),y(m));
end
% to store in MSB 
r = flip(r);
end

