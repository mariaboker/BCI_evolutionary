function [H, vrotulos] = trataSinais(sujeito)
%%%%% DEFINICAO DE PARAMETROS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    nsess_total = 10; % sao 20, mas estao separadas de 10 em 10 right left

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    H = [];
    vrotulos = [];

    num_eletr_orig = 16;

    % Treinar com 70% das sessoes definidas aleatoriamente
    for ss = 1:nsess_total
        %ss
        IDSessao = num2str(ss);
        %%%%% PRE-PROCESSAMENTO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % pre-processa mao esquerda
        arquivo = ['smr_training_session_' IDSessao '_leftHand_subject_' sujeito '_lrh.mat'];
        load(arquivo);

        sessao = rawData';

        ref_CAR = mean(sessao);
        matriz_ref_CAR = ones(num_eletr_orig, 1) * ref_CAR;
        dados_esq = sessao - matriz_ref_CAR;


        % pre processa mao direita
        arquivo = ['smr_training_session_' IDSessao '_rightHand_subject_' sujeito '_lrh.mat'];
        load(arquivo);

        sessao = rawData';

        ref_CAR = mean(sessao);
        matriz_ref_CAR = ones(num_eletr_orig, 1) * ref_CAR;
        dados_dir = sessao - matriz_ref_CAR;


        %%%%% EXTRACAO DE CARACTERISTICAS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
        % Cada linha da matriz possui o conjunto de atributos janela atual
        % Cada elemento da linha é um atributo e cada conjunto de 3 elementos relaciona-se com um eletrodo

        % para a mao esquerda

        for j = 1:8                                                                % da primeira ate a ultima janela
            
            atributosE = [];                                                        % cria um vetor de atributos para cada janela
            atributosD = [];     

            for e = 1:(num_eletr_orig)    
                
                inicio = 1 + (j - 1) * 256 * 1;                           % indice da primeira amostra da janela
                fim = inicio + 256 * 3 - 1;                                 % indice da ultima amostra da janela

                janela_esq = dados_esq(e,inicio:fim);                                  % vetor com as amostras selecionadas formando a janela com (Famost * Tjanela) elementos
                janela_dir = dados_dir(e,inicio:fim);

                [PxxE,FE] = pwelch(janela_esq, [], [], [1:20], 256);                     % aplicacao do metodo de P Welch na janela atual
                [PxxD,FD] = pwelch(janela_dir, [], [], [1:20], 256); 

                atrib_welch_esq = [sum(PxxE(8:12)), sum(PxxE(13:16)), sum(PxxE(17:20))]; % cada atributo eh a soma das potencias de cada uma das bandas escolhidas
                atrib_welch_dir = [sum(PxxD(8:12)), sum(PxxD(13:16)), sum(PxxD(17:20))];                                                                     % no caso usamos as bandas de 8 a 12 Hz, de 13 a 16 Hz e de 17 a 20 Hz

                atributosE = [atributosE, atrib_welch_esq];
                atributosD = [atributosD, atrib_welch_dir];                          % concatenacao dos atributos do PWelch do eletrodo atual com os dos outros eletrodos da janela atual

            end

            Hesq(j,:) = [atributosE, 1];                                           % acrescenta-se um vetor coluna de valor '1' na ultima coluna da matriz                              
            Hdir(j,:) = [atributosD, 1];
           
        end


        % Concatena-se as duas matrizes da sessao
        Hsessao = vertcat(Hesq, Hdir);

        % Cria-se um vetor de rotulos de acordo com a mao que a linha representa
        % Convenç£¯: -1 para esquerda e +1 para direita
        vrotulos_sessao = ones(8 * 2, 1);
        
        for k = 1:8
            vrotulos_sessao(k, 1) = vrotulos_sessao(k, 1) * -1; % primeiros sao esquerda
        end

        % concatena-se Hsessao da sessao atual com a H final > tamanho final = 160 linhas
        H = vertcat(H, Hsessao);    
        
        %concatena-se vrotulos_sessao da sessao atual com vrotulos final
        vrotulos = vertcat(vrotulos, vrotulos_sessao);

    end
