%%%%%% DEFINICAO DE FUNCOES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                               TREINAMENTO                               %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function W = treinamento(H, vrotulos, eletrodos)
    global nsess_trein;
    global valor_string;

    %%%%% DEFINICAO DE PARAMETROS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    nsess_total = 20; 
    nsess_trein = nsess_total * 0.7;

    valor_string = randperm(nsess_total);

    %eletr_uteis = lista_eletrodos(1:length(lista_eletrodos));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %%%%% CLASSIFICACAO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    H_trein = [];
    vrotulos_trein  = [];

    for k = 1:nsess_trein
        indice_sess = num2str(valor_string(k));        % escolhe aleatoriamente quais sessoes serao usadas
        
        Hk = [];
        vrotulosk = [];

        inicio = 16 * (indice_sess-1)+1;
        fim = 16 * indice_sess;
        
        for kk = inicio:fim
            Hk = H(kk,:);
            vrotulosk = vrotulos(kk,:);
        end

        H_trein = vertcat(H_trein, Hk)
        vrotulos_trein = vertcat (vrotulos_trein, vrotulosk);

    end


    %%%%%%%% AQUI SO PEGA OS ROTULOS E OS W DOS ELETRODOS DA VEZ
    % Calculo da matriz W usada na solucao otima
    W = pinv(H_trein) * vrotulos_trein;

    % Calculo da saida do Classificador
    y = H_trein * W;


    EQM = mean((y - vrotulos_trein).^2);
    Erro = (0.5 * sum(abs(sign(y) - vrotulos_trein))) / length(y);

    % printf('EQM Trein = %d e NumSessoes Trein = %d\n', EQM, Erro);
