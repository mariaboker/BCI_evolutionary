%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                                 TESTE                                   %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% obs tipo_erro deve ser EQM para obter quadratico medio, e qualquer outra coisa para o numero de sessoes
function [ErroSess, EQM] = teste(H, vrotulos, eletrodos, W)
    global nsess_total 
    nsess_total = 10;

    global nsess_trein 
    nsess_trein = nsess_total * 0.7;
    global valor_string;
    
    H_teste = [];
    vrotulos_teste = [];

    % Testar com as sessoes que nao foram usadas no treinamento
    for ss = nsess_trein+1:nsess_total 
        %indice_sess = valor_string(ss)
        indice_sess = ss; 

        Hk = [];
        vrotulosk = [];

        inicio = 16 * (indice_sess-1)+1;
        fim = 16 * indice_sess;
        
        for kk = inicio:fim
             Hk = vertcat(Hk,H(kk,:));
             vrotulosk = vertcat(vrotulosk,vrotulos(kk,:)); 
        end

        H_teste = vertcat(H_teste, Hk);
        vrotulos_teste = vertcat (vrotulos_teste, vrotulosk);
    end


    indices = [];
    

    for mm = 1:length(eletrodos)
        indices = vertcat(indices, [3*(eletrodos(mm)-1)+1:3*eletrodos(mm)]);
    end
      
    
    H_teste = [H_teste(:,indices),H_teste(:,end)];
    y_teste = H_teste * W; % usa W do treinamento


    EQM = mean((y_teste - vrotulos_teste).^2);
    ErroSess = (0.5 * sum(abs(sign(y_teste) - vrotulos_teste))) / length(y_teste)

    
