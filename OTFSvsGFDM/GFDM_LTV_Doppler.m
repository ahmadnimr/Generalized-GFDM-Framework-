function imp = GFDM_LTV_Doppler(K, M, Ncp, ChCode, N_run1, SNR, rxType, ChType, fs, fD, seed, isOFDM)
% Core parameters
rng(seed);
N = M*K;
NB = ChCode.Nb;

[ K_set, M_set, Wt, Wfr, Vg, EsN0, N0, imp, params, N_run, N_fD] = Generate_common_Doppler( K,M,NB, SNR, N_run1, fD, isOFDM );

for n_fd =1:N_fD
    rchan = GenFadingChannel( ChType, fD(n_fd), fs);
    for n_run = 1: N_run(n_fd)        
        %% generated data
        info_bits = randi([0 1],ChCode.Nr_infobits,1);
        [ qam_data, encoded_bits] = Encoder(ChCode, info_bits);
        
        Tx.InfoBits = info_bits;
        Tx.EncodedBits = encoded_bits;
        Tx.Symbols = qam_data;
        
        % generate  noise per run
        v = GenRandomNoise([NB*(N+Ncp),1], 1);
        Xt_gfdm = zeros(N,NB);
        %% GFDM TX
        for nb=1:NB
            D = ResourceMap(qam_data(:,nb), K_set, M_set, K,M);
            X = GeneralModulator(D, K_set, Wt,'TD');
            Xt_gfdm(:,nb) = reshape(X.',N,1);
        end
        Tx.Xf = Xt_gfdm;
        Tx.xt = 0;
        Xt_gfdm_CP = AddCpCs( Xt_gfdm, N, Ncp, 0);
        %% LTV channel
        [ He_gfdm, Yr_gfdm ] = ApplyChannel( rchan, Xt_gfdm_CP, Ncp);
        
        %% Additive noise
        Yr = Yr_gfdm + sqrt(N0)*reshape(v(1:numel(Yr_gfdm)), size(Yr_gfdm));
        %% remove CP
        Y =  RemoveCpCs( Yr, N, Ncp);
        Yf = fft(Y);
        Rx.Xf = Y;
        Rx.Vf = 0; % noise sample
        
        %% channel estimation
        He = He_gfdm(Ncp+(1:N),:);
        Hfe  = fft(He);
        
        qam_data_e = zeros(size(qam_data));
        EsNo_vec   = zeros(size(qam_data));
        for nb=1:NB
            %% equalizer
            Hfeq = ReceiveWindow( Hfe(:,nb), rxType, EsN0);
            y_eq = Hfeq.*Yf(:,nb);
            %% Demodulator
            Yeqf = transpose(reshape(y_eq, M,K));
            if (~isOFDM) % bypass demodulator
                D_e =  GeneralDemodulator( Yeqf, K_set, Wfr, 'FD' );
            else
                D_e = Yeqf*Wfr(1); % only scaler window
            end
            %% Demap
            qam_data_e(:,nb) = ResourceDemap(D_e, K_set, M_set);
            %% SNRs per symbols
            EsNo_vec(:,nb) = ComputeSNR( Vg, Hfe(:,nb), Hfeq, EsN0, isOFDM );
        end
        %% Decoder
        ChCode.info_bits = info_bits;
        [ bits_e, encoded_bits_e ] = Decoder( ChCode, qam_data_e(:), EsNo_vec(:));
        
        Rx.InfoBits = bits_e;
        Rx.EncodedBits = encoded_bits_e;
        Rx.Symbols = qam_data_e;
        
        imp{n_fd} = imp{n_fd}.Measure(imp{n_fd}, params,Tx, Rx);
    end
end
%%
imp = imp{1}.AverageAndConcatenate(imp);
end
