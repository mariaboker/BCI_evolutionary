function [fitness, Erropop] = fit(H, vrotulos, populacao)

    global EQM_pop;
	[Nind,~] = size(populacao);

	for kk = 1:Nind
        
		individuo = populacao(kk,:);
		
		% Conversao de codificacao binaria para ID de eletrodos
		eletrodos = [];
        nEletr = 16;
        
		for u = 1:nEletr
			if (individuo(u) == 1)
				eletrodos = [eletrodos u];
            end
        end

		W_atual = treinamento(H, vrotulos, eletrodos); 				 %% passa os eletrodos da populacao para treinamento
		[ErroSessao, EQM_atual] = teste(H, vrotulos, eletrodos, W_atual);		 %% testa com aquela populacao

		EQM_pop(kk) = EQM_atual; 	%% vetor guarda os EQM de cada individuo da populacao        
        Erropop(kk) = ErroSessao;%% vetor guarda os erros de cada individuo da populacao        

		% calcula a fitness do individuo
		fitness(kk) = (1/(EQM_atual + 1));

    end
    
    ele = ID(eletrodos)
end

