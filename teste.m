%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                                 TESTE                                   %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% obs tipo_erro deve ser EQM para obter quadratico medio, e qualquer outra coisa para o numero de sessoes
function [ErroSess, EQM] = teste(H, vrotulos, eletrodos, W)

    global nsess_total 20;
    global nsess_trein = nsess_total * 0.7;
    
    H_teste = [];
    vrotulos_teste = [];

    % Testar com as sessoes que nao foram usadas no treinamento
    for ss = nsess_trein+1:nsess_total
        indice_sess = num2str(valor_string(k));   
    end

     Hk = [];
        vrotulosk = [];

        inicio = 16 * (indice_sess-1)+1;
        fim = 16 * indice_sess;
        
        for kk = inicio:fim
            Hk = H(kk,:);
            vrotulosk = vrotulos(kk,:);
        end

        H_teste = vertcat(H_teste, Hk)
        vrotulos_teste = vertcat (vrotulos_teste, vrotulosk);

    end

    y_teste = H_teste * W; % usa W do treinamento


    EQM = mean((y_teste - vrotulos_teste).^2);
    %disp('EQM Teste = %d\n', Erro);

    ErroSess = (0.5 * sum(abs(sign(y_teste) - vrotulos_teste))) / length(y_teste);
    %disp('Num de Sessoes Teste = %d\n', Erro);

end
