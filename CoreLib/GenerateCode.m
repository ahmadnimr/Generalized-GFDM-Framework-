%% Generate chanel coding structure
% Mc: QAM Modulation length 
% active data
% payload size in Bytes
% Code type = 'CC-1-2', 'CC-2-3', 'CC-3-4', 'CC-5-6' : Convolution
% Code type = 'TC-1-2', 'TC-2-3', 'TC-3-4', 'TC-5-6' : Turbo
% all parameters related are geneaten internally 
% random interleavers are used
% punctures are used
% sdeed is used to for random interleaver 
function ChCode = GenerateCode( CodeType,Payload_size,Non,Mc, seed )
if nargin < 5
    seed = 199;
end
% Nf : number of frames 
bps = log2(Mc);
if Mc == 4
    ChCode.Constellation  = CreateConstellation( 'QAM', Mc);
else
    ChCode.Constellation = CreateConstellation( 'QAM', Mc,'gray');
end
ChCode.Constellation = reshape(ChCode.Constellation,numel(ChCode.Constellation),1);
ChCode.Non = Non;
ChCode.bps = bps;
ChCode.g           = [1 0 1 1 0 1 1; 1 1 1 1 0 0 1]; %133 171
ChCode.nsc_flag    = 1;
ChCode.Nr_infobits = Payload_size*8 ;

% Turbo LTE
ChCode.Turbo_g = [1,0,1,1; 1,1,0,1]; %13 15 
ChCode.Turbo_nsc_flag = 0;
ChCode.Turbo_pun_pattern = [1; 1; 0; 0]; % rate 1/2;
ChCode.Turbo_tail_pattern = ones(4,3);
ChCode.Turbo_interleaver = CreateLTEInterleaver(ChCode.Nr_infobits);

%hSCR      = comm.Scrambler(2, [1 0 0 0 1 0 0 1],[1 0 1 1 1 0 1]);
%hDSCR     = comm.Descrambler(2, [1 0 0 0 1 0 0 1],[1 0 1 1 1 0 1]);
%scr_seq   = step(hSCR, zeros(Nr_infobits,1));
%scr_seq   = scr_seq';
ChCode.CodeType = CodeType;
rate = CodeType(end-3+1:end);
alg = ChCode.CodeType(1:2);
switch alg
    case 'CC'
        ChCode.Alg  = 0; % convolutional 
    case 'TC'
        ChCode.Alg  = 1; % turbo 
      otherwise
        warning('Unexpected Coding type.')
end
switch rate
    case '1-2'
        Nbit_per_block  = Non*bps/2;
    case '2-3'
        Nbit_per_block  = Non*bps/3*2;
    case '3-4'
        Nbit_per_block  = Non*bps/4*3;
    case '5-6'
        Nbit_per_block = Non*bps/6*5;
    otherwise
        warning('Unexpected Coding Rate.')
end
% 6: is the constraint number. I.e. number of shift registers.
cnst = size(ChCode.g,2)-1;
Nb  = ceil((ChCode.Nr_infobits+cnst)/Nbit_per_block);
ChCode.Nb = Nb;
% to fix numeric precesion error
ChCode.Nr_padbits = Nb*Nbit_per_block - ChCode.Nr_infobits;
Nr_unpuncbits     = (ChCode.Nr_infobits + ChCode.Nr_padbits)*2;
switch rate
    case '1-2'
        ChCode.punc_flg   = ones(1,Nr_unpuncbits);
    case '2-3'
        ChCode.punc_flg   = ones(1,Nr_unpuncbits);
        ChCode.punc_flg(4:4:end) = 0;
    case '3-4'
        ChCode.punc_flg   = ones(1,Nr_unpuncbits);
        ChCode.punc_flg(3:6:end) = 0;
        ChCode.punc_flg(5:6:end) = 0;
    case '5-6'
        ChCode.punc_flg   = ones(1,Nr_unpuncbits);
        ChCode.punc_flg(4:10:end) = 0;
        ChCode.punc_flg(5:10:end) = 0;
        ChCode.punc_flg(8:10:end) = 0;
        ChCode.punc_flg(9:10:end) = 0;
    otherwise
        warning('Unexpected Coding Scheme.')
end
Ncbpsym           = Non*bps;
ChCode.Ncbpsym = Ncbpsym;
rng(seed); % to keep the interleaver 
ChCode.interleaver1 = randperm(Ncbpsym);
ChCode.interleaver2 = randperm(Ncbpsym);
ChCode.decoder_type = 2;
ChCode.demod_type = 2;
ChCode.info_bits = zeros(ChCode.Nr_infobits,1);
ChCode.number_itr = 20;
 % the decoder type
%              = 0 For linear-log-MAP algorithm, i.e. correction function is a straght line.
%              = 1 For max-log-MAP algorithm (i.e. max*(x,y) = max(x,y) ), i.e. correction function = 0.
%              = 2 For Constant-log-MAP algorithm, i.e. correction function is a constant.
%              = 3 For log-MAP, correction factor from small nonuniform table and interpolation.
%              = 4 For log-MAP, correction factor uses C function calls.
end

