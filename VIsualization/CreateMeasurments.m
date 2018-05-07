%% Measurmet structure
% all functions related to measurments 
function measure = CreateMeasurments()
measure.CodedERR = 0;
measure.CodedLength = 0;
measure.FrameERR = 0;
measure.FrameCount = 0;
measure.UnCodedError = 0;
measure.UnCodedLength = 0;
measure.SymbolError = 0;
measure.SymbolPower = 0;
measure.SamplePower = 0;
measure.SampleError = 0;
measure.NB = 0; % number of blocks

%% functions
measure.Measure = @Measure;
measure.AverageAndConcatenate = @AverageAndConcatenate;
measure.Concatenate = @Concatenate;
end
% phy: PHY structure 
% TX: structure
% RX: structure
% collect successive measurements in each iteration
% This function to be called after each iteration
function measure = Measure(measure,params,Tx, Rx)

N_useful = params.N_useful ; % only the useful FD samples
Nb =  params.Nb; % number of blocks per iteration
N_frame = size(Tx.InfoBits, 2);
codedError_frame  = sum(Tx.InfoBits~=Rx.InfoBits);
codedError  = sum(codedError_frame);
measure.CodedERR = measure.CodedERR + codedError;
measure.CodedLength = measure.CodedLength + numel(Rx.InfoBits);

measure.FrameERR = measure.FrameERR + sum(codedError_frame > 0);
measure.FrameCount = measure.FrameCount + N_frame;

uncodedError = sum(sum(Tx.EncodedBits~=Rx.EncodedBits));
measure.UnCodedError = measure.UnCodedError + uncodedError;
measure.UnCodedLength = measure.UnCodedLength + numel(Rx.EncodedBits);


measure.SymbolError = measure.SymbolError+ sum(abs(Tx.Symbols-Rx.Symbols).^2,2);
measure.SymbolPower = measure.SymbolPower+ sum(abs(Tx.Symbols).^2,2);

measure.NB = measure.NB + Nb;
measure.SamplePower = measure.SamplePower+ sum(abs(Tx.Xf(N_useful,:)).^2,2);
measure.SampleError = measure.SampleError+ sum(abs(Tx.Xf(N_useful,:)-Rx.Xf(N_useful,:)).^2,2);

end
% Average over all iterations
function measureAvg = Average(measure)
% Error rate
measureAvg.CodedBER = measure.CodedERR/measure.CodedLength;
measureAvg.BER = measure.UnCodedError/measure.UnCodedLength;
measureAvg.FER = measure.FrameERR/measure.FrameCount;

% NMSE for symbols
measureAvg.PerSymbolNMSE = 10*log10(measure.SymbolError./measure.SymbolPower);
measureAvg.SymbolNMSE  = 10*log10(sum(measure.SymbolError)/sum(measure.SymbolPower));
% SINR
measureAvg.PerSampleSINR = 10*log10(measure.SamplePower./measure.SampleError);
measureAvg.AverageSINR = 10*log10(sum(measure.SamplePower)/sum(measure.SampleError));

% sample and noise power
measureAvg.SamplePower = measure.SamplePower/measure.NB;
measureAvg.SampleError = measure.SampleError/measure.NB;
% symbol power and symbol power error
measureAvg.SymbolError = measure.SymbolError/measure.NB;
measureAvg.SymbolPower = measure.SymbolPower/measure.NB;
% Average symbol power and symbol error
measureAvg.AverageSymbolError = mean(measureAvg.SymbolError);
measureAvg.AverageSymbolPower = mean(measureAvg.SymbolPower);

end
% Create averege structure. It contains only necessary info
% N_meas: number of meas points, eg. SNR
% N_symbol: number of data symbols 
% N_sample: number of useful samples
function measureAvg =  CreateAverageMeasurments(N_sample, N_symbol, N_meas)
measureAvg.CodedBER = zeros(N_meas,1);
measureAvg.BER = zeros(N_meas,1);
measureAvg.FER = zeros(N_meas,1);

measureAvg.PerSymbolNMSE =  zeros(N_symbol,N_meas);
measureAvg.SymbolNMSE = zeros(N_meas,1);

measureAvg.PerSampleSINR =  zeros(N_sample,N_meas);
measureAvg.AverageSINR = zeros(N_meas,1);
measureAvg.SamplePower = zeros(N_sample,N_meas);
measureAvg.SampleError = zeros(N_sample,N_meas);
measureAvg.SymbolError = zeros(N_symbol,N_meas);
measureAvg.SymbolPower = zeros(N_symbol,N_meas);
measureAvg.AverageSymbolPower =  zeros(N_meas,1);
measureAvg.AverageSymbolError =  zeros(N_meas,1);

end

% Average and concatenate cell of measurments 
% measureCell 0f size (N_mth: different  methods) (N_mease: range of values. e.g SNR)
% concatenation over second dimension
% output: cell of length N_mth
function measureMeth = AverageAndConcatenate(measureCell)
[N_mth, N_meas] = size(measureCell); % method and snr, cfo, etc

N_sample = length(measureCell{1,1}.SamplePower);
N_symbol = length(measureCell{1,1}.SymbolPower);

for mth = 1:N_mth
    measureAvg = CreateAverageMeasurments(N_sample, N_symbol, N_meas);
    measureMeth{mth} = measureAvg;
end
% do concatenation
for mth = 1:N_mth
    for n_meas = 1:N_meas
        measureAvg = Average(measureCell{mth,n_meas});
        
        measureMeth{mth}.CodedBER(n_meas,1) = measureAvg.CodedBER;
        measureMeth{mth}.BER(n_meas,1) = measureAvg.BER;
        measureMeth{mth}.FER(n_meas,1) =  measureAvg.FER;
        
        measureMeth{mth}.PerSymbolNMSE(:,n_meas) = measureAvg.PerSymbolNMSE;
        measureMeth{mth}.SymbolNMSE(n_meas,1) =  measureAvg.SymbolNMSE ;
        
        measureMeth{mth}.PerSampleSINR(:,n_meas) = measureAvg.PerSampleSINR;
        measureMeth{mth}.AverageSINR(n_meas,1) =  measureAvg.AverageSINR;
        
        measureMeth{mth}.SamplePower(:,n_meas) =  measureAvg.SamplePower;
        measureMeth{mth}.SampleError(:,n_meas) = measureAvg.SampleError;
        
        measureMeth{mth}.SymbolError(:,n_meas) =  measureAvg.SymbolError;
        measureMeth{mth}.SymbolPower(:,n_meas) = measureAvg.SymbolPower;
        
        measureMeth{mth}.AverageSymbolPower(n_meas,1) = measureAvg.AverageSymbolPower;
        measureMeth{mth}.AverageSymbolError(n_meas,1) =  measureAvg.AverageSymbolError;
        
    end
    
end

end

function measureMeth = Concatenate(measureCell, direction)
if strcmp(direction, 'r')
[N_mth, N_meas] = size(measureCell); % method and snr, cfo, etc
else
    [N_meas, N_mth] = size(measureCell); % method and snr, cfo, etc
end

N_sample = length(measureCell{1,1}{1}.SamplePower);
N_symbol = length(measureCell{1,1}{1}.SymbolPower);

for mth = 1:N_mth
    measureAvg = CreateAverageMeasurments(N_sample, N_symbol, N_meas);
    measureMeth{mth} = measureAvg;
end
% do concatenation
for mth = 1:N_mth
    for n_meas = 1:N_meas
        if strcmp(direction, 'r')
        measureAvg = measureCell{mth,n_meas}{1};
        else
            measureAvg = measureCell{n_meas,mth}{1};
        end
        
        measureMeth{mth}.CodedBER(n_meas,1) = measureAvg.CodedBER;
        measureMeth{mth}.BER(n_meas,1) = measureAvg.BER;
        measureMeth{mth}.FER(n_meas,1) =  measureAvg.FER;
        
        measureMeth{mth}.PerSymbolNMSE(:,n_meas) = measureAvg.PerSymbolNMSE;
        measureMeth{mth}.SymbolNMSE(n_meas,1) =  measureAvg.SymbolNMSE ;
        
        measureMeth{mth}.PerSampleSINR(:,n_meas) = measureAvg.PerSampleSINR;
        measureMeth{mth}.AverageSINR(n_meas,1) =  measureAvg.AverageSINR;
        
        measureMeth{mth}.SamplePower(:,n_meas) =  measureAvg.SamplePower;
        measureMeth{mth}.SampleError(:,n_meas) = measureAvg.SampleError;
        
        measureMeth{mth}.SymbolError(:,n_meas) =  measureAvg.SymbolError;
        measureMeth{mth}.SymbolPower(:,n_meas) = measureAvg.SymbolPower;
        
        measureMeth{mth}.AverageSymbolPower(n_meas,1) = measureAvg.AverageSymbolPower;
        measureMeth{mth}.AverageSymbolError(n_meas,1) =  measureAvg.AverageSymbolError;
        
    end
    
end

end
