function fitness = fit(populacao)

    % pre alocacao de vetores para maior velocidade
    %fitness = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    %EQM_pop = [1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000];
    
	[Nind,~] = size(populacao);

	for kk = 1:Nind
        kk
		individuo = populacao(kk,:);
		
		% Conversao de codificacao binaria para ID de eletrodos
		eletrodos = [];
        nEletr = 16;
        %[~, nEletr] = size(individuo);
        
		for u = 1:nEletr
			if individuo(u) == 1
				eletrodos = [eletrodos u];
            end
        end

		W_atual = treinamento(eletrodos); 				 %% passa os eletrodos da populacao para treinamento
		[~, EQM_atual] = teste(eletrodos, W_atual);		 %% testa com aquela populacao

		EQM_pop(kk) = EQM_atual; 	%% vetor guarda os EQM de cada individuo da populacao 

		% calcula a fitness do individuo
		fitness(kk) = (1/(EQM_atual + 1));

	end
end