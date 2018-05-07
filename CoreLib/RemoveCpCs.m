%% Remove CP/CS
% Extract blocks of length N, it start counting from n0, which can be the
% CP length itself.
function Yo = RemoveCpCs( Yr, N, n0)
Yo = Yr(n0+(1:N),:);
end

