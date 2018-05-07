function imp = OTFS_LTV_Doppler(K, M, Ncp, ChCode, N_run1, SNR, rxType, ChType, fs, fD, seed, Nf)
% Core parameters
rng(seed);
N = M*K;
NB = ChCode.Nb;

[ K_set, M_set, Wt, ~, ~, EsN0, N0, imp, params, N_run, N_fD] = Generate_common_Doppler( K,M,NB, SNR, N_run1, fD, 0 );
Non = ChCode.Non;
for n_fd =1:N_fD
    rchan = GenFadingChannel( ChType, fD(n_fd), fs);
    for n_run = 1: N_run(n_fd)
        info_bits = zeros(ChCode.Nr_infobits, Nf);
        encoded_bits = zeros(ChCode.Ncbpsym,Nf);
        qam_data = zeros(ChCode.Non* Nf, NB);
        for nf =1:Nf
            info_bits(:,nf) = randi([0 1],ChCode.Nr_infobits,1);
            [ qam_data((1:Non)+Non*(nf-1),:), encoded_bits(:,nf)] = Encoder(ChCode, info_bits(:,nf));
        end
        
        Tx.InfoBits = info_bits;
        Tx.EncodedBits = encoded_bits;
        Tx.Symbols = qam_data(:);
        
        %% generate  noise per run
        
        v = GenRandomNoise([NB*(N+K*Ncp),1], 1);
        Xt_otfs = zeros(M, NB*K);
        %% OTFS TX
        for nb=1:NB
            D = ResourceMap(qam_data(:,nb), K_set, M_set, K,M);
            X = GeneralModulator(D, K_set, Wt,'TD');
            Xt_otfs(:, (nb-1)*K+(1:K)) = X;
        end
        %% OTFS TX ...............................
        Tx.Xf = Xt_otfs(:);
        Tx.xt = 0;
        
        Xt_otfs_CP = AddCpCs( Xt_otfs, M, Ncp, 0);
        
        %% LTV channel
        [ He_otfs, Yr_otfs ] = ApplyChannel( rchan, Xt_otfs_CP, Ncp);
        
        
        %% OTFS RX
        Yr = Yr_otfs + sqrt(N0)*(reshape(v,M+Ncp,K));
        %% remove CP
        Yeq =  RemoveCpCs( Yr, M, Ncp);
        Rx.Xf = Yeq(:);
        Rx.Vf = 0; % noise sample
        %% channel estimation
        He = He_otfs(Ncp+(1:M),:);
        Hfe  = fft(He);
        
        qam_data_e = zeros(size(qam_data));
        EsNo_vec   = zeros(size(qam_data));
        for nb=0:NB-1
            %% combined demodulation equlaization
            Wte = Wt.* transpose(Hfe(:,nb*K+(1:K)));
            Wre = ReceiveWindow( Wte , rxType, EsN0/K);
            D_e =  GeneralDemodulator( Yeq(:,nb*K+(1:K)), K_set, Wre, 'TD' );
            
            qam_data_e(:,nb+1) = ResourceDemap(D_e, K_set, M_set);
            temp = 1/M/EsN0*norm(Wre, 'fro')^2+ 1/N*norm(Wre.*Wte-1,'fro')^2;
            EsNo_vec(:,nb+1) = 1/temp ;
        end
        %% Decoder
        bits_e = zeros(ChCode.Nr_infobits, Nf);
        encoded_bits_e = zeros(ChCode.Ncbpsym,Nf);
        qam_data_e = reshape(qam_data_e, Non, Nf,NB);
        EsNo_vec = reshape(EsNo_vec, Non, Nf,NB);
        for nf =1:Nf
            ChCode.info_bits = info_bits(:,nf);
            [ bits_e(:,nf), encoded_bits_e(:,nf)] = Decoder( ChCode, reshape(qam_data_e(:,nf,:),Non*NB,1), reshape(EsNo_vec(:,nf,:),Non*NB,1) );
        end
        
        Rx.InfoBits = bits_e;
        Rx.EncodedBits = encoded_bits_e;
        Rx.Symbols = qam_data_e(:);
        imp{n_fd} = imp{n_fd}.Measure(imp{n_fd}, params,Tx, Rx);
    end
end
%%
imp = imp{1}.AverageAndConcatenate(imp);
end

